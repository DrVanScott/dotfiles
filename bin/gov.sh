#!/bin/sh

echo "gov - show or set governor (set requires root privileges)"
echo "usage: [sudo] gov [o|ondemand|f|performance|p|powersave|c|conservative]"
echo "governor in use:"

getgov=$(cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor)

case $1 in
  o|ondemand)     governor=ondemand;;
  f|performance)  governor=performance;;
  p|powersave)    governor=powersave;;
  c|conservative) governor=conservative;;
  *)         echo $getgov
         exit;;
esac

for g in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do echo $governor > $g; done
echo $(cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor)

