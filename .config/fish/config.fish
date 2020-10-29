# fish config

## default (emacs) keybinds ##
fish_default_key_bindings
# fish_vi_key_bindings # vim keybindings

## set environmental variables ##
set -Ux EDITOR nano # dont yell at me please
set -Ux myTERMINAL gnome-terminal # dont yell at me please
set -Ux VISUAL gedit # dont yell at me please
set -Ux MANPAGER most # 'most' is my personal favorite pager

## sexy ls ##
alias ls='exa -al --color=always --group-directories-first' # my preferred listing
alias la='exa -a --color=always --group-directories-first'  # all files and dirs
alias ll='exa -l --color=always --group-directories-first'  # long format
alias lt='exa -aT --color=always --group-directories-first' # tree listing
alias l.='exa -a | egrep "^\."'				    # list dotfiles

## color grep ##
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

## scary ##
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias rmforsure='/bin/rm -v'
alias cpforsure='/bin/cp -v'
alias mvforsure='/bin/mv -v'

## convenience aliases ##
alias sudo=doas
alias viewfish="cat /home/jz/.config/fish/config.fish"
alias srcfish="source /home/jz/.config/fish/config.fish"
alias viewbashrc="cat /home/jz/.bashrc"
alias viewzshrc="cat /home/jz/.zshrc"
alias jctl="journalctl -p 3 -xb"
alias merge='xrdb -merge ~/.Xresources'
alias xres="xrdb ~/.Xresources"
alias vim="nvim"
alias igrep='/bin/grep -v --color=auto' # inverted grep
alias install="sudo pacman -S"
alias remove="sudo pacman -Rns"
alias upgrade="sudo pacman -Syu"
alias enable="sudo systemctl enable"
alias enablenow="enable --now"
alias disable="sudo systemctl disable"
alias disablenow="disable --now"
alias start="sudo systemctl start"
alias stop="sudo systemctl stop"
alias restart="sudo systemctl restart"
alias i=install
alias r=remove
alias u=upgrade
alias e=enable
alias en=enablenow
alias d=disable
alias dn=disablenow
alias sta=start
alias sto=stop
alias re=restart
alias testnet-web="ping archlinux.org"
alias testnet-dns="ping 8.8.8.8"
alias gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
alias gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"
alias addup='git add -u'
alias addall='git add .'
alias branch='git branch'
alias checkout='git checkout'
alias clone='git clone'
alias cl=clone
alias commit='git commit -m'
alias fetch='git fetch'
alias pull='git pull origin'
alias push='git push origin'
alias tag='git tag'
alias newtag='git tag -a'
alias gs="git status"

## you know exactly what this is ##
alias rr='curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash'
