#!/bin/bash

## Get phonenumber and message:

from=$SMS_1_NUMBER
m1=$SMS_1_TEXT
m2=$SMS_2_TEXT
m3=$SMS_3_TEXT
m4=$SMS_4_TEXT
m5=$SMS_5_TEXT
# m6=$SMS_6_TEXT
# m7=$SMS_7_TEXT

## concatenate sms messages:

m=$m1$m2$m3$m4$m5

#if [ -z $m ]
#    then
#        exit 1
#fi


## Replace Umlaute

#m=${m//Ü/Ue}
#m=${m//ü/ue}
#m=${m//Ä/Ae}
#m=${m//ä/ae}
#m=${m//Ö/Oe}
#m=${m//ö/oe}
#m=${m//ß/ss}


## Replace some Emojis

m=${m//😀/\ :-)\ }
#m=${m//👍/\ :-)\ }
#m=${m//😀/\ :-)\ }
#m=${m//😀/\ :-)\ }
#m=${m//😀/\ :-)\ }
#m=${m//😀/\ :-)\ }

# message=$m

## Substitute phonenumber with names

case $from in
"+4917656955101")
  from="Sapho"
  ;;
"+491721978753")
  from="Matto"
  ;;
"+4916095486022")
  from="Max"
  ;;
"+491635078296")
  from="May"
  ;;
"+491774433546")
  from="Markus"
  ;;
"+4916096688014")
  from="Boiko"
  ;;
esac

## Greeter
intro="Wichtige Durchsage von $from!"


out () {
    echo -e "$intro \n$m" | /home/matto/bin/thermo.sh 
}



## ----------------------------------
## cowsay style

cow () {
    case "${m:2:2}" in
        "B ")
            style="bong"
        ;;
        "b ")
            style="bunny"
        ;;
        "C ")
            style="small"
        ;;
        "E ")
            style="elephant"
        ;;
        "H ")
            style="hellokitty"
        ;;
        "K ")
            style="koala"
        ;;
        "L ")
            style="luke-koala"
        ;;
        "M ")
            style="milk"
        ;;
        "R ")
            style="ren"
        ;;
        "S ")
            style="stimpy"
        ;;
        "s ")
            style="sheep"
        ;;
        "T ")
            style="tux"
        ;;
        "V ")
            style="vader-koala"
        ;;
        *)
            style="small"
        ;;
    esac
    # -W 20 !
    cowsay -f $style -W 20 "$intro ${m:4}" | /home/matto/bin/thermo.sh
}


## --------------------------------
## figlet style / font

font () {
    case "${m:2:2}" in
        "C ")
            style="contessa"
        ;;
        "3 ")
            style="banner3-D"
        ;;
        "S ")
            style="small"
        ;;
        "I ")
            style="isometric4"
        ;;
        *)
            style="small"
        ;;
    esac
    echo -e "$intro \n" | /home/matto/bin/thermo.sh 
    figlet -w 24 -f $style "${m:4}" | /home/matto/bin/thermo.sh
}

## -----------------------------
## ascii art

art () {
    case "${m:2:2}" in
        "B ")
            file="batman.txt"
        ;;
        *)
            file="batman.txt"
        ;;
    esac
    echo -e "$intro \n${m:4}\n" | /home/matto/bin/thermo.sh 
    cat "/home/matto/art/$file" | /home/matto/bin/thermo.sh
}



parser () {
    case ${m:0:2} in
        "#C")
            cow
        ;;
        "#A")
            art
        ;;
        "#F")
            font
        ;;
        *)
            out
        ;;
esac
}

parser
