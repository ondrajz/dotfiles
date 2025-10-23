# Improved Directory Navigation

# Auto CD without typing 'cd'
setopt AUTO_CD

# Push directories onto directory stack automatically
setopt AUTO_PUSHD

# Don't push duplicate directories
setopt PUSHD_IGNORE_DUPS

# Make 'cd -' work like 'cd -1'
setopt PUSHD_MINUS

# Don't print directory stack after pushd/popd
setopt PUSHD_SILENT

# Create directory path if it doesn't exist with mkdir
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Jump back n directories
up() {
  local d=""
  local limit=$1
  
  # Default to 1 if no number specified
  if [ -z "$limit" ] || [ "$limit" -le 0 ]; then
    limit=1
  fi
  
  for ((i=1;i<=limit;i++)); do
    d="$d/.."
  done
  
  d=$(echo $d | sed 's/^\/\//')
  
  if [ -z "$d" ]; then
    d=..
  fi
  
  cd $d
}

# Better directory listing
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'