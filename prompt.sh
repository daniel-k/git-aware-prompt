find_git_branch() {
  # Based on: http://stackoverflow.com/a/13003854/170413
  local branch
  if branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null); then
    if [[ "$branch" == "HEAD" ]]; then
      branch='detached*'
    fi
    git_branch="($branch)"
  else
    git_branch=""
  fi
}

find_git_dirty() {
  local status=$(git status --porcelain 2> /dev/null)
  if [[ "$status" != "" ]]; then
    git_dirty='*'
  else
    git_dirty=''
  fi
}

shorten_path() {
    local git_root

    git_cwd="$(pwd)"

    if [ -z "$git_branch" ]; then
        [[ "$git_cwd" =~ ^"$HOME"(/|$) ]] && git_cwd="~${git_cwd#$HOME}"
    else
        git_root="$(git rev-parse --show-toplevel)"
        git_cwd="$(basename $git_root)${git_cwd#$git_root}/"
    fi
}

PROMPT_COMMAND="find_git_branch; find_git_dirty; shorten_path; $PROMPT_COMMAND"

export PS1="\${debian_chroot:+(\$debian_chroot)}\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\$git_cwd\[\033[00m\] \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "


# Default Git enabled prompt with dirty state
# export PS1="\u@\h \w \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "

# Another variant:
# export PS1="\[$bldgrn\]\u@\h\[$txtrst\] \w \[$bldylw\]\$git_branch\[$txtcyn\]\$git_dirty\[$txtrst\]\$ "

# Default Git enabled root prompt (for use with "sudo -s")
# export SUDO_PS1="\[$bakred\]\u@\h\[$txtrst\] \w\$ "
