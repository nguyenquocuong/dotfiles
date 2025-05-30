set shell := ["/bin/bash", "-c"]

root_dir := source_dir()

install: install_pkgs

install_pkgs:
  #!/bin/bash
  
  sudo pacman -S --noconfirm less lxsession-gtk3 xorg-server git gitui github-cli alacritty tmux rofi dunst polybar neovim exa bat zoxide ripgrep picom
  sudo pacman -S --noconfirm pipewire pavucontrol playerctl pamixer brightnessctl

  # Bluetooth
  sudo pacman -S --noconfirm bluez bluez-utils blueman

  # Applications
  sudo pacman -S --noconfirm vlc feh flameshot lxappearance-gtk3 papirus-icon-theme
  sudo pacman -S --noconfirm thunar catfish gvfs thunar-volman thunar-archive-plugin thunar-media-tags-plugin
  yay -S --noconfirm arc-gtk-theme ibus-bamboo google-chrome betterlockscreen

  # Fonts
  sudo pacman -S ttf-firacode-nerd ttf-font-awesome
  yay -S --noconfirm noto-fonts noto-fonts-emoji noto-fonts-cjk noto-fonts-extra
  
  # sudo cp rofi_run /usr/local/bin

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

neovim_config: neovim_install

neovim_uninstall:
  #!/bin/bash

  rm -rf ~/.config/nvim
  rm -rf ~/.local/state/nvim
  rm -rf ~/.local/share/nvim

# Install and configure polybar themes using adi1090x/polybar-themes
polybar_config:
  #!/bin/bash

  TMPDIR=/tmp/polybar-themes

  # 1. Clone the polybar-themes repository to a temporary directory
  git clone --depth=1 https://github.com/adi1090x/polybar-themes.git $TMPDIR

  # 2. Run the setup script from the cloned repository
  cd $TMPDIR && ./setup.sh <<< 2

  # 3. Copy the user's polybar config from the source directory to ~/.config
  cp -r {{root_dir}}/.config/polybar ~/.config

  # 4. Clean up by removing the temporary directory
  rm -rf /tmp/polybar-themes

mons_install:
  #!/bin/bash

  git clone --recursive https://github.com/Ventto/mons.git
  cd mons
  sudo make install
  cd ..
  rm -rf mons

xorg_config:
  #!/bin/bash

  # Copy Xorg configuration files
  sudo cp {{root_dir}}/Xorg/xorg.conf.d/* /etc/X11/xorg.conf.d/

  # Enable compositor
  sudo cp -r {{root_dir}}/picom ~/.config

systemd_config:
  #!/bin/bash

  # Enable betterlockscreen
  sudo cp {{root_dir}}/systemd/system/betterlockscreen.service /usr/lib/systemd/system/betterlockscreen@$USER.service
  sudo systemctl enable betterlockscreen@$USER.service
