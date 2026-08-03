# cd into a git worktree, defaulting to the most recently created one.
# Driven by `git worktree list`, so .worktrees/ and .claude/worktrees/ both
# just work, in any repo, from anywhere inside it.
function wt -d "cd to a git worktree, newest first"
    argparse -X 1 h/help l/list m/main -- $argv
    or return 1

    if set -q _flag_help
        printf '%s\n' \
            'wt              cd to the newest worktree, or back to the main' \
            '                checkout if already inside one' \
            'wt <name>       cd to the newest worktree matching <name>' \
            'wt -            cd to the previous directory, as `cd -`' \
            'wt -l           list worktrees, newest first' \
            'wt -m           cd to the main checkout'
        return 0
    end

    # A lone `-` is just `cd -`. Handled before the repo check because going back
    # where you came from is worth doing whether or not there's a repo here.
    if test "$argv[1]" = -
        cd -
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

    # Bare `wt` toggles on where you are: out to the main checkout from inside a
    # worktree, in to the newest worktree from the main checkout.
    if not set -q argv[1]; and not set -q _flag_list; and test $gitdirs[1] != $gitdirs[2]
        cd $main
        return
    end

    set -l rows (__wt_list)
    or begin
        echo "wt: no worktrees in "(basename $main) >&2
        return 1
    end

    if set -q _flag_list
        for row in $rows
            set -l f (string split \t -- $row)
            printf '%-50s %s\n' $f[3] $f[5]
        end
        return 0
    end

    if not set -q argv[1]
        cd (string split \t -- $rows[1])[2]
        return
    end

    # An exact name wins outright; otherwise take the newest substring match.
    set -l hits
    for row in $rows
        set -l f (string split \t -- $row)
        if test $f[3] = $argv[1]
            cd $f[2]
            return
        end
        string match -qi -- "*$argv[1]*" $f[3]
        and set -a hits $row
    end

    if not set -q hits[1]
        echo "wt: no worktree matching '$argv[1]'" >&2
        return 1
    end

    set -l f (string split \t -- $hits[1])
    if set -q hits[2]
        echo "wt: "(count $hits)" matches, taking the newest ($f[3])" >&2
    end
    cd $f[2]
end
