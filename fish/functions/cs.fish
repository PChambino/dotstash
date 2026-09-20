# List, jump to, and reopen the Claude sessions living in tmux panes.
#
# Live rows come from claude-sessions; after a reboot there are none, and the
# snapshot tmux-claude-status keeps on an interval is what -r reopens from.
function cs -d "list, jump to, or reopen Claude sessions"
    argparse -X 1 h/help p/pick r/restore colours -- $argv
    or return 1

    if set -q _flag_help
        printf '%s\n' \
            'cs              list the Claude sessions running in tmux' \
            'cs <name>       jump to the pane running the matching session' \
            'cs -p           pick a session with fzf, and jump to it' \
            'cs -p <name>    pick among the matching ones' \
            'cs -r           reopen the previous server\'s sessions here' \
            'cs -r <name>    reopen only the matching ones' \
            'cs --colours    show the status colours'
        return 0
    end

    if set -q _flag_colours
        __cs_colours
        return 0
    end

    set -l snapshot ~/.local/state/claude/sessions.tsv
    set -q CLAUDE_SESSIONS_SNAPSHOT
    and set snapshot $CLAUDE_SESSIONS_SNAPSHOT

    if set -q _flag_restore
        __cs_restore $snapshot $argv
        return
    end

    set -l rows (claude-sessions)
    set -l dead 0
    if not set -q rows[1]
        test -s $snapshot
        or begin
            echo 'cs: no Claude sessions' >&2
            return 1
        end
        set rows (cat $snapshot)
        set dead 1
        echo 'cs: nothing live — this is the last snapshot, `cs -r` reopens it' >&2
    end

    if set -q _flag_pick
        if set -q argv[1]
            set rows (__cs_match $argv[1] $rows)
            or return 1
        end
        set -l row (__cs_pick $rows)
        or return 1
        if test $dead -eq 1
            __cs_open $row
        else
            __cs_jump $row
        end
        return
    end

    if not set -q argv[1]
        printf '%s\n' $rows | __cs_format
        return 0
    end

    # An exact window name wins outright; otherwise the freshest match does.
    set -l target
    for row in $rows
        if test (string split \t -- $row)[9] = "$argv[1]"
            set target $row
            break
        end
    end

    if not set -q target[1]
        set -l hits (__cs_match $argv[1] $rows)
        or return 1
        set target $hits[1]
        if set -q hits[2]
            echo "cs: "(count $hits)" matches, taking the freshest ("(string split \t -- $target)[9]")" >&2
        end
    end

    if test $dead -eq 1
        __cs_open $target
    else
        __cs_jump $target
    end
end

# Rows whose window, path or branch contain <name>, freshest first.
function __cs_match
    set -l name $argv[1]
    set -e argv[1]

    set -l hits
    for row in $argv
        set -l f (string split \t -- $row)
        string match -qi -- "*$name*" "$f[9] $f[2] $f[3]"
        and set -a hits $row
    end

    if not set -q hits[1]
        echo "cs: no session matching '$name'" >&2
        return 1
    end
    printf '%s\n' $hits | sort -t\t -k5,5rn
end

# status  SGR  label; the one table the listing and --colours share.
function __cs_palette
    printf '%s\n' \
        'working            32 working' \
        'compacting         96 compacting' \
        'idle               38;5;248 idle' \
        'waiting_input      93 waiting' \
        'waiting_permission 31 permission' \
        'error              31 error'
end

function __cs_colours
    echo 'cs status column'
    __cs_palette | awk '
        BEGIN { esc = sprintf("%c", 27); off = esc "[0m" }
        { printf "  %-19s %s%-12s%s SGR %s\n", $1, esc "[" $2 "m", $3, off, $2 }'
end

