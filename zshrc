# zsh startup file

unsetopt histignorealldups share_history

#CASE_SENSITIVE="true"
#ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
#HIST_STAMPS="mm/dd/yyyy"
DISABLE_AUTO_TITLE="true"
DISABLE_UPDATE_PROMPT="true"

ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="truefurby"

bgnotify_threshold=10
function bgnotify_formatted { # exit_status, command, elapsed_sec
    elapsed="$(( $3 % 60 )) sec"
    (( $3 >= 60 )) && elapsed="$((( $3 % 3600) / 60 )) min $elapsed"
    (( $3 >= 3600 )) && elapsed="$(( $3 / 3600 )) hours $elapsed"
    cmd="$2"
    if [ $1 -eq 0 ]; then
        notify-send -i terminal "Command has completed " "'$cmd'\n\n<i>took $elapsed</i>"
    else
        notify-send -i terminal "Command has failed ✘" "'$cmd'\n\nexited with ↵$1\n<i>took $elapsed</i>"
    fi
}

plugins=(go git pass screen sudo bgnotify per-directory-history zsh_reload pip compleat debian django)
source $ZSH/oh-my-zsh.sh

# omit backup files
zstyle ':completion:*:*:*:*' file-patterns '^*(~):source-files' '*:all-files'

for _file in ~/{.dotfiles/,.}{path,prompt,exports,aliases,functions,extra}; do
    [[ -r "$_file" && -f "$_file" ]] && source "$_file";
done;
unset _file;

# colorize stderr
#exec 2>>( while read X; do print "\e[1m\e[41m${X}\e[0m" > /dev/tty; done & )

#[ -r "/usr/share/terminfo/x/xterm+256color" ] && export TERM="xterm+256color"
