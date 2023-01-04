include config.mk
include utils.mk

DOCUMENTS=${HOME}/Documents
CONFIG_PATH=${HOME}/.config
XRC=/etc/xinitrc.d
PWD := ${shell pwd}
TARGETS=home-links configs packages /etc/X11/xorg.conf.d/20-amdgpu.conf /etc/gaze

NVIM_VERSION=0.8.1
PACKAGES=silversearcher-ag unclutter picom tlp bspwm polybar nodejs npm \
		 suckless-tools clangd
CONFIGS=bspwm nvim polybar sxhkd
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

/etc/gaze:
	${call print,${CYAN}LN $@}
	${Q}ln -sf ${PWD}$@ $@

home-links: ${HOME_LINK_PATHS}

configs: ${CONFIG_FILE_PATHS}

packages:
	${Q}apt install -y ${PACKAGES}

/usr/local/bin/nvim: nvim/lua/*.so
	${Q}wget https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim.appimage -O $@

nvim/lua/*.so:
	${Q}${MAKE} -C nvim/lua/c

neovim: /usr/local/bin/nvim
	${Q}chmod 755 $<
	${Q}unlink /usr/bin/vi
	${Q}ln -sf $< /usr/bin/vi

.PHONY: all neovim fonts
