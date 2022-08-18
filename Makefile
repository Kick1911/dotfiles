include config.mk
include utils.mk

DOCUMENTS=${HOME}/Documents
CONFIG_PATH=${HOME}/.config
XRC=/etc/xinitrc.d
PWD := ${shell pwd}
TARGETS=home-links configs neovim packages # fonts

NVIM_VERSION=0.7.2
PACKAGES=silversearcher-ag
CONFIGS=bspwm nvim polybar sxhkd
CONFIG_FILE_PATHS=${CONFIGS:%=${CONFIG_PATH}/%}
HOME_LINKS=.Xsession .tmux.conf .gitconfig .asoundrc
HOME_LINK_PATHS=${HOME_LINKS:%=${HOME}/%}

include makefile.d/*.mk

all: ${TARGETS}

${DOCUMENTS}/siji:
	${Q}git clone https://github.com/stark/siji $@ \
		&& cd $@ \
		&& $@/install.sh

${HOME}/%:
	${call print,${CYAN}LN ${notdir $@}}
	${Q}ln -sf ${PWD}/${notdir $@} ${HOME}/

${CONFIG_PATH}/%:
	${call print,${CYAN}LN ${notdir $@}}
	${Q}ln -sf ${PWD}/${notdir $@} ${CONFIG}/

home-links: ${HOME_LINK_PATHS}

configs: ${CONFIG_FILE_PATHS}

packages:
	${Q}apt install ${PACKAGES}

/usr/local/bin/nvim:
	${Q}curl https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim.appimage -o $@

neovim: /usr/local/bin/nvim

.PHONY: all neovim
