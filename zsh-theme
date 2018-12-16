# oh-my-zsh theme

_debug() {
    [ -z "$DEBUG" ] && return 0
    local icon=${icon:-" "}
    notify-send -t 5000 -i "$icon" "$1" "$2"
}

_debug "zsh-theme" "init"

LAST_WHO=""
CUR_WHO=""
LAST_EXEC_TIME="0"
LAST_RESULT="-1"
LAST_CMD=""

#typeset -gh LAST_WHO
typeset -ghi _nextcmd _lastcmd

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

prompt_who() {
    local user="%(#.%{%b%K{black}%F{red}%}.%{%b%K{black}%F{green}%})%n%{%b%K{black}%f%}"
    local host="%{%b%K{black}%F{cyan}%}%M%{%b%K{black}%f%}"
    [ -n "$SSH_CLIENT" ] && host="%{%b%K{black}%F{blue}%}%M%{%b%K{black}%f%}"
    echo "${user}%{%B%K{black}%F{black}%}@%{%b%K{black}%f%}${host} "
}

prompt_result_line() {
    #notify-send -i terminal "LAST_WHO" "$LAST_WHO"
    #emulate -L zsh
    #local WHO="$(print -P "%n@%M")"
    local WHO="$(prompt_who)"
    if [ "$LAST_WHO" != "${WHO}" ]; then
        #notify-send -i terminal "DIFF" "LAST_WHO: '${LAST_WHO}' != '${WHO}'"
        #echo $who
        CUR_WHO=$(prompt_who)
    else
        #notify-send -i terminal "SAME" "$LAST_WHO"
        CUR_WHO=""
    fi
    LAST_WHO="$WHO"
    #notify-send -i terminal "SET TO" "LAST_WHO: ${LAST_WHO}"

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

ZSH_THEME_GIT_PROMPT_PREFIX="%{%b%K{black}%F{blue}%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=" %{%B%K{black}%F{red}%}✲"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{%B%K{black}%F{green}%}"

ZSH_THEME_GIT_PROMPT_ADDED="%{%b%K{black}%F{green}%}✚ "
ZSH_THEME_GIT_PROMPT_MODIFIED="%{%B%K{black}%F{yellow}%}✎ "
ZSH_THEME_GIT_PROMPT_DELETED="%{%b%K{black}%F{red}%}⊘ "
ZSH_THEME_GIT_PROMPT_RENAMED="%{%b%K{black}%F{yellow}%}▴ "
ZSH_THEME_GIT_PROMPT_UNMERGED="%{%b%K{black}%F{magenta}%}⛖ "
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{%b%K{black}%F{cyan}%}✭ "
ZSH_THEME_GIT_PROMPT_STAGED="%{%b%K{black}%F{blue}%}𝝙 "
ZSH_THEME_GIT_PROMPT_AHEAD="%{%B%K{black}%F{blue}%}⚑ "

function timeago() {
    num=$1
    min=0
    hour=0
    day=0
    if ((num>59)); then
        ((sec=num%60))
        ((num=num/60))
        if ((num>59)); then
            ((min=num%60))
            ((num=num/60))
            if ((num>23)); then
                ((hour=num%24))
                ((day=num/24))
            else
                ((hour=num))
            fi
        else
            ((min=num))
        fi
    else
        ((sec=num))
    fi
    echo "$day"d"$hour"h"$min"m #"$sec"s
}

prompt_where() {
    local location="%{%b%K{black}%F{yellow}%}%4~ "

    local git_info=$(git_prompt_info)
    if [ -n "$git_info" ]; then
        local toplevel="$(git rev-parse --show-toplevel)"
        if [ -n "$toplevel" ]; then
            local repo="%{%B%K{black}%F{magenta}%}$(basename $toplevel)"
            local prefix="$(git rev-parse --show-prefix)"
            local cdup="$(git rev-parse --show-cdup)"
            [ -n "$prefix" ] && repo+="%{%b%K{black}%F{magenta}%}/$prefix"
            local dir=$(print -P "%~")
            dir=$(dirname `realpath "$PWD/$cdup"`)
            location="%{%b%K{black}%F{yellow}%}$(print -rD $dir)%{%b%K{black}%F{white}%} "
            location+="%{%b%K{black}%F{magenta}%}$repo "
        fi

        #location="%{%b%K{black}%F{magenta}%}${repo}"
        #location="%{%b%K{black}%F{yellow}%}$prefix"
        #if [[ "$toplevel" != "$(pwd)" ]]; then
        #fi
        location+="%{%b%K{black}%F{white}%}${git_info} "

        local vers=$(git describe --always --tags 2>/dev/null | sed 's/-\([0-9]*\)-g\([0-9a-f]*\)/+\1-\2/')
        #local vers=`git describe --always --tags 2>/dev/null | sed 's/-\([0-9]*\)-g\([0-9a-f]*\)/+\1/'`
        #local hash=`git describe --always 2>/dev/null | sed 's/-\([0-9]*\)-g\([0-9a-f]*\)/+\2/'`
        local hash=`git rev-parse HEAD | cut -c1-7`
        [ -n "$vers" ] && location+="${vers} "
        [ -n "$hash" ] && [ "$vers" != "$hash" ] && location+="%{%B%K{black}%F{black}%}<%{%b%f%}${hash}%{%B%K{black}%F{black}%}> "
        let agosec=$((`date +"%s"` - `git show -s --format="%ct"`))
        local ago=`timeago $agosec`;
        #local ago=`printf '%dh%02dm\n' $(($ago/3600)) $(($ago%3600/60))` # $(($ago%60))`
        [ -n "$ago" ] && location+="%{%B%K{black}%F{black}%}⭯ ${ago} "
    fi

    local git_status=$(git_prompt_status)
    if [ -n "$git_status" ]; then
        location+="%{%b%K{black}%f%}${git_status}"
    fi

	local goexe=$(command which go)
    if [ -n "$goexe" ]; then
        gocount=$(command find . -maxdepth 1 -name "*.go" 2>/dev/null | wc -l)
        #echo "gocount: $gocount"
        if [[ "$gocount" -gt 0 ]]; then
            gover=$(go version | sed -e 's/^go version \(go[0-9\.]*\).*$/\1/')
            location+=" %{%B%K{black}%F{yellow}%}${gover}%{%B%K{black}%F{black}%}"
        fi
    fi

    echo "${location}%E%{%b%k%f%}"
}

prompt_char() {
    local c
    for i in `seq 1 "$SHLVL"`; do
        c+="➤"
    done
    [ -n "${ASCIINEMA_REC}" ] && 
      echo "%{%b%F{red}%}${c}%{%b%f%}" || echo "%{%b%F{white}%}${c}%{%b%f%}"
}

prompt_clock() {
    local clock="%{%B%k%F{black}%}⏲ %D{%H:%M:%S}%{%b%k%f%}"
    echo -n "${clock}%{%b%k%f%s%}"
}

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
%{%b%K{black}%f%} ${CUR_WHO}$(prompt_where)
%{%b%k%f%}$(prompt_char) %{%b%k%F{white}%}'
    PROMPT2='➣ '
    #RPROMPT='%{$(echotc UP 1)%}$(prompt_info)%{$(echotc DO 1)%}%{$(echotc LE 10)$(prompt_clock)%}'
    RPROMPT='$(prompt_clock)'
}

prompt_setup
