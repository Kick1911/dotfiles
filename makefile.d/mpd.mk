TARGETS += mpd
PACKAGES += mpd mpc
MPD_BIN = /usr/bin/mpd

mpd: ${CONFIG_PATH}/mpd ${MPD_BIN}

${MPD_BIN}: packages
