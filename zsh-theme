# https://github.com/truefurby zsh theme

LAST_EXEC_TIME="0"
LAST_RESULT="-1"

typeset -ghi _nextcmd _lastcmd

hook_preexec() {
    timer=${timer:-$SECONDS}
    (( _nextcmd++ ))
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
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{%b%F{white}%}git:%{%b%F{black}%}%F{magenta}"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{red}⊗"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{green}⊙"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{%f%b%} "

prompt_who() {
    local user="%(#.%{%b%F{red}%}%n.%{%b%F{green}%}%n)"
    local host="%{%b%F{cyan}%m%}"
    local pts="%{%b%F{white}%y%}"
    echo "$user%{%b%F{white}%}@$host%{%b%F{white}%}:$pts%{%f%b%}"
}

prompt_dir() {
    echo "%{%b%F{yellow}%}%~%{%f%b%}"
}

prompt_result_line() {
    local result
    if [ "$LAST_RESULT" -gt 0 ]; then
        result="%F{red}"
    elif [ "$LAST_RESULT" -eq 0 ]; then
        result="%F{green}"
    else
        RESULT_LINE=""
        return
    fi
    result+="$LAST_RESULT↵"
    if [ "$LAST_EXEC_TIME" -gt 0 ]; then
        result="%{%b%F{blue}%}${LAST_EXEC_TIME}s $result"
    fi
    
    local zero='%([BSUbfksu]|([FB]|){*})'
    local width=${#${(S%%)result//$~zero/}}
    local fill="\${(l:(($COLUMNS - ($width + 1))):: :)}"
    local newline=$'\n'
    
    RESULT_LINE="$fill$result$newline"
}

prompt_setup() {
    autoload -Uz colors && colors
    autoload -Uz add-zsh-hook

    add-zsh-hook preexec hook_preexec
    add-zsh-hook precmd hook_precmd
    add-zsh-hook precmd prompt_result_line

    setopt prompt_subst

    PROMPT='%{%f%b%k%}${(e)RESULT_LINE}\
%{%b%F{white}%}╭─$(prompt_who) \
%{%b%F{white}%}» $(prompt_dir) \
%{%b%F{white}%}› $(git_prompt_info)
%{%b%F{white}%}╰%(#.%F{red}.)➤%{%f%b%k%} '

    RPROMPT='%{$(echotc UP 1)%}%{%b%F{white}%}[%D{%H:%M:%S}]%{%b%f%}%{$(echotc DO 1)%}'
}

prompt_setup

#exec 2>>( while read X; do print "\e[1m\e[41m${X}\e[0m" > /dev/tty; done & )

