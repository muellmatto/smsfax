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
#m=${m//👍/\ :-)\ }
m=${m//☺/\ :)\ }
m=${m//😊/\ :-)\ }
m=${m//😀/\ :-D\ }
m=${m//😁/\ :-)\ }
m=${m//😂/\ :-)\ }
m=${m//😃/\ :-)\ }
m=${m//😄/\ :-)\ }
m=${m//😅/\ :-)\ }
m=${m//😆/\ :-)\ }
m=${m//😉/\ :-)\ }
m=${m//😯/\ :-)\ }




## Script location #################################################
maindir="/home/matto/Workspace/engelsmsfax/smsfax"
bindir="$maindir/bin"
artdir="$maindir/art"
fontfile="$maindir/bin/fonts.csv"
cowfile="$maindir/bin/cowsay.csv"
artfile="$maindir/bin/art.csv"
numfile="$maindir/bin/nummern.csv"


## Substitute phonenumber with names ################################
nummer=$from
if [[ $(grep $from $numfile | cut -d ";" -f 2) ]]
    then
        from=$(grep $from $numfile | cut -d ";" -f 2)
fi


## Greeter ##########################################################
intro="Wichtige Durchsage von $from!"


## Plain text out ###################################################
out () {
    echo -e "$intro \n$m" | $bindir/thermo.sh 
    }


## cowsay out ########################################################
cow () {
    ## fallback style
    style="small"
    # check cowsay.csv
    if [ $(grep "${m:2:2}" "$cowfile" | cut -d ";" -f 2) ]
        then
            style=$(grep "${m:2:2}" "$cowfile" | cut -d ";" -f 2)
    fi
    cowsay -f $style -W 20 "$intro ${m:4}" | $bindir/thermo.sh
}


## figlet style / font out ###################################################
font () {
    ## fallback-font
    style="short"
    # check art.csv
    if [ $(grep "${m:2:2}" "$fontfile" | cut -d ";" -f 2) ]
        then
            style=$(grep "${m:2:2}" "$fontfile" | cut -d ";" -f 2)
    fi
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
    echo -e "$intro \n${m:4}\n" | $bindir/thermo.sh 
    cat "$artdir/$file" | $bindir/thermo.sh
}


## binary picture out #######################################################
bild () {
    echo -e "$intro \n \n" | $bindir/thermo.sh 
    #echo ${m:2} | base64 -d | xxd -c 3 -b | cut -c 11-35 | sed -e 's/ //g' -e 's/0/ /g' -e 's/1/#/g' | $bindir/thermo.sh
    echo ${m:2} | base64 -d | xxd -g 0 -c 3 -b | cut -c 11-35 | sed -e 's/0/ /g' -e 's/1/#/g' | $bindir/thermo.sh
}


## register nickname #######################################################
nickname () {
    echo -e "$from heißt jetzt ${m:3}" | $bindir/thermo.sh
    if [[ $(grep $from $numfile | cut -d ";" -f 2) ]]
        then
            sed -i "s/$nummer;$from/$nummer;${m:3}/g" $numfile
        else
            echo "$nummer;${m:3}" >> $numfile
        fi
     
}


## Message parser #######################################################
parser () {
    case ${m:0:2} in
        "#A")
            art
        ;;
        "#B")
            bild
        ;;
        "#C")
            cow
        ;;
        "#F")
            font
        ;;
        "#N")
            nickname
        ;;
        *)
            out
        ;;
esac
}


## Start: calling parser ##############################################

parser
