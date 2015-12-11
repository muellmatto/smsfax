#!/bin/bash
while IFS= read -r line
    #### STDOUT
    do echo -n "$line" | fmt -w 25 -s 
    #### "Virtual Printer"
    # do echo -n "$line" | fmt -w 25 -s >> /home/matto/bla.txt
    #### Real Printer
    # -w 24 müsste richtig sein, aber 25 klappt auch und wurde im netz empfohle ...
    # do echo -n "$line" | fmt -w 24 -s | unix2dos | iconv -f UTF-8 -t 437 -c > /dev/usb/lp0
    # do echo -n "$line" | fmt -w 25 -s | unix2dos | iconv -f UTF-8 -t 437 -c > /dev/usb/lp0
done

