export LANG=C.UTF-8
export LANGUAGE=C.UTF-8
PATH=~/bin:~/.local/bin:$PATH

# colors
[[ "$(hostname)" == ""         ]] && HOSTCOLOR=6 # cyan
[[ "$(hostname)" == "milo"     ]] && HOSTCOLOR=1 # red
[[ "$(hostname)" == "aslan"    ]] && HOSTCOLOR=3 # yellow
[[ "$(hostname)" == "ender"    ]] && HOSTCOLOR=0 # black
[[ "$(hostname)" == ""         ]] && HOSTCOLOR=5 # magenta
# see https://unix.stackexchange.com/a/367487 for \[ and \]
PS1=$(printf $'\[\e[32m\]\w\[\e[3%cm\]\$\[\e[00m\] ' "$HOSTCOLOR")
alias l='ls -alh --color=auto --group-directories-first'
alias ls='ls --color=auto --group-directories-first'
alias mv='mv -i'
alias cp='cp -i'
alias grep='grep --color=auto'
export LESS='RFX'

# packages
alias lis='dpkg -l | awk "/^ii / {print \$2}" | grep'
alias sea='apt-cache search'
alias sen='apt-cache search --names-only'
alias pol='apt-cache policy'
alias upd='sudo apt update'
alias upg='sudo env DEBIAN_FRONTEND=noninteractive apt full-upgrade'
alias ins='sudo apt install'
alias rem='sudo apt autoremove --purge'

# network
alias wake-milo='wakeonlan -i milo.sinon.org 00:24:1d:86:5a:ce'
alias y='yt-dlp -i -o "%(upload_date)s - %(title)s - %(id)s.%(ext)s" --no-playlist -f248+bestaudio/bestvideo+bestaudio/best --merge-output-format mkv'
alias playlist='youtube-dl -i -o "%(playlist_index)s-%(title)s - %(id)s.%(ext)s" -f248+bestaudio/bestvideo+bestaudio/best --merge-output-format mkv'
alias box='lftp -u freebox, hd1.freebox.fr -e "cd Disque\ dur/Video; ls"'
alias dnsip='dig +short myip.opendns.com @resolver1.opendns.com'
alias webip='curl ipinfo.io'
alias wget='wget --content-disposition'
s() {
    ssh "$@" -t "tmux new-session -A -s main"
}

alias kc='kubectl config use-context'
kn() {
    export NS="$1"
    alias k="kubectl -n '$NS'"
    alias h="helm -n '$NS'"
    alias ke="kubectl -n '$NS' exec -ti"
    source <(kubectl completion zsh)
    source <(helm completion zsh)
}
alias k="kubectl"
alias ke="kubectl exec -ti"
alias ka='k get all'
alias kp='k get pods'

# graphics
alias fea='feh -FZB checks --force-aliasing'
e() { thunar "${1:-.}" & }
alias 0='export DISPLAY=:0.0'
alias 10='export DISPLAY=:10.0'
alias open='xdg-open'
alias clip='xclip -selection clipboard'

# git
alias g='git'
alias ga='git add'
alias gau='git add -u'
alias gb='git branch'
alias gd='git diff --word-diff'
alias ge='git fetch'
alias gf='git commit --amend --no-edit --patch'
alias gg='git grep --recurse-submodules'
alias gh='git stash'
alias gl='git log --oneline --decorate'
alias gm='git commit -v'
alias go='git checkout --recurse-submodules'
alias gp='git push'
alias gq='git pull'
alias gs='git status'
alias gt='git tag --sort version:refname'
alias gtv='git tag -l --sort=-creatordate --format="%(creatordate:short) %(refname:short)"'
alias gv='git describe --tag'
alias gr='git rebase --autosquash --autostash'
alias gri='git rebase --autosquash --autostash --interactive'
alias grc='git rebase --continue'
alias gra='git rebase --abort'
alias gita='gitg --all'
alias th='tig stash'

# dev
alias pjson="python3 -m json.tool"
alias web='python3 -m http.server --bind 127.0.0.1'
export PYTHONSTARTUP=~/.pythonrc.py
export CFLAGS=(-Wall -Wextra -Wpedantic -Wconversion -Wshadow -std=c99 -O3)
alias ppath='export PYTHONPATH=$(readlink -f .):$PYTHONPATH'
alias disas='objdump -D -b binary -mi386 -Maddr16,data16'
alias bench='valgrind --tool=callgrind --dump-instr=yes  --collect-jumps=yes'
alias gdb="gdb -q"
c() {
    gcc -O3 -std=c99 -Wall -Wextra -Wpedantic -Wshadow -Wconversion -Wvla -march=native -mtune=native -g "$@" && { time ./a.out; echo "Return status: $?"; }
}
cxx() {
    g++ -O3 -std=c++17 -Wall -Wextra -Wpedantic -Wshadow -Wconversion -Wvla -march=native -mtune=native -g "$@" && { time ./a.out; echo "Return status: $?"; }
}
alias ocaml='rlwrap -pMagenta ocaml'
alias cb='cargo build'
alias ct='cargo test'
alias cr='cargo run'
alias ce='cargo run --example'
alias cbr='cargo build --release'
alias ctr='cargo test --release'
alias crr='cargo run --release'
alias cer='cargo run --release --example'
alias cf='cargo fmt'
alias ck='cargo check'
alias cc='cargo clippy'
alias co='cargo doc'

# misc
export EDITOR='vim'
alias svi='sudo -E vim'
alias phone='adb shell -t bash'
alias rm='rm --one-file-system'
alias cp='cp -i'
alias mgrep='pcregrep --color=always -M'
alias w='watch '
alias imginfo="exiv2 -g 'DateTime$'"
alias imgsort="jhead -n%Y-%m-%d/%f"
x() { unset HISTFILE; }

# alias
alias o='eval $(opam env)'
framac_options='-wp -wp-rte -wp-timeout 1 -wp-prover tip,alt-ergo,cvc4 -warn-invalid-bool -warn-invalid-pointer -warn-left-shift-negative -warn-pointer-downcast -warn-right-shift-negative -warn-signed-downcast -warn-signed-overflow -warn-special-float non-finite -warn-unsigned-downcast -warn-unsigned-overflow'
alias rte="frama-c $framac_options"
alias rteg="frama-c-gui $framac_options"

# make TTY pass C-S to application
# stty -ixon

# https://unix.stackexchange.com/a/304210
tmux-x-attach() {
    ps -f -u $USER | grep -v grep | grep -q 'xpra start' || xpra start :9
    xpra attach :9 --opengl=no > /tmp/xpra-attach.log 2>&1 &
    DISPLAY=:9 tmux-attach "$@"
    xpra detach :9
}

tmux-attach() {
    case $(tmux list-sessions 2>/dev/null | wc -l) in
        0) tmux ;;
        1) tmux attach ;;
        *)
            tmux list-sessions 
            read -n 1 -p "Select command: " N < /dev/tty > /dev/tty;
            tmux attach -t $N
            ;;
    esac
}
tmux-ssh() {
    ssh "$@" -A -X -t 'PS1=tmux-ssh- ; . ~/.bashrc ; tmux-x-attach';
    tput init;
}

# ulimit -d 4194304
ulimit -d unlimited

# workaround for https://github.com/webpack/webpack/issues/14532
# alias npm='NODE_OPTIONS=--openssl-legacy-provider npm'
. "$HOME/.cargo/env"
