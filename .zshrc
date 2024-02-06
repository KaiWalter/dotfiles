export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"
plugins=(git zsh-autocomplete)
source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8

# --- own additions from here

if [ -d ~/.dotfiles.git ]; then
    alias dtf="/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME/"
    if [ -x $(which lazygit) ]; then
      alias ldtf="lazygit --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME/"
    fi
fi

if [ -e ~/scripts/az_functions.sh ]; then
    source ~/scripts/az_functions.sh
fi

if [ -e ~/scripts/mac_functions.sh ]; then
    source ~/scripts/mac_functions.sh
fi

if [ -x $(which tmux) ] && [ -x $(which bash) ]; then
  if [ ! -z "$TMUX" ]; then
    if [ "$(tmux list-windows | wc -l)" = "1" ]; then
      if [ -e ~/scripts/tm.sh ]; then
        bash ~/scripts/tm.sh
      fi
    fi
  fi
fi

if [ -d ~/lib/azure-cli ];
then
    source ~/lib/azure-cli/az.completion
fi

if [ -d ~/bin ]; then
    export PATH=~/bin:$PATH
fi

if [ -d ~/.local/bin ]; then
    export PATH=~/.local/bin:$PATH
fi

if [ -d /opt/homebrew/bin ]; then
    export PATH=/opt/homebrew/bin:$PATH
fi

if [ -d ~/.dotnet ]; then
    export PATH=~/.dotnet:$PATH
    export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
    export FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=1
fi

if [ -d ~/.dapr/bin ]; then
    export PATH=$PATH:~/.dapr/bin
fi

if [ -d ~/.nvm ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

if [ -d /usr/local/go ]; then
    export PATH=$PATH:/usr/local/go/bin
    export GOROOT=/usr/local/go
    export GOPATH=/home/kai/.go
    PATH=$PATH:$GOPATH/bin
fi

if [ -x $(which nvim) ]; then
    export VISUAL='nvim'
    export EDITOR=$VISUAL
fi

if [ -x $(which kubectl) ]; then
    alias k='kubectl'
    alias ks='kubectl -n kube-system'
    alias kd='kubectl -n dapr-system'
    source <(kubectl completion zsh)
fi

if [ -x $(which helm) ]; then
    alias h='helm'
    alias hs='helm -n kube-system'
    alias hd='helm -n dapr-system'
    source <(helm completion zsh)
fi

# --- ssh agent configuration for commit signing
case "$(uname -a)" in
   Linux*cm2*)
        echo 'Linux CBL Mariner - skipping ssh agent'
        ;;

   *)
        source ~/.configgit
        alias cg='source ~/.configgit'
        ;;
esac
