
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# Set editor to brew's emacs
export EDITOR=emacs
export PATH="/usr/local/Cellar/emacs/24.3/bin:$PATH"

# Set to use brew's git
export PATH="/usr/local/Cellar/git/1.8.4.3/bin:$PATH"
alias g="git"

alias t="ruby /Users/jlturner/src/ruby/timetrap/bin/dev_t"

alias s="open -a \"/Applications/Sublime Text.app\""

# Create Colors
D=$(tput sgr0)
PINK=$(tput setaf 5)
GREEN=$(tput setaf 2)
ORANGE=$(tput setaf 3)

export PS1='\n\[${ORANGE}\]\@\[${D}\]|\[${PINK}\]$(t now now)\[${D}\][\[${PINK}\]\u\[${D}\]]:\[${ORANGE}\]\w\n\[${GREEN}\]\$:\[${D}\]'
