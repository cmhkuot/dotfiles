#!/bin/bash
#
# bootstrap installs things.

echo 'Bootstrap terminal'
echo '------------------'
echo 'This will reset your terminal. Are you sure you want to to this? (y/n) '
read -p 'Answer: ' reply

if [[ $reply =~ ^[Yy]$ ]]; then
	sudo -v #ask password beforehand
	source ~/.dotfiles/fresh.sh
fi
