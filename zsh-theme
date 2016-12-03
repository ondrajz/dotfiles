# oh-my-zsh theme

LAST_EXEC_TIME="0"
LAST_RESULT="-1"
LAST_CMD=""

typeset -ghi _nextcmd _lastcmd

_debug() {
    [ -z "$DEBUG" ] && return 0
    local icon=${icon:-" "}
    notify-send -t 5000 -i "$icon" "$1" "$2"
}

set_title() {
    local t="$1 [%y]"
    print -Pn "\e]0;$t\a"
}

hook_preexec() {
    timer=${timer:-$SECONDS}
    (( _nextcmd++ ))

    emulate -L zsh
    setopt extended_glob

    local t="${1[(wr)^(*=*|sudo|ssh|mosh|rake|-*)]:gs/%/%%}"
    [[ ! -n $t ]] && t="$LAST_CMD"
    LAST_CMD="$t"

     _debug "preEXEC #$_nextcmd" "exec cmds: '$t' ('$1')"

    set_title "⏳  $t"
}

hook_precmd() {
    local res=$(print -P "%?")

    if (( _nextcmd == _lastcmd ));  then
        LAST_RESULT="-1"
    else
        LAST_RESULT="$res"
        (( _lastcmd = _nextcmd ))
    fi

    if [ $timer ]; then
        LAST_EXEC_TIME="$(($SECONDS - $timer))"
        unset timer
    fi

    _debug "preCMD (${sLAST_EXEC_TIME}s)" "last cmd: '$LAST_CMD' (result $LAST_RESULT)"

    emulate -L zsh
    local t="%3~"
    [[ -n $LAST_CMD ]] && t+=" ⏲ $LAST_CMD"
    set_title "$t"
}

prompt_result_line() {
    if [ "$LAST_RESULT" = "-1" ]; then
         _debug "RESULT_LINE" "empty"
        RESULT_LINE=""
        return 0
    fi

    local left=" %{%B%F{black}%}!%h"
    local right=""

    if [ "$LAST_EXEC_TIME" -gt 0 ]; then
        local e="$(( $LAST_EXEC_TIME % 60 ))s"
        (( $LAST_EXEC_TIME >= 60 )) && e="$((( $LAST_EXEC_TIME % 3600) / 60 ))m$e"
        (( $LAST_EXEC_TIME >= 3600 )) && e="$(( $LAST_EXEC_TIME / 3600 ))h$e"
        right+="%{%B%K{black}%F{blue}%}$e "
    fi
    if [ "$LAST_RESULT" -eq 0 ]; then
        right+="%{%b%K{black}%F{green}%}$LAST_RESULT↵"
    else
        right+="%{%B%K{black}%F{red}%}$LAST_RESULT↵"
    fi

    local zero='%([BSUbfksu]|([FB]|){*})'
    local lwidth=${#${(S%%)left//$~zero/}}
    local rwidth=${#${(S%%)right//$~zero/}}
    local fill="\${(l:(($COLUMNS - ($lwidth + $rwidth + 1))):: :)}"
    local newline=$'\n'

    _debug "RESULT_LINE" "lwidth=$lwidth rwidth=$rwidth"

    RESULT_LINE="${left}${fill}${right}%E${newline}"
}

prompt_who() {
    local user="%(#.%{%b%F{red}%}.%{%b%F{green}%})%n"
    local host="%{%b%F{cyan}%}%m"
    echo "${user}%{%b%f%}@${host}%{%b%f%}"
}

prompt_where() {
    local location="%{%b%F{yellow}%}%3~"
    local git_info=$(git_prompt_info)
    if [ -n "$git_info" ]; then
        local repo=$(basename `git rev-parse --show-toplevel`)
        location+=" %{%b%f%} %{%b%F{magenta}%}${repo} ${git_info}"
    fi
    echo "${location}%{%f%b%}"
}

prompt_char() {
    local c
    for i in `seq 1 "$SHLVL"`; do
        c+="➤"
    done
    echo "%{%b%F{white}%}${c}%{%b%f%}"
}

prompt_clock() {
    local clock="%{%b%F{white}%}%D{%H:%M}"
    echo "${clock}%{%b%f%}"
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{%B%F{magenta}%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{%f%b%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{%B%F{red}%} ✘"
ZSH_THEME_GIT_PROMPT_CLEAN="%{%B%F{green}%} ✔"

ZSH_THEME_GIT_PROMPT_ADDED="%{%b%F{green}%}◉ "
ZSH_THEME_GIT_PROMPT_MODIFIED="%{%b%F{yellow}%}⛤ "
ZSH_THEME_GIT_PROMPT_DELETED="%{%b%F{red}%}⛔ "
ZSH_THEME_GIT_PROMPT_RENAMED="%{%b%F{blue}%} "
ZSH_THEME_GIT_PROMPT_UNMERGED="%{%b%F{cyan}%}§ "
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{%b%F{white}%}◌ "

prompt_info() {
    local info=""
    local git_status=$(git_prompt_status)
    if [ -n "$git_status" ]; then
        info+="%{%b%f%}${git_status} "
    fi
    local hash=$(git show -s --format=%h 2>/dev/null)
    [ -n "$hash" ] && info+="%{%b%F{blue}%}${hash}"
    echo "${info}%{%b%f%}"
}

prompt_setup() {
    autoload -Uz colors && colors

    autoload -Uz add-zsh-hook
    add-zsh-hook preexec hook_preexec
    add-zsh-hook precmd hook_precmd
    add-zsh-hook precmd prompt_result_line

    setopt prompt_subst

    PROMPT='%{%K{black}%}${(e)RESULT_LINE}\
%{%b%k%f%}┌[$(prompt_clock)] $(prompt_who) $(prompt_where)
%{%b%k%f%}┕$(prompt_char) %{%b%k%f%}'
    RPROMPT='%{$(echotc UP 1)%}$(prompt_info)%{$(echotc DO 1)%}'
}

prompt_setup
