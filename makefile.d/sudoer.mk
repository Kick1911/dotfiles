TARGETS += sudoer
SUDOER_PATH=/etc/sudoers.d/011_user-nopasswd

${SUDOER_PATH}:
	${Q}printf 'kick ALL=(ALL) NOPASSWD: ALL' > ${SUDOER_PATH}

sudoer: ${SUDOER_PATH}
.PHONY: sudoer
