#!/usr/bin/env bash

echo -e "${COLOR_GREEN}"

for z in {1..50}; do
  for i in {1..16}; do
    r="$(($RANDOM % 2))"
    if [[ $(($RANDOM % 5)) == 1 ]]; then
      if [[ $(($RANDOM % 4)) == 1 ]]; then
        v+="\e[1m $r   "
      else
        v+="\e[2m $r   "
      fi
    else
      v+="     "
    fi
  done
  echo -e "$v"
  v="";
done

echo "      _       _         __ _ _"
echo "   __| | ___ | |_      / _(_) | ___  ___"
echo "  / _\` |/ _ \| __|____| |_| | |/ _ \/ __|"
echo " | (_| | (_) | ||_____|  _| | |  __/\__ \\"
echo "  \__,_|\___/ \__|    |_| |_|_|\___||___/"
echo ""

echo -e "${COLOR_NO_COLOUR}"


if [[ "$1" == "--force" ]] || [[ "$1" == "-f" ]]; then
  FORCE=1
else
  FORCE=0
fi

git pull origin master

doIt()
{
  if [ ! -f ~/.config_dotfiles ]; then
    cp .config_dotfiles_default ~/.config_dotfiles
  fi

  # save old global git config
  OLDMASK=$(umask)
  umask 0077
  git config --global -l | LANG=C sort > .oldgit$$.tmp
  umask $OLDMASK

  # copy dotfiles
  if which rsync >/dev/null 2>&1; then
    rsync --exclude-from .IGNORE -avhiE --no-perms . ~/
  else

    local ignore=""
    local line_tmp
    while read -ra line; do
      line_tmp=$(echo $line | sed "s/\n//g")
      if [[ ! -z $line_tmp ]]; then
        ignore="$ignore|$line_tmp"
      fi
    done < .IGNORE

    ignore=$(echo $ignore | sed "s/\./\\\./g")

    cp -pvr `ls -A | grep -vE ".git$ignore"` ~/
  fi

  # check for "force"
  if [[ "$FORCE" == "1" ]]; then
    return 0
  fi

  # save new global git config
  OLDMASK=$(umask)
  umask 0077
  git config --global -l | LANG=C sort > .newgit$$.tmp
  umask $OLDMASK

  echo "git configuration not present anymore after bootstrapping:"
  LANG=C comm -23 .oldgit$$.tmp .newgit$$.tmp
  echo -e "\nYou can use the following commands to add it again:"
  LANG=C comm -23 .oldgit$$.tmp .newgit$$.tmp | while read line; do echo "git config --global "$(echo $line | sed 's/=/ '"'"'/;s/$/\'"'"'/'); done

  # restore git?
  read -p "Do you want to restore these git configs now? (y/n) " -n 1 yesOrNo
  echo
  if [[ $yesOrNo =~ ^[Yy]$ ]]; then
    LANG=C comm -23 .oldgit$$.tmp .newgit$$.tmp | while IFS="=" read  key value; do git config --global "$key" "$value"; done
  fi
  rm .oldgit$$.tmp .newgit$$.tmp

  crlf_warning=""
  # vim doesn't like ^M (CRLF) in .vim files. Make sure this will not happen on cygwin / windows systems
  if [ "$(git config --system --get core.autocrlf)" == "true" ]; then
    crlf_warning="--system "
  fi
  if [ "$(git config --global --get core.autocrlf)" == "true" ]; then
    crlf_warning="${crlf_warning}--global"
  fi
  if [ -n "$crlf_warning" ]; then
    echo "git config 'core.autocrlf' is currently true in '$crlf_warning'. Unset temporarly, otherwise VIM may have big problems!"
    return 1
  fi

  # install vim-plugin-manager
  if [ ! -d ~/.vim/bundle/vundle ]; then
    mkdir ~/.vim/bundle
    git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
    vim +BundleInstall +qall
  else
    read -p "Do you want to update vim-plugins? (y/n) " -n 1 yesOrNo
    echo
    if [[ $yesOrNo =~ ^[Yy]$ ]]; then
      (
        cd ~/.vim/bundle/vundle
        git pull
        vim +BundleUpdate +qall
      )
    fi
  fi
}

dryRun()
{
  if which rsync >/dev/null 2>&1; then
    rsync --exclude-from .IGNORE -avhniE --no-perms . ~/
  else
    LC_ALL=C diff -w -B -r . ~/ | grep -v '^Only in'
  fi
}

if [[ "$FORCE" == "1" ]]; then
  doIt
else
  echo "Executing dry run..."
  echo

  dryRun
  echo
  echo
  read -p "The files listed above will overwritten in your home directory. Are you sure you want to continue? (y/n) " -n 1 yesOrNo
  echo
  if [[ $yesOrNo =~ ^[Yy]$ ]]; then
    doIt
  fi
fi

unset -f doIt
unset -f dryRun
