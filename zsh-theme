# https://github.com/truefurby zsh theme

export LAST_EXEC_TIME="0"
export LAST_RESULT="-1"

function pad_hook_preexec {
    timer=${timer:-$SECONDS}
}

autoload -Uz add-zsh-hook

function pad_hook_precmd {
    if [ $timer ]; then
        export LAST_EXEC_TIME="$(($SECONDS - $timer))"
        unset timer
    fi
}

add-zsh-hook preexec pad_hook_preexec
add-zsh-hook precmd pad_hook_precmd

typeset -ghi _nextcmd _lastcmd

function result_hook_preexec {
    (( _nextcmd++ ))
}

function result_hook_precmd {
    local res=$(print -P "%?")
    if (( _nextcmd == _lastcmd ));  then
        export LAST_RESULT="-1"
    else
        export LAST_RESULT="$res"
        (( _lastcmd = _nextcmd ))
    fi
}

add-zsh-hook preexec result_hook_preexec
add-zsh-hook precmd result_hook_precmd

local username="%(#.%{%b%F{red}%}%n.%{%b%F{green}%}%n)"
local hostname="%{%b%F{cyan}%m%}"
local clock="%{%B%F{black}%}[%{%b%f%}%D{%H:%M:%S}%{%B%F{black}%}]%{%b%f%}"
#local histid="%{%b%F{white}%}!%{%B%F{black}%}%!%{%f%k%b%}"

last_result() {
    if [ "$LAST_RESULT" -gt 0 ]; then
        echo "%{%F{red}%}%?⏎"
    elif [ "$LAST_RESULT" -eq 0 ]; then
        echo "%{%F{green}%}ok"
    fi
}

function render_top_bar {
    local result="$(last_result)"
    [ -z $result ] && { TOP_BAR=""; return }
    
    local zero='%([BSUbfksu]|([FB]|){*})'
    local width=${#${(S%%)result//$~zero/}}
    local fill="\${(l:(($COLUMNS - ($width + 2))):: :)}"
    
    TOP_BAR="$fill$result
"
}

setprompt () {
    ZSH_THEME_GIT_PROMPT_PREFIX="%{%B%F{black}%}<%F{cyan}"
    ZSH_THEME_GIT_PROMPT_DIRTY=" %F{red}✗"
    ZSH_THEME_GIT_PROMPT_CLEAN=" %F{green}✓"
    ZSH_THEME_GIT_PROMPT_SUFFIX="%{%B%F{black}%}>%{%f%b%} "

    res_code="%(?.ok.%{$FG[001]%}%?⏎)"

    PROMPT='${(e)TOP_BAR}\
%{%B%F{white}%}╭─[${username}\
%{%b%F{white}%}@${hostname}\
%F{white}:%F{white}%l%f %{%B%F{black}%}»%{%b%f%} \
%F{yellow}%~%f \
$(git_prompt_info)\
%{%B%F{black}%K{black}%}%E%{%f%k%b%}
%{%B%F{white}%}╰%(#.%F{red}.)➤%{%f%k%b%} '

    RPROMPT='%{$(echotc UP 1)%} ${clock} %{$(echotc DO 1)%}'
}

setopt prompt_subst
setprompt
add-zsh-hook precmd render_top_bar

