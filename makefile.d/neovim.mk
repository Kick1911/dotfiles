TARGETS += neovim
PACKAGES += nodejs npm python3-pip silversearcher-ag liblua5.1-0-dev

/usr/local/bin/nvim: nvim/lua/*.so
	${Q}wget https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim.appimage -O $@

nvim/lua/*.so:
	${Q}${MAKE} -C nvim/lua/c

neovim: /usr/local/bin/nvim pynvim
	${Q}chmod 755 $<
	${Q}unlink /usr/bin/vi
	${Q}ln -sf $< /usr/bin/vi

pynvim:
	${Q}pip install pynvim
