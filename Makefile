include config.mk

DOCUMENTS=${HOME}/Documents
CONFIG_PATH=${HOME}/.config
XRC=/etc/xinitrc.d
PWD=${shell pwd}

NVIM_VERSION=0.7.2
PACKAGES=silversearcher-ag zsh
CONFIGS=bspwm nvim polybar sxhkd
HOME_LINKS=.Xsession .tmux.conf .gitconfig etc/.asoundrc .zshrc

include makefile.d/*.mk

all: fonts home-links configs vim-plug neovim packages \
	${Q}${XRC}/52-background-image.sh # Wallpaper changer

${DOCUMENTS}/siji:
	${Q}git clone https://github.com/stark/siji $@ \
		&& cd $@ \
		&& $@/install.sh

${HOME}/%:
	${Q}ln -s ${PWD}/${notdir $@} ${HOME}/

${CONFIG_PATH}/%:
	${Q}ln -s ${PWD}/${notdir $@} ${CONFIG}/

home-links: ${HOME_FILES}
	${Q}${MAKE} -c ${^:%=${HOME}/%}

configs: ${CONFIGS}
	${Q}${MAKE} -c ${^:%=${CONFIG_PATH}/%}

packages:
	${Q}apt install ${PACKAGES}

vim-plug:
	${Q}sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

/usr/local/bin/nvim:
	${Q}curl https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim.appimage -o $@
