#!/bin/bash

echo "Running Clean Your Mac Script 💛"
echo -n "Do you want to perform Brew 🍺 tasks(y/n)? "
read ANSWER

if [ "$ANSWER" != "${ANSWER#[Yy]}" ]; then
    #Updating brew
    echo "Updating Brew 🍺 and Cleaning up the Cask 🌊. This might take some time depending upon your network connection and packages installed."
    brew update
    brew upgrade
    brew cleanup --prune=30
    brew doctor
fi

#user cache file
echo "Cleaning user cache file from ~/Library/Caches"
sudo rm -rf ~/Library/Caches/*
echo "✅ Done Cleaning from ~/Library/Caches"

#user logs
echo "Cleaning user log file from ~/Library/logs"
sudo rm -rf ~/Library/logs/*
echo "✅ Done Cleaning from ~/Library/logs"

#system caches
echo "Cleaning system caches"
sudo rm -rf /Library/Caches/*
echo "✅ Done Cleaning system cache"

#system logs
echo "Cleaning system logs from /Library/logs"
sudo rm -rf /Library/logs/*
echo "✅ Done Cleaning from /Library/logs"
echo "Cleaning system logs from /var/log"
sudo rm -rf /var/log/*
echo "✅ Done Cleaning from /var/log"
echo "Cleaning from /private/var/folders"
sudo rm -rf /private/var/folders/*
echo "✅ Done Cleaning from /private/var/folders"

#ios photo caches
echo "Cleaning ios photo caches"
rm -rf ~/Pictures/iPhoto\ Library/iPod\ Photo\ Cache/*
echo "✅ Done Cleaning from ~/Pictures/iPhoto Library/iPod Photo Cache"

#application caches
echo "Cleaning application caches"
for x in $(ls ~/Library/Containers/); do
    echo "Cleaning ~/Library/Containers/$x/Data/Library/Caches/"
    rm -rf ~/Library/Containers/$x/Data/Library/Caches/*
    echo "✅ Done Cleaning ~/Library/Containers/$x/Data/Library/Caches"
done

echo 'Purge inactive memory…'
sudo purge
echo "✅ Done purge inactive memory…"

echo "✅ Done Cleaning for application caches"
