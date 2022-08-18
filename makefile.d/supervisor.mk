PACKAGES += supervisor
SUPER_CONF=/etc/supervisor/conf.d
SUPER_PATH=etc/supervisor
SUPER_CONF_FILES=${shell ls ${SUPER_PATH}/*.conf}
SUPER_CONF_PATHS=${SUPER_CONF_FILES:%=${SUPER_CONF}/%}

supervisor: ${SUPER_CONF_PATHS}

${SUPER_CONF_PATHS}: packages
	ln -s ${PWD}/${notdir $@} ${CONFIG}/

.PHONY: supervisor
