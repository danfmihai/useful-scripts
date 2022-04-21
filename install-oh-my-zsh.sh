#!/bin/bash
# WILL INSTALL ZSH SHELL AND OH-MY-ZSH FRAMEWORK

apt update && apt install -y zsh git curl

echo "zsh is installed at:"
which zsh
echo
echo "Changing default shell:"
chsh -s $(which zsh)

echo "Installing oh-my-zsh:"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
