set shell := ["/bin/bash", "-c"]

install: install_pkgs

install_pkgs:
  #!/bin/bash
  
  sudo pacman -S --noconfirm less lxsession-gtk3 xorg-server git gitui github-cli alacritty tmux rofi dunst polybar neovim ttf-firacode-nerd exa bat zoxide ripgrep ttf-font-awesome
  sudo pacman -S --noconfirm pipewire pavucontrol playerctl pamixer

  # Applications
  sudo pacman -S --noconfirm vlc feh flameshot lxappearance arc-gtk-theme papirus-icon-theme
  sudo pacman -S --noconfirm thunar catfish gvfs thunar-volman thunar-archive-plugin thunar-media-tags-plugin
  yay -S --noconfirm ibus-bamboo google-chrome
  
  sudo cp rofi_run /usr/local/bin

  # Tmux
  cp .tmux.conf ~/

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

nvm_install:
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

fisher_install:
  #!/bin/fish

  curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

  fisher install jorgebucaran/nvm.fish

omf_install:
  #!/bin/bash

  curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
  omf install pure foreign-env
