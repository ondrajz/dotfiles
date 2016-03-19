# cuts output to termimal width
alias cutc='cut -c1-$COLUMNS'

# shortcuts
alias install='sudo apt-get install -y'
alias uninstall='sudo apt-get purge -y'
alias fuck='sudo !!'
alias tl='tail -n 30'
alias syslog='tail -n 50 /var/log/syslog'
alias goget='go get -v'
alias gobuild='go build -v'
alias snmpg='snmpget -v 2c -c public'

# uploads output and returns link to it
alias tb='nc termbin.com 9999'
# uploads selection
alias tbsel='xsel | nc termbin.com 9999'
# uploads selection to and copies the link to clipboard
alias tbcp='xsel | nc termbin.com 9999 | tee >(xsel -b)'

