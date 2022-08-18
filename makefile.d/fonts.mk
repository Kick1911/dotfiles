TARGETS += fonts
SIJI_GIT=${DOCUMENTS}/siji

${SIJI_GIT}:
	${Q}git clone https://github.com/stark/siji $@

${HOME}/.local/share/fonts/siji.pcf:
	${Q}cd ${SIJI_GIT} && ${SIJI_GIT}/install.sh

fonts: ${DOCUMENTS}/siji ${HOME}/.local/share/fonts/siji.pcf
