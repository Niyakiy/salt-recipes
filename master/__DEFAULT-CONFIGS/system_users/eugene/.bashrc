PS1="[\A] \u@\h:\w #"
export EDITOR=joe
export PAGER=less
export PATH="$PATH:/sbin:/usr/sbin"
alias q='logout'
alias g='grep'
alias ll='ls -la'
alias lll='ls -la | less'
alias cls='clear'

# GIT ALIASES

alias ga='git add'
alias gc='git commit'
alias gl='git log --oneline --graph --all --branches'
alias gs='git status'
alias gb='git branch'

# PASSWORD GENERATORS
alias pass10='i=0; while [ $i -lt 10 ]; do  cat /dev/urandom | tr -dc a-z0-9A-Z | head -c10 ; echo; let i=i+1; done'
alias pass15='i=0; while [ $i -lt 10 ]; do  cat /dev/urandom | tr -dc a-z0-9A-Z | head -c15 ; echo; let i=i+1; done'
alias pass20='i=0; while [ $i -lt 10 ]; do  cat /dev/urandom | tr -dc a-z0-9A-Z | head -c20 ; echo; let i=i+1; done'

function color_prompt
{
    local none="\[\033[0m\]"

    local black="\[\033[0;30m\]"
    local dark_gray="\[\033[1;30m\]"
    local blue="\[\033[0;34m\]"
    local light_blue="\[\033[1;34m\]"
    local green="\[\033[0;32m\]"
    local light_green="\[\033[1;32m\]"
    local cyan="\[\033[0;36m\]"
    local light_cyan="\[\033[1;36m\]"
    local red="\[\033[0;31m\]"
    local light_red="\[\033[1;31m\]"
    local purple="\[\033[0;35m\]"
    local light_purple="\[\033[1;35m\]"
    local brown="\[\033[0;33m\]"
    local yellow="\[\033[1;33m\]"
    local light_gray="\[\033[0;37m\]"
    local white="\[\033[1;37m\]"
    PS1="$cyan[\A] $none<$light_red\u$none@$light_green\h$none>\n$white\w #$none"
    PS2="$dark_gray#$none"
}
# Actions
color_prompt