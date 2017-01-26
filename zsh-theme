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
    local t="🗔 %y"
    [ -n "$1" ] && t="$1  $t"
    print -Pn "\e]0;$t\a"
}

hook_preexec() {
    emulate -L zsh
    setopt extended_glob

    #local cmd="${1[(wr)^(*=*|sudo|ssh|-*)]}"
    #echo "dbg: '${1}' '${2}' last: $LAST_CMD"

    timer=${timer:-$SECONDS}
    (( _nextcmd++ ))

    echo -en "\e[0;0;0m"

    local t="${2[(wr)^(*=*|sudo|ssh|mosh|rake|-*)]:gs/%/%%}"
    [[ -z $t ]] && t="$LAST_CMD"

    LAST_CMD="$t"

     _debug "#$_nextcmd PREEXEC" "exec: $t (${(q)1})"

    set_title "⌛  $t"
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

    _debug "PRECMD (${sLAST_EXEC_TIME}s)" "last: '$LAST_CMD' ($LAST_RESULT)"

    emulate -L zsh

    local t=""
    if [[ -n $LAST_CMD && "$LAST_RESULT" != "-1" ]]; then
        [ "$res" -eq 0 ] && t+="✅  " || t+="❎ "
        t+="$LAST_CMD"
    fi
    if [ "$(pwd)" != "$HOME" ]; then
        [ -n "$t" ] && t+="  "
        t+="🗁 %3~"
    fi

    set_title "$t"
}

prompt_result_line() {
    if [ "$LAST_RESULT" = "-1" ]; then
         _debug "RESULT_LINE" "empty"
        RESULT_LINE=""
        return 0
    fi

    local left=" %{%b%F{black}%}%h"
    local right=""

    if [ "$LAST_EXEC_TIME" -gt 0 ]; then
        local e="$(( $LAST_EXEC_TIME % 60 ))s"
        (( $LAST_EXEC_TIME >= 60 )) && e="$((( $LAST_EXEC_TIME % 3600) / 60 ))m$e"
        (( $LAST_EXEC_TIME >= 3600 )) && e="$(( $LAST_EXEC_TIME / 3600 ))h$e"
        right+="%{%b%F{blue}%}⏱ $e "
    fi
    if [ "$LAST_RESULT" -eq 0 ]; then
        right+="%{%b%F{green}%}⏎ $LAST_RESULT"
    else
        right+="%{%B%F{red}%}⏎ $LAST_RESULT"
    fi

    local zero='%([BSUbfksu]|([FB]|){*})'
    local lwidth=${#${(S%%)left//$~zero/}}
    local rwidth=${#${(S%%)right//$~zero/}}
    local fill="\${(l:(($COLUMNS - ($lwidth + $rwidth + 1))):: :)}"
    local newline=$'\n'

    #_debug "RESULT_LINE" "lwidth=$lwidth rwidth=$rwidth"

    RESULT_LINE="${left}${fill}${right}%E${newline}"
}

prompt_who() {
    local user="%(#.%{%b%K{black}%F{red}%}.%{%b%K{black}%F{green}%})%n"
    local host="%{%b%K{black}%F{cyan}%}%m"
    [ -n "$SSH_CLIENT" ] && host="%{%b%K{black}%F{blue}%}%m"
    echo "${user}%{%b%K{black}%f%}@${host}%{%b%K{black}%f%}"
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{%b%K{black}%F{blue}%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{%b%K{black}%f%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{%B%K{black}%F{red}%} ✘"
ZSH_THEME_GIT_PROMPT_CLEAN="%{%B%K{black}%F{green}%} ✔"

prompt_where() {
    local location="%{%b%K{black}%F{yellow}%}%3~ "
    local git_info=$(git_prompt_info)
    if [ -n "$git_info" ]; then
        local toplevel="$(git rev-parse --show-toplevel)"
        if [ -n "$toplevel" ]; then
            local repo="%{%B%K{black}%F{magenta}%}$(basename $toplevel)"
            local prefix="$(git rev-parse --show-prefix)"
            [ -n "$prefix" ] && repo+="%{%b%K{black}%F{magenta}%}/$prefix"
        fi
        #location="%{%b%K{black}%F{magenta}%}${repo}"
        #location="%{%b%K{black}%F{yellow}%}$prefix"
        #if [[ "$toplevel" != "$(pwd)" ]]; then
            location="%{%b%K{black}%F{magenta}%}$repo %{%b%K{black}%F{white}%} "
        #fi
        location+="%{%b%K{black}%F{white}%}${git_info} "
    fi
    local hash=$(git describe --always 2>/dev/null)
    [ -n "$hash" ] && location+="%{%b%K{black}%f%}${hash} "

    local git_status=$(git_prompt_status)
    if [ -n "$git_status" ]; then
        location+="%{%b%K{black}%f%}${git_status}"
    fi

    echo "${location}%E%{%b%k%f%}"
}

prompt_char() {
    local c
    for i in `seq 1 "$SHLVL"`; do
        c+="$1"
    done
    echo "%{%b%F{white}%}${c}%{%b%f%}"
}

prompt_clock() {
    local clock="%{%b%k%f%}⏲ %D{%H:%M:%S}%{%b%k%f%}"
    echo -n "${clock}%{%b%k%f%s%}"
}

ZSH_THEME_GIT_PROMPT_ADDED="%{%B%K{black}%F{green}%}✚ "
ZSH_THEME_GIT_PROMPT_MODIFIED="%{%B%K{black}%F{yellow}%}✎ "
ZSH_THEME_GIT_PROMPT_DELETED="%{%B%K{black}%F{red}%}❌ "
ZSH_THEME_GIT_PROMPT_RENAMED="%{%B%K{black}%F{blue}%}◭ "
ZSH_THEME_GIT_PROMPT_UNMERGED="%{%B%K{black}%F{cyan}%}⛖ "
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{%B%K{black}%F{white}%}❓ "

#prompt_info() {
#    local info=""
#    local git_status=$(git_prompt_status)
#    if [ -n "$git_status" ]; then
#        #local repo=$(basename `git rev-parse --show-toplevel`)
#        info+="%{%b%K{black}%f%}${git_status}"
#    fi
#    #local hash=$(git show -s --format=%h 2>/dev/null)
#    #[ -n "$hash" ] && info+="%{%b%K{black}%f%}sha:%{%B%K{black}%F{black}%}${hash}"
#    echo "${info}%{%b%k%f%}"
#}

prompt_setup() {
    autoload -Uz colors && colors

    autoload -Uz add-zsh-hook
    add-zsh-hook preexec hook_preexec
    add-zsh-hook precmd hook_precmd
    add-zsh-hook precmd prompt_result_line

    setopt prompt_subst

    PROMPT='${(e)RESULT_LINE}\
%{%b%K{black}%f%} $(prompt_who) $(prompt_where)
%{%b%k%f%}$(prompt_char ➤) %{%b%k%F{white}%}'
    PROMPT2='➣ '
    #RPROMPT='%{$(echotc UP 1)%}$(prompt_info)%{$(echotc DO 1)%}%{$(echotc LE 10)$(prompt_clock)%}'
    RPROMPT='$(prompt_clock)'
}

prompt_setup
