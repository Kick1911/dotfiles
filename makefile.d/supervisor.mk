# TARGETS += supervisor
# PACKAGES += supervisor
SUPER_CONF=/etc/supervisor/conf.d
SUPER_LOCAL_PATH=etc/supervisor
SUPER_CONF_FILES=${shell ls ${SUPER_LOCAL_PATH}/*.conf}
SUPER_CONF_PATHS=${SUPER_CONF_FILES:%=${SUPER_CONF}/%}

supervisor: ${SUPER_CONF_PATHS}
	${Q}# NOTE restart does not work with SysV for supervisor
	${call print,${BROWN}Supervisor stop}
	${Q}service supervisor stop
	${call print,${GREEN}Supervisor start}
	${Q}service supervisor start

${SUPER_CONF_PATHS}: packages
	${call print,${CYAN}LN ${notdir $@}}
	${Q}ln -sf ${PWD}/${SUPER_LOCAL_PATH}/${notdir $@} ${SUPER_CONF}/

.PHONY: supervisor
