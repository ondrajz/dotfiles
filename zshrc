# zsh startup file

export LANG=en_US.UTF-8
export EDITOR='mcedit'
export MANPATH="/usr/local/man:$MANPATH"
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="truefurby"
CASE_SENSITIVE="true"
# ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="mm/dd/yyyy"
DISABLE_AUTO_TITLE="true"

bgnotify_threshold=10
function bgnotify_formatted { # exit_status, command, elapsed_sec
    elapsed="$(( $3 % 60 ))s"
    (( $3 >= 60 )) && elapsed="$((( $3 % 3600) / 60 ))m $elapsed"
    (( $3 >= 3600 )) && elapsed="$(( $3 / 3600 ))h $elapsed"
    [ $1 -eq 0 ] && \
        notify-send -i "terminal" "$2" "took $elapsed" || \
        notify-send -i "error" "$2" "exit status: <b>$1</b>
<i>took: $elapsed</i>"
}

plugins=(git pass screen sudo bgnotify)
source $ZSH/oh-my-zsh.sh
unsetopt share_history

for file in ~/{.dotfiles/,.}{path,prompt,exports,aliases,functions,extra}; do
	[[ -r "$file" && -f "$file" ]] && source "$file";
done;
unset file;

#exec 2>>( while read X; do print "\e[1m\e[41m${X}\e[0m" > /dev/tty; done & )

