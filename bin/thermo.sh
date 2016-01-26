#!/bin/bash
# Start led-script and keep pid, to kill it later!
/home/alarm/Workspace/engelsmsfax/smsfax/bin/leds.py & pid_blink=$!

## write line per line to printer
while IFS= read -r line
    #### STDOUT
    # do echo -n "$line" | fmt -w 25 -s 
    #### "Virtual Printer"
    # do echo -n "$line" | fmt -w 25 -s >> /home/alarm/bla.txt
    #### Real Printer
    # -w 24 müsste richtig sein, aber 25 klappt auch und wurde im netz empfohle ...
    # do echo -n "$line" | fmt -w 25 -s | unix2dos | iconv -f UTF-8 -t 437 -c > /dev/usb/lp0
    ## write to printer AND file!
    do echo -n "$line" | fmt -w 25 -g 24 -s| iconv -s -t 437 -c | unix2dos | tee /dev/usb/lp0 >> /home/alarm/bla.txt
    sleep 1
done

## Wait and kill led-script
sleep 2
kill $pid_blink
