# ZSH Performance Improvements

# Compile zcompdump to speed up completion loading
{
  # Compile zcompdump, if modified, to increase startup speed.
  zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!

# Only check for updates once a week (if using Oh-My-Zsh)
# Add this to your .zshrc
# export UPDATE_ZSH_DAYS=7

# Lazy-load NVM, RVM, or other version managers if you use them
# Example for NVM:
nvm_lazy_load() {
  unset -f nvm node npm npx
  export NVM_DIR=~/.nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
}

nvm() {
  nvm_lazy_load
  nvm "$@"
}

node() {
  nvm_lazy_load
  node "$@"
}

npm() {
  nvm_lazy_load
  npm "$@"
}

npx() {
  nvm_lazy_load
  npx "$@"
}

# Limit Oh-My-Zsh plugins to only what you need
# Example: plugins=(git z extract)