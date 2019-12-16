#!/bin/sh

set -e

if [ ! -n "$ZSH" ]; then
  ZSH=~/.red-pill
fi

if [ -d "$ZSH" ]; then
  echo "\033[0;33mYou already seen the matrix.\033[0m You'll need to remove $ZSH if you want to install"
  exit
fi

echo "\033[0;34mCloning the repo...\033[0m"
hash git >/dev/null 2>&1 && env git clone --depth=1 https://github.com/voku/dotfiles.git $ZSH || {
  echo "git not installed"
  exit
}

if [ "$SHELL" != "$(which zsh)" ]; then
  echo "\033[0;34mTime to change your default shell to zsh!\033[0m"
  chsh -s `which zsh`
fi

echo "\n\n \033[0;32mPlease look over the ~/.config_dotfiles file to select plugins, themes, and options.\033[0m"
env zsh
. ~/.zprofile

