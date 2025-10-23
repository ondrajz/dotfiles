# Improved ZSH History Configuration

# Save more history
HISTSIZE=50000
SAVEHIST=50000

# Save history immediately, not just when shell exits
setopt INC_APPEND_HISTORY

# Share history between different terminals
setopt SHARE_HISTORY

# Don't store duplicates
setopt HIST_IGNORE_ALL_DUPS

# Don't show duplicates when searching history
setopt HIST_FIND_NO_DUPS

# Remove unnecessary blanks
setopt HIST_REDUCE_BLANKS

# Don't store commands that start with space
setopt HIST_IGNORE_SPACE

# Verify commands from history before executing
# (comment this out if you find it annoying)
# setopt HIST_VERIFY