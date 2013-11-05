# clear greeting message
set fish_greeting

# /usr/local/bin to top of the PATH
pushto PATH /usr/local/bin

# setup z
begin
  set -l Z ~/.config/fish/z.fish
  test -e $Z; and . $Z
end

# setup rbenv
if which rbenv > /dev/null
  pushto PATH ~/.rbenv/shims
  rbenv rehash > /dev/null ^&1
  function b
    bundle exec $argv
  end
end

# PATH for OS X
if test (uname) = 'Darwin' -a (cat /etc/launchd.conf) != (echo setenv PATH (joins : $PATH))
  set_color -o red
  echo "Update your /etc/launchd.conf to:"
  echo setenv PATH (joins : $PATH)
  set_color normal
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
