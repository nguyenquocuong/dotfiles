set shell := ["/bin/bash", "-c"]

install: install_pkgs

install_pkgs:
  #!/bin/bash
  
  sudo pacman -S --noconfirm less lxsession-gtk3 xorg-server git gitui github-cli alacritty tmux rofi dunst polybar neovim exa bat zoxide ripgrep
  sudo pacman -S --noconfirm pipewire pavucontrol playerctl pamixer

  # Bluetooth
  sudo pacman -S --noconfirm bluez bluez-utils blueman

  # Applications
  sudo pacman -S --noconfirm vlc feh flameshot lxappearance papirus-icon-theme
  sudo pacman -S --noconfirm thunar catfish gvfs thunar-volman thunar-archive-plugin thunar-media-tags-plugin
  yay -S --noconfirm arc-gtk-theme ibus-bamboo google-chrome

  # Fonts
  sudo pacman -S ttf-firacode-nerd ttf-font-awesome
  yay -S --noconfirm noto-fonts noto-fonts-emoji noto-fonts-cjk noto-fonts-extra
  
  sudo cp rofi_run /usr/local/bin

config:
  #!/bin/bash

  cp ./.xinitrc ./.gtkrc-2.0 .tmux.conf ~/

  cp -r ./.config/alacritty ~/.config/
  cp -r ./.config/rofi ~/.config/
  cp -r ./.config/polybar ~/.config/
  cp -r ./.config/dunst ~/.config/

sound_setup:
  #!/bin/bash

  pactl load-module module-switch-on-connect

fish_setup:
  #!/bin/bash

  cp -r .config/fish ~/.config/

  # Change default shell to fish
  chsh -s `which fish`

tpm_install:
  [ ! -d "~/.tmux/plugins/tpm" ] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

neovim_install:
  #!/bin/bash

  git clone https://github.com/NvChad/starter ~/.config/nvim
  rm -rf ~/.config/nvim/lua
  ln -s ~/dotfiles/.config/nvim/lua ~/.config/nvim/lua

neovim_uninstall:
  #!/bin/bash

  rm -rf ~/.config/nvim
  rm -rf ~/.local/state/nvim
  rm -rf ~/.local/share/nvim

