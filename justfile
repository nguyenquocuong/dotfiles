set shell := ["sh", "-c"]

install: install_pkgs install_tpm

install_pkgs:
  #!/bin/bash
  
  sudo pacman -S --noconfirm xorg-server git gitui github-cli alacritty tmux rofi dunst polybar neovim ttf-firacode-nerd exa

  # Applications
  yay -S --noconfirm google-chrome
  
  sudo cp rofi_run /usr/local/bin

  cp .tmux.conf ~/

  chsh -s `which fish`

install_tpm:
  [ ! -d "~/.tmux/plugins/tpm" ] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
