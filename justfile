set shell := ["sh", "-c"]

install: install_tpm

install_tpm:
  [ ! -d "~/.tmux/plugins/tpm" ] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
