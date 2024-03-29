# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Welcome message 
echo -ne "->"; date '+%A,%-d %B %Y <> %T '""

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=5000
HISTFILESIZE=5000
HISTIGNORE='ls:history'
HISTTIMEFORMAT="%d/%h/%y - %H:%M:%S "

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

function gitbranch(){
    if git branch > /dev/null 2>&1; then
        echo -e "$(git branch 2> /dev/null | grep "^*" | sed "s/^* //")"
    fi
}

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    PS1='\[\033[01;30m\]$(gitbranch)\[\033[1;37m\][\[\033[01;34m\]\w\[\033[1;37m\]]\[\033[00m\]$ '
    PS2="\[\033[1;37m\]:\[\033[00m\]> "
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    PS2="> "
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Bash aliases
if [ -f ~/.aliases/b_aliases ]; then
    . ~/.aliases/b_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Improving command history
export HISTTIMEFORMAT="%d/%h/%y - %H:%M:%S "

# Virtualenv Wrapper
export WORKON_HOME='~/Envs'
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    . /usr/local/bin/virtualenvwrapper.sh
else
    echo "Virtualenv Wrapper apparently is not installed." 
fi

# Git aliases
if [ -f ~/.aliases/git_aliases ]; then
    . ~/.aliases/git_aliases
fi

# Python alises
if [ -f ~/.aliases/python_aliases ]; then
    . ~/.aliases/python_aliases
fi

# Timer aliases
if [ -f ~/.aliases/timer_aliases ]; then
    . ~/.aliases/timer_aliases
fi

# External config
if [[ -r ~/.dircolors ]] && type -p dircolors >/dev/null; then
  eval $(dircolors -b "$HOME/.dircolors")
fi

function calc(){
    bc <<< $1
}

function is_in(){
    grep $1 <<< $2 > /dev/null 2>&1 && return 0 || return 1
}

export CATALINA_HOME=/opt/tomcat7
