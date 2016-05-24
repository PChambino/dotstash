# clear greeting message
set fish_greeting

if which ry > /dev/null
  pushto PATH /usr/local/lib/ry/current/bin
end

# fish git prompt
set __fish_git_prompt_showdirtystate        'yes'
set __fish_git_prompt_showstashstate        'yes'
set __fish_git_prompt_showuntrackedfiles    'yes'
set __fish_git_prompt_showupstream          'yes'

set __fish_git_prompt_color_bare             yellow
set __fish_git_prompt_color_merging          yellow
set __fish_git_prompt_color_branch           red
set __fish_git_prompt_color_dirtystate       yellow
set __fish_git_prompt_color_stagedstate      green
set __fish_git_prompt_color_stashstate       yellow
set __fish_git_prompt_color_untrackedfiles   red
set __fish_git_prompt_color_upstream         green

set __fish_git_prompt_char_dirtystate        '✗'
set __fish_git_prompt_char_stagedstate       '→'
set __fish_git_prompt_char_invalidstate      '⚡ '
set __fish_git_prompt_char_stashstate        '↩ '
set __fish_git_prompt_char_untrackedfiles    '?'
set __fish_git_prompt_char_upstream_equal    ''
set __fish_git_prompt_char_upstream_behind   '↓'
set __fish_git_prompt_char_upstream_ahead    '↑'
set __fish_git_prompt_char_upstream_diverged '<>'

# aliases
alias g=git
