# oh-my-zsh theme

LAST_EXEC_TIME="0"
LAST_RESULT="-1"

typeset -ghi _nextcmd _lastcmd

hook_preexec() {
    timer=${timer:-$SECONDS}
    (( _nextcmd++ ))
    
    emulate -L zsh
    setopt extended_glob
    local title=${1[(wr)^(*=*|sudo|ssh|mosh|rake|-*)]:gs/%/%%}
    print -Pn "\e]0;$title\a"
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
    
    emulate -L zsh
    local pts="$(basename $TTY) %~"
    print -Pn "\e]0;$pts$title\a"
}

prompt_result_line() {
    local result
    local elapsed

    if [ "$LAST_EXEC_TIME" -gt 0 ]; then
        elapsed="$(( $LAST_EXEC_TIME % 60 ))s"
        (( $LAST_EXEC_TIME >= 60 )) && elapsed="$((( $LAST_EXEC_TIME % 3600) / 60 ))m$elapsed"
        (( $LAST_EXEC_TIME >= 3600 )) && elapsed="$(( $LAST_EXEC_TIME / 3600 ))h$elapsed"
    fi
    
    if [ "$LAST_RESULT" -eq 0 ]; then
        result="%{%b%F{green}%}$elapsed %{%B%F{green}%}$LAST_RESULT↵%{%f%b%}"
    elif [ "$LAST_RESULT" -gt 0 ]; then
        result="%{%b%F{red}%}$elapsed %{%B%F{red}%}$LAST_RESULT↵%{%f%b%}"
    else
        RESULT_LINE=""
        return 0
    fi

    local left=" %{%B%F{black}%}!%h%{%f%b%k%}"

    local zero='%([BSUbfksu]|([FB]|){*})'
    local width=${#${(S%%)result//$~zero/}}
    local width2=${#${(S%%)left//$~zero/}}
    local fill="\${(l:(($COLUMNS - ($width + $width2 + 1))):: :)}"
    local newline=$'\n'

    RESULT_LINE="$left$fill$result$newline"
}

prompt_who() {
    local user="%(#.%{%b%F{red}%}.%{%b%F{green}%})%n%{%f%b%}"
    local host="%{%b%F{cyan}%}%m%{%f%b%}"
    echo "${user}@${host}"
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{%B%F{magenta}%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%b%F{red}⊗"
ZSH_THEME_GIT_PROMPT_CLEAN="%b%F{green}⊙"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{%f%b%} "

prompt_where() {
    local git_prompt=$(git_prompt_info)
    local arrows="%{%b%f%}» "
    local location="%{%b%F{yellow}%}%~%{%f%b%}"
    
    if [ -n "$git_prompt" ]; then
        local arrows="%{%B%F{white}%}»%{%b%f%} "
    	local repo=$(basename `git rev-parse --show-toplevel`)
        location="%{%B%F{yellow}%}${repo}%{%f%b%}"
        local folder=$(git rev-parse --show-prefix)
    	if [ -n "$folder" ]; then
            location+="%{%b%F{yellow}%}/${folder}%{%f%b%}"
        fi
        location+=" %{%B%F{white}%}›%{%b%f%} ${git_prompt}"
    fi
    
    echo "${arrows}${location}"
}

prompt_char() {
    echo "%(#.%{%B%F{red}%}.%{%B%F{white}%})➤"
}

prompt_clock() {
    echo "[%{%B%f%}%D{%H:%M:%S}%{%b%f%}]"
}

prompt_setup() {
    autoload -Uz colors && colors

    autoload -Uz add-zsh-hook
    add-zsh-hook preexec hook_preexec
    add-zsh-hook precmd hook_precmd
    add-zsh-hook precmd prompt_result_line

    setopt prompt_subst

    PROMPT='%{%f%b%k%}${(e)RESULT_LINE}%{%b%f%}\
╭─$(prompt_who) $(prompt_where)
╰$(prompt_char)%{%f%b%k%} '

    RPROMPT='%{$(echotc UP 1)%}$(prompt_clock)%{$(echotc DO 1)%}'
}

prompt_setup

