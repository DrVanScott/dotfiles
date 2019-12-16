#!/bin/sh

echo "Removing ~/.red-pill"
if [[ -d ~/.red-pill ]]; then
  rm -rf ~/.red-pill
fi

echo "Looking for original zsh config..."
if [ -f ~/.zshrc.pre-red-pill ] || [ -h ~/.zshrc.pre-red-pill ]; then
  echo "Found ~/.zshrc.pre-red-pill -- Restoring to ~/.zshrc";

  if [ -f ~/.zshrc ] || [ -h ~/.zshrc ]; then
    ZSHRC_SAVE=".zshrc.omz-uninstalled-`date +%Y%m%d%H%M%S`";
    echo "Found ~/.zshrc -- Renaming to ~/${ZSHRC_SAVE}";
    mv ~/.zshrc ~/${ZSHRC_SAVE};
  fi

  mv ~/.zshrc.pre-red-pill ~/.zshrc;

  source ~/.zshrc;
else
  echo "Switching back to bash"
  chsh -s /bin/bash
  source /etc/profile
fi

echo "The blue pill will allow you to remain in the fabricated reality ..."
