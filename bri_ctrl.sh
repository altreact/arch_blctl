#!usr/bin/env bash

if [ "$(whoami)" != 'root' ]; then
  echo
  echo 'script must be ran as root'
  echo
  exit 1
fi

echo 'f /sys/class/backlight/backlight.12/brightness 0666 - - - 800' > /etc/tmpfiles.d/brightness.conf

echo '#!/usr/bin/env bash

b="$(find /sys/class/backlight/*/ -name brightness -type f)"
mb="$(find /sys/class/backlight/*/ -name max_brightness -type f)"

cur_bri="$(cat $b)"
maxb="$(cat $mb)" 
step=100

if [ $1 = 'u' ] && [ `expr $cur_bri + $step` -le $maxb ]; then
    echo `expr $cur_bri + $step` > $b
fi

if [ $1 = 'd' ] && [ `expr $cur_bri - $step` -ge 0 ]; then
    echo `expr $cur_bri - $step` > $b
fi

if [ $1 = 'step' ]; then
    cs="$(cat /usr/local/bin/b | grep step= | head -n1)"
    sections="$(($maxb/$2))"
    sed -i "s/$cs/step=$sections/" /usr/local/bin/b 
fi

' > /usr/local/bin/b

chmod +x /usr/local/bin/b

echo
echo 'b u "brightness up"'
echo 'b d "brightness down"'
echo 'b step [num] "gives you [num] steps between minimum and maximum brightness"'
echo
