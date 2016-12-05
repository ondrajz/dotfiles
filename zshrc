# zsh startup file

CASE_SENSITIVE="true"
# ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="mm/dd/yyyy"
DISABLE_AUTO_TITLE="true"
DISABLE_UPDATE_PROMPT="true"

ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="truefurby"

bgnotify_threshold=10
function bgnotify_formatted { # exit_status, command, elapsed_sec
    elapsed="$(( $3 % 60 ))s"
    (( $3 >= 60 )) && elapsed="$((( $3 % 3600) / 60 ))m $elapsed"
    (( $3 >= 3600 )) && elapsed="$(( $3 / 3600 ))h $elapsed"
    [ $1 -eq 0 ] && \
        notify-send -i "terminal" "cmd: '$2'" "took $elapsed" || \
        notify-send -i "error" "cmd: '$2'" "exit status: <b>$1</b>
<i>took: $elapsed</i>"
}

plugins=(go git pass screen sudo bgnotify per-directory-history zsh_reload)
source $ZSH/oh-my-zsh.sh

unsetopt share_history

# omit backup files
zstyle ':completion:*:*:*:*' file-patterns '^*(~):source-files' '*:all-files'

for _file in ~/{.dotfiles/,.}{path,prompt,exports,aliases,functions,extra}; do
    [[ -r "$_file" && -f "$_file" ]] && source "$_file";
done;
unset _file;

# colorize stderr
#exec 2>>( while read X; do print "\e[1m\e[41m${X}\e[0m" > /dev/tty; done & )

#[ -r "/usr/share/terminfo/x/xterm+256color" ] && export TERM="xterm+256color"

