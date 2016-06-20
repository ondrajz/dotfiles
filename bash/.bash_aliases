# cuts output to termimal width
alias cutc='cut -c1-$COLUMNS'

# shortcuts
alias install='sudo apt-get install -y'
alias purge='sudo apt-get purge -y'
alias fuck='sudo $(history -p \!\!)'
alias tl='tail -n 30'
alias syslog='tail -n 50 /var/log/syslog'
alias goget='go get -v'
alias gobuild='go build -v'
alias snmpg='snmpget -v 2c -c public'
alias ll='ls --color=auto -Alh'
alias lt='ls --color=auto -Alth'
newsh() {
    local editor=${EDITOR:-`which nano`}
    local script="$1"
    if [[ $script != *".sh" ]]; then
        script="$script".sh
    fi
    if [ -a "$script" ]; then 
        echo "newscript: script file '$script' already exists" 1>&2
    else 
        echo "#!/bin/bash" > $script
        chmod +x $script
        eval $editor $script
    fi
}

# uploads output and returns link to it
alias tb='nc termbin.com 9999'
# uploads selection
alias tbsel='xsel | nc termbin.com 9999'
# uploads selection to and copies the link to clipboard
alias tbcp='xsel | nc termbin.com 9999 | tee >(xsel -b)'

