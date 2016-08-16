# zsh startup file

for file in ~/{.dotfiles/,.}{path,prompt,exports,aliases,functions,extra}; do
	[[ -r "$file" && -f "$file" ]] && source "$file";
done;
unset file;

export LANG=en_US.UTF-8
export MANPATH="/usr/local/man:$MANPATH"
export GREP_COLOR='0;33'
export EDITOR='mcedit'
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="truefurby"
CASE_SENSITIVE="true"
DISABLE_AUTO_TITLE="true"
# ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="mm/dd/yyyy"

bgnotify_threshold=10
function bgnotify_formatted {
    # exit_status, command, elapsed_sec
    elapsed="$(( $3 % 60 ))s"
    (( $3 >= 60 )) && elapsed="$((( $3 % 3600) / 60 ))m $elapsed"
    (( $3 >= 3600 )) && elapsed="$(( $3 / 3600 ))h $elapsed"
    [ $1 -eq 0 ] && \
        notify-send -i "terminal" "$2" "exited cleanly (took $elapsed)" || \
        notify-send -i "error" "$2" "exited with '$1' (took $elapsed)"
}

plugins=(git common-aliases pass screen sudo bgnotify)
source $ZSH/oh-my-zsh.sh
unsetopt share_history

#exec 2>>( while read X; do print "\e[1m\e[41m${X}\e[0m" > /dev/tty; done & )

