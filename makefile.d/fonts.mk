TARGETS += fonts
SIJI_GIT=${DOCUMENTS}/siji

${SIJI_GIT}:
	${call as_user, git clone https://github.com/stark/siji $@}

${HOME}/.local/share/fonts/siji.pcf:
	${call as_user, cd ${SIJI_GIT} && ${SIJI_GIT}/install.sh}

fonts: ${DOCUMENTS}/siji ${HOME}/.local/share/fonts/siji.pcf
