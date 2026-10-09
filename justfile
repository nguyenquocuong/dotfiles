set shell := ["/bin/bash", "-c"]

root_dir := source_dir()

# Full first-time machine setup in logical order
[linux]
setup: yay install_pkgs config neovim_install tpm_install xorg_config systemd_config sound_setup

[macos]
setup: install_pkgs config tpm_install macos_defaults tailscale_daemon

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

# Install everything in Brewfile (installs Homebrew first if missing)
[macos]
install_pkgs:
  #!/bin/bash
  if ! command -v brew >/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  /opt/homebrew/bin/brew bundle --file {{root_dir}}/Brewfile

# Save installed Homebrew packages back to Brewfile, then review the diff
[macos]
brew_dump:
  brew bundle dump --force --file {{root_dir}}/Brewfile

# Apply macOS system settings
[macos]
macos_defaults:
  {{root_dir}}/scripts/macos-defaults.sh

# Do not install the Tailscale GUI app next to this daemon.
# Run tailscaled at boot, so the Mac is reachable before GUI login
[macos]
tailscale_daemon:
  sudo brew services start tailscale

[linux]
update_mirrors:
  #!/bin/bash
  sudo pacman -Syyu
  sudo pacman -S --noconfirm reflector
  sudo reflector --latest 5 --protocol https --sort rate --save /etc/pacman.d/mirrorlist --country Vietnam,Singapore,WorldWide

# Symlink all user configs into ~/.config and ~/
config: claude_config config_shared config_os

# Configs used on every OS
config_shared:
  #!/bin/bash
  mkdir -p ~/.config ~/.config/tmux

  ln -snf {{root_dir}}/.gitconfig ~/.gitconfig

  ln -snf {{root_dir}}/.config/fish        ~/.config/fish
  ln -snf {{root_dir}}/.config/omf         ~/.config/omf
  ln -snf {{root_dir}}/.config/alacritty   ~/.config/alacritty
  ln -snf {{root_dir}}/.config/wezterm     ~/.config/wezterm
  ln -snf {{root_dir}}/.config/nvim        ~/.config/nvim
  ln -snf {{root_dir}}/.config/mise        ~/.config/mise

  ln -snf {{root_dir}}/.config/tmux/tmux.conf       ~/.config/tmux/tmux.conf
  ln -snf {{root_dir}}/.config/tmux/tmuxline_theme  ~/.config/tmux/tmuxline_theme

  # Alacritty imports os.toml for OS-specific settings
  ln -snf {{os()}}.toml {{root_dir}}/.config/alacritty/os.toml

  # chsh -s $(which fish)

[linux]
config_os:
  #!/bin/bash
  ln -snf {{root_dir}}/.xinitrc ~/.xinitrc

  ln -snf {{root_dir}}/.config/dunst       ~/.config/dunst
  ln -snf {{root_dir}}/.config/i3          ~/.config/i3
  ln -snf {{root_dir}}/.config/picom       ~/.config/picom
  # ln -snf {{root_dir}}/.config/polybar     ~/.config/polybar
  ln -snf {{root_dir}}/.config/rofi        ~/.config/rofi

[macos]
config_os:
  #!/bin/bash
  ln -snf {{root_dir}}/.config/aerospace   ~/.config/aerospace

# Symlink Claude Code global instructions and statusline script into ~/.claude
claude_config:
  #!/bin/bash
  mkdir -p ~/.claude ~/.claude/skills
  ln -snf {{root_dir}}/.claude/CLAUDE.md ~/.claude/CLAUDE.md
  ln -snf {{root_dir}}/scripts/claude-statusline.sh ~/.claude/statusline.sh

  # Symlink each custom skill into ~/.claude/skills
  for skill in {{root_dir}}/.claude/skills/*/; do
    ln -snf "$skill" ~/.claude/skills/"$(basename "$skill")"
  done

[linux]
sound_setup:
  #!/bin/bash
  pactl load-module module-switch-on-connect

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
  sudo cp {{root_dir}}/systemd/system/betterlockscreen.service /usr/lib/systemd/system/betterlockscreen@$USER.service
  sudo systemctl enable betterlockscreen@$USER.service
