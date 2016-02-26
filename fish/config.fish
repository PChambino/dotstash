# clear greeting message
set fish_greeting

# setup rbenv
if which rbenv > /dev/null
  # rbenv init -
  pushto PATH ~/.rbenv/shims
  setenv RBENV_SHELL fish
  . /usr/local/Cellar/rbenv/HEAD/completions/rbenv.fish
  rbenv rehash 2>/dev/null
  function rbenv
    set command $argv[1]
    set -e argv[1]

    switch "$command"
    case rehash shell
      eval (rbenv "sh-$command" $argv)
    case '*'
      command rbenv "$command" $argv
    end
  end

  # Bundler
  pushto PATH ./bin # for project-specific binstubs
  alias b='bundle exec'
end

# PATH for OS X
# if test (uname) = 'Darwin' -a (cat /etc/launchd.conf) != (echo setenv PATH (joins : $PATH))
#   set_color -o red
#   echo "Update your /etc/launchd.conf to:"
#   echo setenv PATH (joins : $PATH)
#   set_color normal
# end

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