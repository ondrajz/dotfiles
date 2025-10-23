# Useful Aliases and Functions

# General shortcuts
alias zshrc="$EDITOR ~/.zshrc"
alias reload="source ~/.zshrc"
alias h="history"
alias c="clear"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Git shortcuts (if not already provided by Oh-My-Zsh)
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"
alias gd="git diff"
alias gco="git checkout"

# Directory size
alias dirsize="du -sh"

# Find files
ff() { find . -type f -name "*$1*"; }

# Find directories
fd() { find . -type d -name "*$1*"; }

# Extract most archive types
extract() {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Create a backup of a file
bak() {
  cp "$1" "$1.bak-$(date +%Y%m%d-%H%M%S)"
}

# Weather forecast
weather() {
  curl -s "wttr.in/${1:-}"
}

# IP information
ip() {
  echo "Public IP: $(curl -s ifconfig.me)"
  echo "Local IP: $(ifconfig | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}')"
}

# Kill process by name
kp() {
  ps aux | grep $1 | grep -v grep | awk '{print $2}' | xargs kill -9
}

# Create and change to directory
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Serve current directory over HTTP
serve() {
  local port=${1:-8000}
  python -m http.server $port
}

# Show disk usage sorted by size
diskusage() {
  du -sh * | sort -hr
}