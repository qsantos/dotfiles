setopt histignorealldups #sharehistory
setopt auto_pushd
#setopt autocd
#setopt no_auto_remove_slash
#unsetopt correct glob

# Disable failing when a glob doesn’t match anything
unsetopt nomatch

# Interpret comments in shell, like in bash
setopt interactivecomments

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

HISTSIZE=100000000
SAVEHIST=100000000
HISTFILE=~/.zsh_history
REPORTTIME=1
setopt extended_history # logs the start and elapsed time

# Show the time when a command was run
# From https://unix.stackexchange.com/a/598820/532252
print-time() print -P '%F{yellow}%D{%F %T.%2.%z}%f'
preexec_functions=(print-time)

# Show time time when a command completed, and the elapsed wall-clock time
# From https://superuser.com/a/847411
cmd_execution_time() {
  local stop=$(date +%s%9N)
  let local elapsed=$((($stop - $cmd_start_time) / 1e9))
  local elapsed=$(printf "%.3fs" $elapsed)
  print -P "%F{yellow}%D{%F %T.%2.%z} (${elapsed} elapsed)%f"
  unset cmd_start_time
}
preexec() {
  cmd_start_time=$(date +%s%9N)
}
precmd() {
  if (($+cmd_start_time)); then
    cmd_execution_time
  fi
}

# Use modern completion system
autoload -Uz compinit
compinit

source ~/.bashrc

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

zstyle ':completion:*' hosts off

# apt-get autocompletion
# next line is commented out because it breaks git alias completion
# setopt complete_aliases
compdef _ins ins
_ins(){
    service=apt CURRENT+=1
    words=(apt install)
    _apt
}
compdef _rem rem
_rem(){
    service=apt CURRENT+=1
    words=(apt remove)
    _apt
}

# SSH autocompletion
compdef s=ssh
compdef cfg-sync=ssh
compdef tmux-ssh=ssh

[[ "$(hostname)" == "milo"     ]] && HOSTCOLOR="red"
[[ "$(hostname)" == "aslan"    ]] && HOSTCOLOR="yellow"
[[ "$(hostname)" == "ender"    ]] && HOSTCOLOR="black"
[[ "$(hostname)" == "gandalf"  ]] && HOSTCOLOR="white"
[[ "$(hostname)" == "frodo"    ]] && HOSTCOLOR="red"
PS1="%F{green}%~%F{$HOSTCOLOR}%#%F{none} "

# Allow Ctrl-z to toggle between suspend and resume
# from https://news.ycombinator.com/item?id=34309989
function Resume {
  fg
  zle push-input
  BUFFER=""
  zle accept-line
}
zle -N Resume
bindkey "^Z" Resume

# compatibility with bash completion
autoload bashcompinit && bashcompinit

eval "$(direnv hook zsh)"
