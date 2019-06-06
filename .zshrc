# Set up the prompt

#autoload -Uz promptinit
#promptinit
#prompt adam1

case `uname` in
  Darwin)
    # commands for OS X go here
    export CLICOLOR=1
    export PATH="/Users/mvandenbos/bin:$PATH"
    export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"
    export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
    export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
    export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"

    #alias grep="/usr/local/opt/grep/libexec/gnubin/grep"
    #export PATH="$PATH:/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}""
    
    source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
    source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
  
  ;;
  Linux)
    PATH=$PATH:$HOME/.local/bin
    PATH=$PATH:$HOME/bin
    PATH=$PATH:$HOME/.gem/ruby/2.5.0/bin
    export PATH

    export ORACLE_HOME=/opt/oracle/instantclient_12_2
    export LD_LIBRARY_PATH=$ORACLE_HOME:$LD_LIBRARY_PATH
    export PATH=$ORACLE_HOME:$PATH

    export SHELL="/usr/bin/zsh"
    export TERM="xterm-256color"

    setopt histignorealldups sharehistory

    # pre-req: curl -Ss -L https://raw.github.com/trapd00r/LS_COLORS/master/LS_COLORS -o .dircolors
    if [ -f ~/.dircolors ]; then
      eval $(dircolors ~/.dircolors)
    else
      eval $(dircolors -b)
    fi

  ;;
  FreeBSD)
    # commands for FreeBSD go here
  ;;
esac

DISABLE_AUTO_TITLE="true"

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# ~/.zsh_history:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt appendhistory     # append to history
setopt sharehistory      # share history across terminals
setopt histignorealldups
setopt incappendhistory  # append to HISTFILE immediately

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# clone zgen if we dont have it
if [[ ! -f ${HOME}/.zgen/zgen.zsh ]]; then
  git clone git@github.com:tarjoilija/zgen.git "${HOME}/.zgen"
fi
# load zgen
source ${HOME}/.zgen/zgen.zsh

# spaceship prompt
SPACESHIP_CHAR_SYMBOL='$ '
SPACESHIP_TIME_SHOW=always
SPACESHIP_USER_SHOW=always
SPACESHIP_HOST_SHOW=always
zgen load denysdovhan/spaceship-prompt spaceship

# a better history navigator
# pre-req: pip install percol [--user]
function exists { which $1 &> /dev/null }
if exists percol; then
    function percol_select_history() {
        local tac
        exists gtac && tac="gtac" || { exists tac && tac="tac" || { tac="tail -r" } }
        BUFFER=$(fc -l -n 1 | eval $tac | percol --query "$LBUFFER")
        CURSOR=$#BUFFER         # move cursor
        zle -R -c               # refresh
    }

    zle -N percol_select_history
    bindkey '^R' percol_select_history
fi


# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# aliases

alias cp="cp -v"
alias mv="mv -v"
alias rm="rm -v"

alias scp='scp -o "LogLevel=error"'

alias myip='curl -sS "https://api.ipify.org?format=json" | jq .'
alias mylocalip="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"

alias mytmux="/usr/local/bin/tmux attach-session -d -t default || /usr/local/bin/tmux new-session -s default"

alias dfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

#alias -- -="cd -"                  # Go to previous dir with -
#alias ....="cd ../../.."
#alias ...="cd ../.."
#alias ..="cd .."
#alias a-pro=""
#alias apb="ansible-playbook --private-key ~/.ssh/ansible-id_rsa --user ansible"
#alias cd.='cd $(readlink -f .)'    # Go to real dir (i.e. if current dir is linked)
#alias conv_csv="column -s ',' -t"
#alias conv_tsv="column -s $'\t' -t"
#alias listaliases="alias | sed 's/=.*//'"
#alias listfunctions="declare -f | grep '^[a-z].* ()' | sed 's/{$//'" # show non _prefixed functions
#alias ls="ls --color"
#alias pathl='echo -e ${PATH//:/\\n}'
##alias phgrep='cat ~/.persistent_history|grep --color'
#alias phistory='cat ~/.persistent_history'
#alias quit="exit"
#alias r='/usr/bin/tmux new-window'
#alias reload='exec $SHELL -l'
#alias sqlite3='sqlite3 -header -column'
#alias t='/usr/bin/tmux split-window'
#alias tks="/usr/bin/tmux kill-session -t"
#alias tls="/usr/bin/tmux list-sessions"
#alias tree1="/usr/bin/tree --charset unicode -d -L 1"
#alias tree2="/usr/bin/tree --charset unicode -d -L 2"
#alias tree="/usr/bin/tree --charset unicode"
#alias treed="/usr/bin/tree --charset unicode -d"
#alias week="date +%V"

# command line syntax highlighting
# zsh-syntax-highlighting.zsh wraps ZLE widgets.
# It must be sourced after all custom widgets have been created
# Widgets created later will work, but will not update the syntax highlighting.
zgen load zsh-users/zsh-syntax-highlighting

