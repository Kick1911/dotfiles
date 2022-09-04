ifneq ($(V),1)
Q := @
# Do not print "Entering directory ...".
MAKEFLAGS += --no-print-directory
endif

GREEN = \033[0;32m
BROWN = \033[0;33m
YELLOW = \033[1;33m
MAGENTA = \033[0;35m
BRIGHT_MAGENTA = \033[1;35m
CYAN = \033[0;36m
BRIGHT_CYAN = \033[1;36m
NC = \033[0m

define print
	@echo -e '  ${1}${NC}'
endef

define as_user
	${Q}su ${USER} -c "${1}"
endef
