#!/bin/bash

## Get phonenumber and message(s): ################################
from=$SMS_1_NUMBER
m1=$SMS_1_TEXT
m2=$SMS_2_TEXT
m3=$SMS_3_TEXT
m4=$SMS_4_TEXT
m5=$SMS_5_TEXT

## concatenate sms messages: #####################################
m=$m1$m2$m3$m4$m5

## Check ist message is empty ###################################
## Warning: gen_manual.sh uses an empty messaage
#if [ -z $m ] ; then exit 0 ; fi

### TODO : Mehr Emojis, evtl manche gegen n ascii art ersetzen!
## Replace some Emojis ############################################
m=${m//😀/\ :-)\ }
#m=${m//👍/\ :-)\ }


## Script location #################################################
bindir="/home/matto/Workspace/engelsmsfax/smsfax/bin"
artdir="/home/matto/Workspace/engelsmsfax/smsfax/art"
artfile="/home/matto/Workspace/engelsmsfax/smsfax/bin/art.csv"
numfile="/home/matto/Workspace/engelsmsfax/smsfax/bin/nummern.csv"


## Substitute phonenumber with names ################################
if [ -n $(grep $from "$numfile" | cut -d ";" -f 2) ]
    then
        from=$(grep $from "$numfile" | cut -d ";" -f 2)
fi


## Greeter ##########################################################
intro="Wichtige Durchsage von $from!"


## Plain text out ###################################################
out () {
    echo -e "$intro \n$m" | $bindir/thermo.sh 
    }


## cowsay out ########################################################
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
    cowsay -f $style -W 20 "$intro ${m:4}" | $bindir/thermo.sh
}


## figlet style / font out ###################################################
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
    echo -e "$intro \n" | $bindir/thermo.sh
    ## figlet kennt keine Umlaute!
    m=${m//Ü/Ue}
    m=${m//ü/ue}
    m=${m//Ä/Ae}
    m=${m//ä/ae}
    m=${m//Ö/Oe}
    m=${m//ö/oe}
    m=${m//ß/ss}
    #### TODO
    ## Große Fonts, wie isometric drucken keine leerzeichen, baucht wie nen workaround
    ## vll n paar mal echo -e "\n" | $bindir/thermo.sh oder so 
    figlet -w 24 -f $style "${m:4}" | $bindir/thermo.sh
}


## ascii art out ##########################################################
art () {
    ## fallback-file
    file="batman.txt"
    # check art.csv
    if [ $(grep "${m:2:2}" "$artfile" | cut -d ";" -f 2) ]
        then
            file=$(grep "${m:2:2}" "$artfile" | cut -d ";" -f 2)
    fi
    #case "${m:2:2}" in
    #    "B ")
    #        file="batman.txt"
    #    ;;
    #    *)
    #        file="batman.txt"
    #    ;;
    #esac
    echo -e "$intro \n${m:4}\n" | $bindir/thermo.sh 
    cat "$artdir/$file" | $bindir/thermo.sh
}


## Message parser #######################################################
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


## Start: calling parser ##############################################

parser
