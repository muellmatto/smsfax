This scripts uses:  

* unix2dos (dos2unix)
* fmt (coreutils)
* iconv (glibc)
* figlet (figlet)
* figlet-fonts (AUR!)
* cowsay (cowsay)  
* xxd (vim)

        pacman -S community/dos2unix figlet cowsay
        yaourt -S figlet-fonts


# setup

1. edit `bindir` in `sms.sh` and `gen_manual.sh` to the right location
2. edit `thermo.sh` to choose a `printer`

If using `gammu-smsd`, edit config to point `RunOnReceive` to `sms.sh`

# /bin 

## get help

    ./gen_manual

## usage

    SMS_1_NUMBER="+49123456789" SMS_1_TEXT="#FS Test Oi!" ./sms.sh

## check_ll.sh

Check ASCII files for valid line length (<=24)  

    18:51 $ ./check_ll.sh ../art/batman.txt 
    OK ✔
    18:51 $ ./check_ll.sh ../art/cowsay_head_in.txt 
    ASCII ist zu breit!

