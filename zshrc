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
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern root pattern regexp)
#ZSH_HIGHLIGHT_HIGHLIGHTERS=()

# Declare the variable
typeset -A ZSH_HIGHLIGHT_STYLES

# To differentiate aliases from other command types
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
# To have paths colored instead of underlined
ZSH_HIGHLIGHT_STYLES[path]='fg=yellow,bold'
# To disable highlighting of globbing expressions
ZSH_HIGHLIGHT_STYLES[globbing]='fg=cyan,bold'

#ZSH_HIGHLIGHT_STYLES[arg0]='none'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=green,bold'
#ZSH_HIGHLIGHT_STYLES[default]='fg=cyan,bold'
#ZSH_HIGHLIGHT_STYLES[line]='bold'

#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=cyan'
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#d787ff,bold'

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
	kubectl
	zsh-autosuggestions
	zsh-syntax-highlighting
	per-directory-history
	zsh-wakatime
)

source $ZSH/oh-my-zsh.sh

for _file in ~/{.dotfiles/,.}{path,prompt,exports,aliases,functions,extra}; do
    [[ -r "$_file" && -f "$_file" ]] && source "$_file";
done;
unset _file;


# omit backup files
zstyle ':completion:*:*:*:*' file-patterns '^*(~):source-files' '*:all-files'

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} "ma=48;5;244;38;5;255"


# colorize stderr
#exec 2>>( while read X; do print "\e[1m\e[41m${X}\e[0m" > /dev/tty; done & )

#[ -r "/usr/share/terminfo/x/xterm+256color" ] && export TERM="xterm+256color"



#export GOPATH=/home/ondrej/go


#eval $(keychain --eval --agents ssh -Q --quiet id_ed25519)

#eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# place this after nvm initialization!
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc
