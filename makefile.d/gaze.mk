TARGETS += gaze
GAZE_BIN = /usr/local/bin/gaze
GAZE_CONFIG_DIR = /etc/gaze

gaze: ${GAZE_CONFIG_DIR} ${GAZE_BIN}

${GAZE_BIN}: ${HOME}/Documents/gaze
	cd $< && make && make install

/etc/gaze:
	${call print,${CYAN}LN $@}
	${Q}ln -sf ${PWD}$@ $@
