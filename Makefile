DOCUMENTS=${HOME}/Documents
CONFIG_PATH=${HOME}/.config
XRC=/etc/xinitrc.d

NVIM_VERSION=0.7.2
PACKAGES=silversearcher-ag
CONFIGS=bspwm nvim polybar sxhkd
HOME_LINKS=.Xsession .tmux.conf .gitconfig etc/.asoundrc .zshrc


all: fonts home-links configs vim-plug neovim packages \
	${XRC}/52-background-image.sh # Wallpaper changer

${DOCUMENTS}/siji:
	git clone https://github.com/stark/siji $@ \
		&& cd $@ \
		&& $@/install.sh

${HOME}/%:
	ln -s ${PWD}/${notdir $@} ${HOME}/

${CONFIG_PATH}/%:
	ln -s ${PWD}/${notdir $@} ${CONFIG}/

home-links: ${HOME_FILES}
	${MAKE} -c ${^:%=${HOME}/%}

configs: ${CONFIGS}
	${MAKE} -c ${^:%=${CONFIG_PATH}/%}

packages: ${PACKAGES}
	sudo apt install $^

vim-plug:
	sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

/usr/local/bin/nvim:
	curl https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim.appimage -o $@

${XRC}/52-background-image.sh:
	ln -s etc/xinitrc.d/52-background-image.sh ${XRC}
