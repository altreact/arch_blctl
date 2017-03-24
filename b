#!/usr/bin/env bash

b="/sys/class/backlight/backlight.12/brightness"
mb="/sys/class/backlight/backlight.12/max_brightness"
cur_bri=$(/usr/bin/cat $b)
maxb=$(/usr/bin/cat $mb) 
incr=100

if [ $1 = "u" ] && [ `expr $cur_bri + $incr` -le $maxb ]; then
    echo `expr $cur_bri + $incr` > $b
fi
if [ $1 = "d" ] && [ `expr $cur_bri - $incr` -ge 0 ]; then
    echo `expr $cur_bri - $incr` > $b
fi
