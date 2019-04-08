#!/bin/bash

echo "Disabling networking..."
sudo kextunload /System/Library/Extensions/IONetworkingFamily.kext/Contents/PlugIns/Intel82574L.kext
sleep 2

echo "Freezing VM..."
sleep 1
sudo /Library/Application\ Support/VMware\ Tools/vmware-tools-daemon --cmd="instantclone.freeze"

echo "Reenabling networking..."
sudo kextload /System/Library/Extensions/IONetworkingFamily.kext/Contents/PlugIns/Intel82574L.kext

echo "Waiting for IP..."
while ! ifconfig en0 | grep 'inet 10'; do
  sleep 1
done

echo "Updating guest info for networking..."
sudo /Library/Application\ Support/VMware\ Tools/vmware-tools-cli info update network

echo "Updating clock..."
sudo sntp -sS pool.ntp.org
