#!/bin/bash
# usage: $ ./check_ll.sh ../art/batman.txt

NUM=$(wc -L "$1"  |awk '{print $1}')
if (( NUM > 24 )); then
  echo "ASCII ist zu breit!"
  exit 1
fi
echo "OK ✔"
exit 0

