set shell := ["/bin/bash", "-c"]

root_dir := source_dir()

[linux]
setup: yay install_pkgs config tpm_install xorg_config systemd_config sound_setup

[macos]
setup: install_pkgs config mise_tools login_shell tpm_install macos_defaults tailscale_daemon

[linux]
install: install_pkgs

[macos]
install: install_pkgs

[linux]
yay:
  #!/bin/bash
  git clone https://aur.archlinux.org/yay.git ~/yay
  cd ~/yay
  makepkg -si
  rm -rf ~/yay

[linux]
install_pkgs:
  #!/bin/bash
  sudo pacman -S --noconfirm mise gtk2 less lxsession-gtk3 xorg-server git gitui github-cli alacritty tmux rofi dunst polybar neovim exa bat zoxide ripgrep picom unzip
  sudo pacman -S --noconfirm pipewire pavucontrol playerctl pamixer brightnessctl

  sudo pacman -S --noconfirm bluez bluez-utils blueman

  sudo pacman -S --noconfirm vlc feh flameshot lxappearance-gtk3 papirus-icon-theme
  sudo pacman -S --noconfirm thunar catfish gvfs thunar-volman thunar-archive-plugin thunar-media-tags-plugin
  sudo pacman -S --noconfirm fcitx5-bamboo fcitx5-configtool
  yay -S --noconfirm arc-gtk-theme google-chrome betterlockscreen

  sudo pacman -S ttf-firacode-nerd ttf-font-awesome
  yay -S --noconfirm noto-fonts noto-fonts-emoji noto-fonts-cjk noto-fonts-extra

  sudo cp {{root_dir}}/scripts/rofi_run /usr/local/bin/rofi_run

  gsettings set org.gnome.desktop.interface color-scheme prefer-dark

[macos]
install_pkgs:
  #!/bin/bash
  if ! command -v brew >/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  /opt/homebrew/bin/brew bundle --file {{root_dir}}/Brewfile

# --force overwrites Brewfile and drops its comments, so review the diff
[macos]
brew_dump:
  brew bundle dump --force --file {{root_dir}}/Brewfile

# Needs `config` first, which links .config/mise/config.toml
[macos]
mise_tools:
  mise install

[macos]
login_shell:
  #!/bin/bash
  set -euo pipefail
  fish_path="$(brew --prefix)/bin/fish"
  grep -qxF "$fish_path" /etc/shells || echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
  if [ "$(dscl . -read ~/ UserShell | awk '{print $2}')" != "$fish_path" ]; then
    chsh -s "$fish_path"
  fi

[macos]
macos_defaults:
  {{root_dir}}/scripts/macos-defaults.sh

# Do not install the Tailscale GUI app next to this daemon.
# Runs at boot so the Mac is reachable before GUI login
[macos]
tailscale_daemon:
  sudo brew services start tailscale

[linux]
update_mirrors:
  #!/bin/bash
  sudo pacman -Syyu
  sudo pacman -S --noconfirm reflector
  sudo reflector --latest 5 --protocol https --sort rate --save /etc/pacman.d/mirrorlist --country Vietnam,Singapore,WorldWide

config:
  mise -C {{root_dir}} trust --all
  mise -C {{root_dir}} dot apply

[linux]
sound_setup:
  #!/bin/bash
  pactl load-module module-switch-on-connect

tpm_install:
  [ ! -d ~/.config/tmux/plugins/tpm ] && git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm || true

neovim_uninstall:
  #!/bin/bash
  rm -rf ~/.config/nvim ~/.local/state/nvim ~/.local/share/nvim

[linux]
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

omf_uninstall:
  #!/bin/bash
  rm -rf ~/.config/omf ~/.local/share/omf

[linux]
mons_install:
  #!/bin/bash
  git clone --recursive https://github.com/Ventto/mons.git
  cd mons
  sudo make install
  cd ..
  rm -rf mons

[linux]
xorg_config:
  #!/bin/bash
  sudo cp {{root_dir}}/X11/xorg.conf.d/* /etc/X11/xorg.conf.d/

[linux]
systemd_config:
  #!/bin/bash
  sudo cp {{root_dir}}/systemd/system/betterlockscreen@.service /usr/lib/systemd/system/betterlockscreen@$USER.service
  sudo systemctl enable betterlockscreen@$USER.service
