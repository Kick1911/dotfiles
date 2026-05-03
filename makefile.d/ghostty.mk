TARGETS += ghostty
GHOSTTY_BIN = /usr/bin/ghostty

ghostty: ${GHOSTTY_CONFIG_DIR} ${GHOSTTY_BIN}

${GHOSTTY_BIN}:
	curl -sS https://debian.griffo.io/EA0F721D231FDD3A0A17B9AC7808B4DD62C41256.asc | \
		sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/debian.griffo.io.gpg \
		echo "deb https://debian.griffo.io/apt trixie main" | \
		sudo tee /etc/apt/sources.list.d/debian.griffo.io.list
	apt update
	apt install ghostty
