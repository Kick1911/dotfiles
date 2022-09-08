TARGETS += vim-plug

${HOME}/.local/share/nvim/site/autoload/plug.vim: neovim
	${call as_user,sh -c 'curl -fLo $@ --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'}

vim-plug: ${HOME}/.local/share/nvim/site/autoload/plug.vim

.PHONY: vim-plug
