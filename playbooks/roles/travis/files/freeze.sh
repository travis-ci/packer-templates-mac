#!/bin/bash

cat <<EOF | sudo tee /Library/Application\ Support/VMware\ Tools/tools.conf
[guestinfo]
poll-interval = 5
EOF
sudo killall vmware-tools-daemon

echo "Disabling networking..."
sudo kextunload /System/Library/Extensions/IONetworkingFamily.kext/Contents/PlugIns/Intel82574L.kext
sleep 2

echo "Freezing VM..."
sleep 1
sudo /Library/Application\ Support/VMware\ Tools/vmware-tools-daemon --cmd="instantclone.freeze"

echo "Reenabling networking..."
sudo kextload /System/Library/Extensions/IONetworkingFamily.kext/Contents/PlugIns/Intel82574L.kext
