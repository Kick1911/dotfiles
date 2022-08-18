PACKAGES += zsh
HOME_LINKS += .zshrc
TARGETS += zsh
ZSH_ETC_CONF=${PWD}/etc/zsh

zsh: home-links packages
	${call print,${CYAN}LN ${notdir ${ZSH_ETC_CONF}}}
	${Q}ln -sf ${ZSH_ETC_CONF} /etc/

.PHONY: zsh
