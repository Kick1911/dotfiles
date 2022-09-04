PACKAGES += zsh zsh-theme-powerlevel10k
HOME_LINKS += .zshrc
TARGETS += zsh
ZSH_ETC_CONF=${PWD}/etc/zsh

zsh: home-links packages
	${call print,${CYAN}LN ${notdir ${ZSH_ETC_CONF}}}
	${Q}mv /etc/zsh ${HOME}/zsh.backup
	${Q}ln -sf ${ZSH_ETC_CONF} /etc/
	${Q}usermod -s /usr/bin/zsh kick

.PHONY: zsh
