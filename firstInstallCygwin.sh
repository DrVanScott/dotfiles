#!/usr/bin/env bash

# use the bash as default "sh", fixed some problems
# with e.g. third-party scripts
#sudo ln -sf /bin/bash /bin/sh

function ask_install() {
  echo
  echo
  read -p"$1 (y/n) " -n 1
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    return 1
  else
    return 0
  fi
}

# use apt-cyg in the next steps ...
if [ \! -f $(whereis apt-cyg | cut -f 2 -d ' ') ] ; then
  lynx -source rawgit.com/transcode-open/apt-cyg/master/apt-cyg > apt-cyg
  install apt-cyg /bin
  rm apt-cyg
fi

# update && upgrade
ask_install "upgrade your system?"
if [[ $? -eq 1 ]]; then
  apt-cyg update
fi

apt-cyg install \
  `# default for many other things` \
  tmux \
  autoconf \
  make \
  cmake \
  dialog \
  `# unzip, unrar etc.` \
  cabextract \
  zip \
  unzip \
  tar \
  p7zip \
  unace \
  bzip2 \
  gzip \
  `# optimize image-size` \
  optipng \
  pngcrush \
  pngnq \
  pngquant \
  `# utilities` \
  coreutils  \
  findutils  \
  colordiff \
  tree \
  `# disk usage viewer` \
  ncdu \
  rsync \
  whois \
  vim \
  vim-common \
  recode \
  `# GNU bash` \
  bash \
  bash-completion \
  `# command line clipboard` \
  xclip \
  `# fonts also "non-free"-fonts` \
  `# -- you need "multiverse" || "non-free" sources in your "source.list" -- ` \
  fontconfig \
  `# get files from web` \
  wget \
  curl \
  w3m \
  `# repo-tools`\
  git \
  subversion \
  mercurial \
  `# usefull tools` \
  which \
  lynx \
  pv \
  xpdf \
  sqlite3 \
  perl \
  python \
  `# install python-pygments for json print` \
  python-pygments

# zsh
ask_install "Do you want to use the zsh-shell?"
if [[ $? -eq 1 ]]; then
  apt-cyg install zsh
  echo "right click on the Sygwin icon in windows and add '/bin/zsh --login'"
  echo ""
  echo "e.g.: C:\cygwin64\bin\mintty.exe -i /Cygwin-Terminal.ico /bin/zsh --login -"
fi

#
# for webworker
#

ask_install "install webworker tools"
if [[ $? -eq 1 ]]; then

  echo "update/install ruby-rems ..."

  gem update --pre

  gem install sass --pre --verbose
  gem install compass --pre --verbose
  gem install autoprefixer-rails --pre --verbose
  gem install compass-rgbapng --pre --verbose
  gem install oily_png --verbose

  echo "update/install npm-packages ..."

  npm config set strict-ssl false
  npm config set registry http://registry.npmjs.org

  npm install -g npm

  npm update -g

  npm install -g diff-so-fancy
  npm install -g bower
  npm install -g grunt-cli
  npm install -g grunt-init
  npm install -g yo
  npm install -g svgo

  echo "install php-5-extensions ..."

  apt-cyg install \
    php \
    php-json \
    php-phar \
    php-mysql \
    php-curl \
    php-gd \
    php-intl \
    php-imap \
    php-mcrypt \
    php-pspell \
    php-recode \
    php-tidy \
    php-xmlrpc \
    php-xsl \
    php-tokenizer \
    php-ctype

  if [ \! -f $(whereis apt-cyg | cut -f 2 -d ' ') ] ; then
    curl -sS https://getcomposer.org/installer | php --
    install composer.phar /usr/bin
    ln -s /usr/bin/composer.phar /usr/bin/composer
    rm composer.phar
  fi

fi

# update-fonts
mkdir -p /usr/share/fonts/truetype/
cp -vr $( dirname "${BASH_SOURCE[0]}" )/.fonts/* /usr/share/fonts/truetype/
fc-cache -fv