# Rows in, one padded and coloured line each. Every column is cut to fit, the
# prompt taking whatever width is left over. The palette rides in ahead of the
# rows as C records, awk -v not carrying the newlines it would otherwise need.
function __cs_format
    begin
        __cs_palette | awk '{print "C\t" $1 "\t" $2 "\t" $3}'
        cat
    end | awk -F\t -v now=(date +%s) -v cols=$COLUMNS '
        function fit(s, n) {
            return length(s) > n ? substr(s, 1, n - 1) "…" : s
        }
        BEGIN {
            esc = sprintf("%c", 27); off = esc "[0m"
            # COLUMNS is unset when fish is not interactive.
            room = (cols > 0 ? cols : 120) - 86
        }

        $1 == "C" { c[$2] = esc "[" $3 "m"; label[$2] = $4; next }

        {
            path = $2; branch = $3; state = $4; act = $5
            widx = $8; wname = $9; prompt = $11

            project = path; sub(/.*\//, "", project)
            # A window is usually named after its project or its branch.
            if (project == wname) project = ""
            if (branch == wname) branch = ""

            secs = now - act
            if (act == 0)          age = "-"
            else if (secs < 3600)  age = int(secs / 60) "m"
            else if (secs < 86400) age = int(secs / 3600) "h"
            else                   age = int(secs / 86400) "d"

            if (!(state in c)) c[state] = c["idle"]
            shown = (state in label) ? label[state] : state

            printf "%-24s %-16s %-26s %s%-10s%s %4s  %s\n",
                fit(widx ":" wname, 24), fit(project, 16), fit(branch, 26),
                c[state], fit(shown, 10), off, age,
                (room < 8 ? "" : fit(prompt, room))
        }'
end

function __cs_pick
    set -l display (printf '%s\n' $argv | __cs_format)
    set -l lines
    for i in (seq (count $argv))
        set -a lines (printf '%s\t%s' $i $display[$i])
    end

    set -l sel (printf '%s\n' $lines \
        | fzf --delimiter=\t --with-nth=2 --ansi --prompt='claude> ')
    test -n "$sel"
    or return 1
    echo $argv[(string split \t -- $sel)[1]]
end

function __cs_jump
    set -l f (string split \t -- $argv[1])
    tmux switch-client -t $f[6]
    tmux select-window -t $f[7]
    tmux select-pane -t $f[10]
end

# Backs `cs -r`. Live sessions are filtered out, so .prev runs dry as they come
# back up and the search falls through to this server's own snapshot.
function __cs_restore -d "Reopen the previous server's sessions"
    set -l snapshot $argv[1]
    set -e argv[1]

    set -l live
    for row in (claude-sessions)
        set -a live (string split \t -- $row)[1]
    end

    set -l rows
    for file in $snapshot.prev $snapshot
        test -s $file
        or continue
        set rows
        for row in (cat $file)
            set -l f (string split \t -- $row)
            contains -- $f[1] $live
            and continue
            if set -q argv[1]
                string match -qi -- "*$argv[1]*" "$f[9] $f[2] $f[3]"
                or continue
            end
            set -a rows $row
        end
        set -q rows[1]
        and break
    end

    if not set -q rows[1]
        echo 'cs: nothing to reopen'
        return 0
    end

    printf '%s\n' $rows | __cs_format
    read -l -P "reopen "(count $rows)" session(s)? [y/N] " reply
    or return 1
    string match -qr '^[yY]' -- $reply
    or return 1

    __cs_open $rows
end

# One window per window the snapshot recorded, one pane per session in it, in
# the current tmux session or, from outside, the one the snapshot names.
function __cs_open
    set -l dest
    set -l attach
    set -l spare

    if not set -q TMUX
        set attach (string split \t -- $argv[1])[6]
        if not tmux has-session -t "=$attach" 2>/dev/null
            tmux new-session -d -s $attach
            or return 1
            # The window a new session comes with is not one of ours.
            set spare (tmux display-message -p -t "=$attach:" '#{window_id}')
        end
        set dest -t "$attach:"
    end

    set -l prev ""
    set -l pane ""
    set -l opened 0

    for row in $argv
        set -l f (string split \t -- $row)

        if not test -d "$f[2]"
            echo "cs: $f[9] — $f[2] is gone, skipping" >&2
            continue
        end

        if test "$f[7]" != "$prev"
            set pane (tmux new-window $dest -P -F '#{pane_id}' -n $f[9] -c $f[2])
            set prev $f[7]
        else
            set pane (tmux split-window -P -F '#{pane_id}' -t $pane -c $f[2])
            tmux select-layout -t $pane tiled >/dev/null
        end

        # send-keys, not `claude` as the pane's command: quitting it would
        # otherwise take the pane down too.
        tmux send-keys -t $pane "claude --resume $f[1]" Enter
        set opened (math $opened + 1)
    end

    echo "reopened $opened session(s)"

    if set -q spare[1]
        if test $opened -gt 0
            tmux kill-window -t $spare
        else
            # Nothing went in, so the session we made is not worth keeping.
            tmux kill-session -t "=$attach"
            set -e attach
        end
    end
    if set -q attach[1]
        tmux attach -t "=$attach"
    end
end
