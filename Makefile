include config.mk
include utils.mk

DOCUMENTS=${HOME}/Documents
CONFIG_PATH=${HOME}/.config
XRC=/etc/xinitrc.d
PWD := ${shell pwd}
TARGETS=home-links configs packages /etc/X11/xorg.conf.d/20-amdgpu.conf

NVIM_VERSION=0.8.1
PACKAGES=unclutter picom tlp bspwm polybar  \
		 suckless-tools clangd gcc
CONFIGS=bspwm nvim polybar sxhkd compton
CONFIG_FILE_PATHS=${CONFIGS:%=${CONFIG_PATH}/%}
HOME_LINKS=.Xsession .tmux.conf .gitconfig .asoundrc .p10k.zsh .gitignore_global
HOME_LINK_PATHS=${HOME_LINKS:%=${HOME}/%}

include makefile.d/*.mk

all: ${TARGETS}

${HOME}/%:
	${call print,${CYAN}LN ${notdir $@}}
	${call as_user,ln -sf ${PWD}/${notdir $@} $@}

${CONFIG_PATH}/%:
	${call print,${CYAN}LN ${notdir $@}}
	${call as_user,ln -sf ${PWD}/${notdir $@} $@}

/etc/X11/xorg.conf.d/20-amdgpu.conf:
	${call print,${CYAN}LN ${notdir $@}}
	${Q}ln -sf ${PWD}/etc/xorg.conf.d/${notdir $@} $@

home-links: ${HOME_LINK_PATHS}

configs: ${CONFIG_FILE_PATHS}

packages:
	${Q}apt install -y ${PACKAGES}

.PHONY: all fonts
