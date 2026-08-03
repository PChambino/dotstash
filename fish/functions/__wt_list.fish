# Emit one tab-separated line per live git worktree, newest-created first:
#
#     birthtime <tab> path <tab> name <tab> branch <tab> age
#
# The main checkout is excluded - that's `wt -m`. Returns 1 if there are none.
function __wt_list -d "List git worktrees, newest first"
    set -l paths
    set -l branches

    for line in (git worktree list --porcelain 2>/dev/null)
        switch $line
            case 'worktree *'
                set -a paths (string replace 'worktree ' '' -- $line)
                set -a branches '' # filled in by the branch/detached line below
            case 'branch *'
                set branches[-1] (string replace -r '^branch refs/heads/' '' -- $line)
            case detached
                set branches[-1] detached
            case 'prunable*'
                # Registration outlived its checkout (Claude Code cleans these up
                # under .claude/worktrees); drop it so we never offer a dead path.
                set -e paths[-1]
                set -e branches[-1]
        end
    end

    set -q paths[2]
    or return 1 # no repo, or main checkout only

    set -l root $paths[1]
    set -l now (date +%s)

    # One stat(1) for the lot. Guard the count in case a directory vanishes
    # between the -d test and here, which would misalign the two lists.
    set -l live_paths
    set -l live_names
    set -l live_branches
    for i in (seq 2 (count $paths))
        test -d $paths[$i]
        or continue
        # Name relative to whichever worktrees dir holds it.
        set -l name (string replace -- $root/ '' $paths[$i])
        set name (string replace -r '^\.claude/worktrees/' 'claude/' -- $name)
        set name (string replace -r '^\.worktrees/' '' -- $name)
        set -a live_paths $paths[$i]
        set -a live_names $name
        set -a live_branches $branches[$i]
    end
    set -q live_paths[1]
    or return 1

    # %B is the birth time - when the worktree was created, which is what we sort on.
    # It has 1s granularity, so same-second siblings tie and fall back to git's order.
    set -l times (stat -f '%B' -- $live_paths 2>/dev/null)
    if test (count $times) -ne (count $live_paths)
        set times (string repeat -n (count $live_paths) 0\n | string split -n \n)
    end

    set -l rows
    for i in (seq (count $live_paths))
        set -l mins (math -s0 "($now - $times[$i]) / 60")
        set -l age
        if test $mins -lt 60
            set age $mins"m ago"
        else if test $mins -lt 1440
            set age (math -s0 $mins / 60)"h ago"
        else
            set age (math -s0 $mins / 1440)"d ago"
        end
        # The branch is usually just worktree/<name>; only worth showing when it isn't.
        if not contains -- $live_branches[$i] worktree/$live_names[$i] $live_names[$i]
            set age "$age  $live_branches[$i]"
        end
        set -a rows $times[$i]\t$live_paths[$i]\t$live_names[$i]\t$live_branches[$i]\t$age
    end

    printf '%s\n' $rows | sort -rn -t\t -k1,1
end
