#!/bin/bash

## Nur Mono, sonst rauscht es wie beschissen!

## Check if already set:
if [[ $(gpio -g readall| sed -n 9p|cut -f 25 -d " ") == "ALT5" ]]; then
    echo "GPIO18 already in ALT5-Mode"
else
	echo "Link PWM0 to GPIO18 - ALT5-Mode"
	echo "gpio -g mode 18 ALT5"
	gpio -g mode 18 ALT5
fi


# echo "Link PWM0 to GPIO18 - ALT0-Mode"
# echo "gpio -g mode 13 ALT0"
# gpio -g mode 13 ALT0
