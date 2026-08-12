# cd into a git worktree, defaulting to the most recently created one.
# Driven by `git worktree list`, so .worktrees/ and .claude/worktrees/ both
# just work, in any repo, from anywhere inside it.
function wt -d "cd to a git worktree, newest first"
    argparse -X 1 h/help l/list m/main p/pick prune -- $argv
    or return 1

    if set -q _flag_help
        printf '%s\n' \
            'wt              cd to the newest worktree, or back out to the main checkout' \
            'wt <name>       cd to the newest worktree matching <name>' \
            'wt -            cd to the previous directory, as `cd -`' \
            'wt -l           list worktrees, newest first' \
            'wt -m           cd to the main checkout' \
            'wt -p           pick a worktree with fzf' \
            'wt -p <name>    page that worktree'\''s preview; <name> may be a path' \
            'wt --prune [n]  remove worktrees idle over n days (default 30), branches kept'
        return 0
    end

    # A lone `-` is just `cd -`. Handled before the repo check because going back
    # where you came from is worth doing whether or not there's a repo here.
    if test "$argv[1]" = -
        cd -
        return
    end

    # `wt -p <dir>` previews a path outright. Handled before the repo check so it
    # works anywhere, including a repo with no worktrees of its own.
    if set -q _flag_pick; and set -q argv[1]; and test -d $argv[1]
        wt-preview $argv[1] | less -RFX
        return
    end

    # In a linked worktree these two differ: --git-dir is <common>/worktrees/<id>.
    set -l gitdirs (git rev-parse --path-format=absolute --git-dir --git-common-dir 2>/dev/null)
    if not set -q gitdirs[2]
        echo 'wt: not inside a git repository' >&2
        return 1
    end

    set -l main (git worktree list --porcelain | string replace -f 'worktree ' '')[1]

    if set -q _flag_main
        cd $main
        return
    end

    if set -q _flag_prune
        __wt_prune $main $argv
        return
    end

    if not set -q argv[1]; and not set -q _flag_list; and not set -q _flag_pick
        # Bare `wt` toggles on where you are: out to the main checkout from
        # inside a worktree, in to the newest worktree from the main checkout.
        if test $gitdirs[1] != $gitdirs[2]
            cd $main
            return
        end
    end

    set -l rows (wt-list)
    or begin
        echo "wt: no worktrees in "(basename $main) >&2
        return 1
    end

    # Same list and preview the nvim <leader>w picker uses; reshaped to
    # "path <tab> display" so the padding is ours and {1} stays the path.
    if set -q _flag_pick; and not set -q argv[1]
        set -l sel (printf '%s\n' $rows \
            | awk -F\t '{printf "%s\t%-50s %s\n", $2, $3, $5}' \
            | fzf --delimiter=\t --with-nth=2 --ansi \
                --prompt='worktree> ' --preview='wt-preview {1}')
        test -n "$sel"
        or return 1
        cd (string split \t -- $sel)[1]
        return
    end

    if set -q _flag_list
        for row in $rows
            set -l f (string split \t -- $row)
            printf '%-50s %s\n' $f[3] $f[5]
        end
        return 0
    end

    # Work out which worktree is meant, then either preview it or cd into it.
    set -l target
    if not set -q argv[1]
        set target (string split \t -- $rows[1])[2]
    else
        # An exact name wins outright; otherwise take the newest substring match.
        set -l hits
        for row in $rows
            set -l f (string split \t -- $row)
            if test $f[3] = $argv[1]
                set target $f[2]
                break
            end
            string match -qi -- "*$argv[1]*" $f[3]
            and set -a hits $row
        end

        if not set -q target[1]
            if not set -q hits[1]
                echo "wt: no worktree matching '$argv[1]'" >&2
                return 1
            end
            set -l f (string split \t -- $hits[1])
            if set -q hits[2]
                echo "wt: "(count $hits)" matches, taking the newest ($f[3])" >&2
            end
            set target $f[2]
        end
    end

    if set -q _flag_pick
        wt-preview $target | less -RFX
        return
    end
    cd $target
end

# Backs `wt --prune`. Only the checkouts go: the branches stay, so anything
# committed is still reachable by name, and that is what makes a bare `y` safe.
#
# Idle is the newer of the worktree's birth and its last commit. Directory mtime
# would be no use — a background build touches it — and last commit alone would
# sweep a worktree created today off an ancient branch.
function __wt_prune -d "Remove worktrees idle longer than <days>"
    set -l main $argv[1]
    set -l days 30
    set -q argv[2]
    and set days $argv[2]
    if not string match -qr '^\d+$' -- $days
        echo "wt: --prune wants a number of days, not '$days'" >&2
        return 1
    end

    set -l rows (wt-list)
    or begin
        echo "wt: no worktrees in "(basename $main) >&2
        return 1
    end

    set -l now (date +%s)
    set -l cutoff (math "$now - $days * 86400")
    set -l paths
    set -l lines

    for row in $rows
        set -l f (string split \t -- $row)
        set -l idle $f[1]
        set -l last (git -C $f[2] log -1 --format=%ct 2>/dev/null)
        if test -n "$last"; and test $last -gt $idle
            set idle $last
        end
        test $idle -lt $cutoff
        or continue

        # Uncommitted work goes too, but not without saying so first.
        set -l tag ""
        if test (git -C $f[2] status --porcelain 2>/dev/null | count) -gt 0
            set tag "  "(set_color yellow)uncommitted(set_color normal)
        end

        set -a paths $f[2]
        set -a lines (printf '  %-50s %4dd ago' $f[3] (math "floor(($now - $idle) / 86400)"))"$tag"
    end

    if not set -q paths[1]
        echo "wt: nothing idle longer than $days days"
        return 0
    end

    printf '%s\n' $lines
    read -l -P "remove "(count $paths)" worktree(s), keeping their branches? [y/N] " reply
    or return 1
    string match -qr '^[yY]' -- $reply
    or return 1

    set -l gone 0
    for path in $paths
        git -C $main worktree remove --force $path
        or continue
        set gone (math $gone + 1)
        # A nested id such as source/finance-mi leaves its parent behind. rmdir
        # takes it once the last child goes, and refuses harmlessly until then.
        # The two containers themselves stay put, empty or not.
        set -l parent (dirname $path)
        if not contains -- $parent $main $main/.worktrees $main/.claude/worktrees
            rmdir $parent 2>/dev/null
        end
    end

    git -C $main worktree prune
    echo "removed $gone worktree(s)"
end
