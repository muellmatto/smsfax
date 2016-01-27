#!/bin/bash
## Mit Leerzeichen
echo -e \\x{{2..9},{A..F}}{{0..9},{A..F}}|unix2dos -f >/dev/usb/lp0
## Ohne Leerzeichen
# echo -e \\x{{2..9},{A..F}}{{0..9},{A..F}}|sed -e 's/ //g'|unix2dos -f >/dev/usb/lp0
