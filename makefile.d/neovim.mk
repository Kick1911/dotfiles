TARGETS += neovim
PACKAGES += nodejs npm silversearcher-ag liblua5.1-0-dev

/usr/local/bin/nvim: nvim/lua/*.so
	${Q}curl https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim.appimage -o $@

nvim/lua/*.so:
	${Q}${MAKE} -C nvim/lua/c

neovim: /usr/local/bin/nvim
	${Q}chmod 755 $<
	${Q}unlink /usr/bin/vi
	${Q}ln -sf $< /usr/bin/vi
