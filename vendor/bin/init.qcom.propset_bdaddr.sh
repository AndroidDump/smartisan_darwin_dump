#! /vendor/bin/sh
bdaddr=`cat /mnt/vendor/persist/bd_addr.txt`
setprop net.bluetooth.macaddr $bdaddr
