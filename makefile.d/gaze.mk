TARGETS += gaze
GAZE_BIN = /usr/local/bin/gaze
GAZE_CONFIG_DIR = /etc/gaze

gaze: ${GAZE_CONFIG_DIR} ${GAZE_BIN}

${GAZE_BIN}:
	curl https://gitlab.com/api/v4/projects/38792435/packages/generic/gaze/v0.12.5/install.sh | sh

/etc/gaze:
	${call print,${CYAN}LN $@}
	${Q}ln -sf ${PWD}$@ $@
