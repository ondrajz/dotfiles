# zsh startup file

unsetopt histignorealldups share_history
# Appends every command to the history file once it is executed
#setopt inc_append_history
# Reloads the history whenever you use it
#setopt share_history
# ...
#unsetopt histignorealldups

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

# line
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets regexp root)
#ZSH_HIGHLIGHT_HIGHLIGHTERS=()

# Declare the variable
typeset -A ZSH_HIGHLIGHT_STYLES
# To differentiate aliases from other command types
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
# To have paths colored instead of underlined
ZSH_HIGHLIGHT_STYLES[path]='fg=yellow,bold'
# To disable highlighting of globbing expressions
#ZSH_HIGHLIGHT_STYLES[globbing]='none'
#ZSH_HIGHLIGHT_STYLES[arg0]='none'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=green,bold'

plugins=(
	golang
	git
	pass
	screen
	sudo
	bgnotify
	compleat
	pip
	docker
	debian
	django
	kubectl
	zsh-syntax-highlighting
	zsh-autosuggestions
	per-directory-history
	zsh_reload
	zsh-wakatime
)


source $ZSH/oh-my-zsh.sh

for _file in ~/{.dotfiles/,.}{path,prompt,exports,aliases,functions,extra}; do
    [[ -r "$_file" && -f "$_file" ]] && source "$_file";
done;
unset _file;


# omit backup files
#zstyle ':completion:*:*:*:*' file-patterns '^*(~):source-files' '*:all-files'



# colorize stderr
#exec 2>>( while read X; do print "\e[1m\e[41m${X}\e[0m" > /dev/tty; done & )

#[ -r "/usr/share/terminfo/x/xterm+256color" ] && export TERM="xterm+256color"


