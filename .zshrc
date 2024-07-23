if [ -d ~/.oh-my-zsh ]; then
  export ZSH="$HOME/.oh-my-zsh"
  ZSH_THEME="agnoster"
  DISABLE_AUTO_TITLE="true"
  plugins=(git zsh-autocomplete ssh-agent)
  source $ZSH/oh-my-zsh.sh
fi

if [ -z "$LANG" ]; then
  export LANG=en_US.UTF-8
fi

if [ -z "$TERM" ]; then
  export TERM=xterm-256color
fi

if [ -d ~/.dotfiles.git ]; then
    if (( $+commands[lazygit] )); then
      alias ldtf="lazygit --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME/"
      echo ldtf
    fi
    alias dtf="/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME/"
fi

if [ -e ~/scripts/az_functions.sh ]; then
    source ~/scripts/az_functions.sh
fi

if [ -e ~/scripts/my_functions.sh ]; then
    source ~/scripts/my_functions.sh
fi

if [ -e ~/scripts/mac_functions.sh ]; then
    source ~/scripts/mac_functions.sh
fi

if (( $+commands[tmux] )) && (( $+commands[bash] )); then
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

if [ -d ~/.wasmtime ]; then
  export WASMTIME_HOME="$HOME/.wasmtime"
  export PATH="$WASMTIME_HOME/bin:$PATH"
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

if (( $+commands[kubectl] )); then
    alias k='kubectl'
    alias ks='kubectl -n kube-system'
    alias kd='kubectl -n dapr-system'
    source <(kubectl completion zsh)
fi

if (( $+commands[helm] )); then
    alias h='helm'
    alias hs='helm -n kube-system'
    alias hd='helm -n dapr-system'
    source <(helm completion zsh)
fi

if [ -x $(which fastfetch) ]; then
  fastfetch
fi

if [ -x $(which fzf) ] && [ -x $(which rg) ]; then
  export FZF_DEFAULT_COMMAND='rg --files'
fi

if [ -e /opt/nix-and-zscaler.crt ]; then
  export NIX_SSL_CERT_FILE=/opt/nix-and-zscaler.crt
fi

# --- ssh agent configuration for commit signing
case "$(uname -a)" in
   Linux*cm2*)
        echo 'Linux CBL Mariner - skipping ssh agent'
        ;;

   Linux*kai*)
        export SSH_AUTH_SOCK=~/.1password/agent.sock
        git config --global commit.gpgsign true
        git config --global gpg.format ssh
        git config --global user.signingkey "`ssh-add -L | grep GitHub`"
        git config --global gpg.ssh.program /opt/1Password/op-ssh-sign
        ;;

   Darwin*)
        export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
        git config --global commit.gpgsign true
        git config --global gpg.format ssh
        git config --global user.signingkey "`ssh-add -L | grep GitHub`"
        ;;
   *)
        source ~/.configgit
        alias cg='source ~/.configgit'
        ;;
esac
