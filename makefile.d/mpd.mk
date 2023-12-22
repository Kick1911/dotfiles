TARGETS += mpd
PACKAGES += mpd mpc
MPD_BIN = /usr/bin/mpd

mpd: ${CONFIG_PATH}/mpd ${MPD_BIN}
	${Q}mkdir ${HOME}/.mpd

${MPD_BIN}: packages
