#!/bin/bash
sudo apt-get update
sudo apt-get install -y --no-install-recommends curl
sudo apt-get install -y --no-install-recommends emacs
sudo apt-get install -y --no-install-recommends net-tools
sudo apt-get install -y --no-install-recommends openssh-server
sudo apt-get install -y --no-install-recommends python-pip
sudo apt-get install -y --no-install-recommends python3-pip
sudo apt-get install -y --no-install-recommends python3-setuptools
sudo apt-get install -y --no-install-recommends zip unzip
sudo apt-get install -y --no-install-recommends x11-apps x11-utils x11-xserver-utils dbus-x11
sudo apt-get install -y --no-install-recommends git gosu wget
sudo apt-get install -y --no-install-recommends supervisor xvfb xfce4 x11vnc
sudo apt-get install -y --no-install-recommends vim-nox xfce4-terminal xterm tzdata rsync



# emacs
if [ ! -d ~/.emacs.d ]; then
  mkdir ~/.emacs.d
fi
if [ ! -e ~/.emacs.d/init.el ]; then
  touch ~/.emacs.d/init.el
fi
if ! grep -q "(setq inhibit-startup-message t)" ~/.emacs.d/init.el; then
  echo "(setq inhibit-startup-message t)" >> ~/.emacs.d/init.el
fi
