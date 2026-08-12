# Completions for `wt`. Kept here rather than in completions/ because link.sh
# only links conf.d and functions.
#
# -k is the whole point: without it fish sorts the candidates alphabetically and
# throws away the newest-first order wt-list went to the trouble of producing.

function __wt_complete -d "Worktree completions for wt, newest first"
    for row in (wt-list)
        set -l f (string split \t -- $row)
        printf '%s\t%s\n' $f[3] $f[5]
    end
end

complete -c wt -x -k -a '(__wt_complete)'
complete -c wt -s l -l list -d 'List worktrees, newest first'
complete -c wt -s m -l main -d 'cd to the main checkout'
complete -c wt -s p -l pick -d 'Pick a worktree with fzf'
complete -c wt -l prune -d 'Remove worktrees idle longer than <days> (default 30)'
complete -c wt -s h -l help -d 'Display help and exit'
