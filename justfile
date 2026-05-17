set shell := ["/bin/bash", "-c"]

root_dir := source_dir()

# Full first-time machine setup in logical order
setup: yay install_pkgs config fish_setup neovim_install tpm_install xorg_config systemd_config sound_setup

install: install_pkgs

yay:
  #!/bin/bash
  git clone https://aur.archlinux.org/yay.git ~/yay
  cd ~/yay
  makepkg -si
  rm -rf ~/yay

install_pkgs:
  #!/bin/bash
  sudo pacman -S --noconfirm gtk2 less lxsession-gtk3 xorg-server git gitui github-cli alacritty tmux rofi dunst polybar neovim exa bat zoxide ripgrep picom unzip
  sudo pacman -S --noconfirm pipewire pavucontrol playerctl pamixer brightnessctl

  # Bluetooth
  sudo pacman -S --noconfirm bluez bluez-utils blueman

  # Applications
  sudo pacman -S --noconfirm vlc feh flameshot lxappearance-gtk3 papirus-icon-theme
  sudo pacman -S --noconfirm thunar catfish gvfs thunar-volman thunar-archive-plugin thunar-media-tags-plugin
  sudo pacman -S --noconfirm fcitx5-bamboo fcitx5-configtool
  yay -S --noconfirm arc-gtk-theme google-chrome betterlockscreen

  # Fonts
  sudo pacman -S ttf-firacode-nerd ttf-font-awesome
  yay -S --noconfirm noto-fonts noto-fonts-emoji noto-fonts-cjk noto-fonts-extra

  sudo cp {{root_dir}}/scripts/rofi_run /usr/local/bin/rofi_run

  # GTK dark mode
  gsettings set org.gnome.desktop.interface color-scheme prefer-dark

update_mirrors:
  #!/bin/bash
  sudo pacman -Syyu
  sudo pacman -S --noconfirm reflector
  sudo reflector --latest 5 --protocol https --sort rate --save /etc/pacman.d/mirrorlist --country Vietnam,Singapore,WorldWide

# Symlink all user configs into ~/.config and ~/
config:
  #!/bin/bash
  ln -snf {{root_dir}}/.xinitrc ~/.xinitrc

  mkdir -p ~/.config
  ln -snf {{root_dir}}/.config/alacritty   ~/.config/alacritty
  ln -snf {{root_dir}}/.config/dunst       ~/.config/dunst
  ln -snf {{root_dir}}/.config/i3          ~/.config/i3
  ln -snf {{root_dir}}/.config/nvim        ~/.config/nvim
  ln -snf {{root_dir}}/.config/picom       ~/.config/picom
  # ln -snf {{root_dir}}/.config/polybar     ~/.config/polybar
  ln -snf {{root_dir}}/.config/rofi        ~/.config/rofi

  mkdir -p ~/.config/tmux
  ln -snf {{root_dir}}/.config/tmux/tmux.conf       ~/.config/tmux/tmux.conf
  ln -snf {{root_dir}}/.config/tmux/tmuxline_theme  ~/.config/tmux/tmuxline_theme

sound_setup:
  #!/bin/bash
  pactl load-module module-switch-on-connect

fish_setup:
  #!/bin/bash
  ln -snf {{root_dir}}/.config/fish ~/.config/fish
  chsh -s $(which fish)

tpm_install:
  [ ! -d ~/.tmux/plugins/tpm ] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm || true

neovim_install:
  #!/bin/bash
  ln -snf {{root_dir}}/.config/nvim ~/.config/nvim

neovim_config: neovim_install

neovim_uninstall:
  #!/bin/bash
  rm -rf ~/.config/nvim ~/.local/state/nvim ~/.local/share/nvim

# Install adi1090x polybar themes then layer dotfiles config on top
polybar_config:
  #!/bin/bash
  TMPDIR=/tmp/polybar-themes
  git clone --depth=1 https://github.com/adi1090x/polybar-themes.git $TMPDIR
  cd $TMPDIR && ./setup.sh <<< 2
  cp -r {{root_dir}}/.config/polybar/. ~/.config/polybar/
  rm -rf /tmp/polybar-themes

omf:
  #!/bin/bash
  curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish

mons_install:
  #!/bin/bash
  git clone --recursive https://github.com/Ventto/mons.git
  cd mons
  sudo make install
  cd ..
  rm -rf mons

xorg_config:
  #!/bin/bash
  sudo cp {{root_dir}}/X11/xorg.conf.d/* /etc/X11/xorg.conf.d/

systemd_config:
  #!/bin/bash
  sudo cp {{root_dir}}/systemd/system/betterlockscreen.service /usr/lib/systemd/system/betterlockscreen@$USER.service
  sudo systemctl enable betterlockscreen@$USER.service
