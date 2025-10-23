# Improved Autocompletion

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Partial completion suggestions
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix

# Colorize completions using default colors
zstyle ':completion:*' list-colors ''

# Persistent rehash
zstyle ':completion:*' rehash true

# Separate directories from files
zstyle ':completion:*' list-dirs-first true

# Better SSH/SCP/SFTP completion
zstyle ':completion:*:(scp|sftp|ssh):*' hosts $hosts
zstyle ':completion:*:(scp|sftp|ssh):*' users $users

# Fuzzy matching for completions
# If there are no matches for the current word, try with fuzzy matching
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Increase the number of errors allowed by approximate completer based on
# the length of the typed word
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'

# Don't complete unavailable commands
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'