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


## Get Date from SMS: ############################################
Jahr=${1:2:4}
Jahr=$((Jahr - 30))
month=(XXX Januar Februar März April Mai Juni Juli August September Oktober November Dezember)
Monat=${month[${1:6:2}]}
Tag=${1:8:2}
Stunde=${1:11:2}
Minute=${1:13:2}

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
maindir="/home/alarm/Workspace/engelsmsfax/smsfax"
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
#intro="Es ist $Stunde:$Minute Uhr am $Tag. $Monat $Jahr und es gibt eine Wichtige Durchsage von $from!"
intro="$Tag. $Monat $Jahr, $Stunde:$Minute Wichtige Durchsage von $from!"

# intro="Wichtige Durchsage von $from!"
#date='╔═════════════╦════╗
#║'$Tag'. '$Monat'║'$Jahr'║
#╠═════════════╩════╣
#║       '$Stunde':'$Minute'      ║
#╚══════════════════╝'

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
    sleep 1 # mehr zeit 
    ## figlet kennt keine Umlaute!
    m=${m//Ü/Ue}
    m=${m//ü/ue}
    m=${m//Ä/Ae}
    m=${m//ä/ae}
    m=${m//Ö/Oe}
    m=${m//ö/oe}
    m=${m//ß/ss}
    m=${m//\!/ \!}
    m=${m//\?/ \?}

    #### TODO
    ## Große Fonts, wie isometric drucken keine leerzeichen, baucht wie nen workaround
    ## vll n paar mal echo -e "\n" | $bindir/thermo.sh oder so
    ## sed -e 's/ /\n\n/g' 
    echo -e "${m:4}" | figlet -w 24 -f $style | $bindir/thermo.sh
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
    echo ${m:2} | base64 -d | xxd -g 0 -c 3 -b | cut -c 11-33 | sed -e 's/0/ /g' -e 's/1/#/g' | $bindir/thermo.sh
}



## foto out #######################################################
foto () {
    echo -e "$intro \n \n" | $bindir/thermo.sh 

    ## Nachricht=#F<4-Zeichen-Alphabet><Base64>

    ## Get Alphabet 
    A1="${m:2:1}"
    A2="${m:3:1}" 
    A3="${m:4:1}" 
    A4="${m:5:1}"

    ## Testpattern
    # bin=$(dd if=/dev/urandom bs=114 count=1 iflag=fullblock 2>/dev/null | xxd -b -g 0 -c 6 | cut -c 11-56)

    ## get mesage
    bin=$(echo ${m:6}| base64 -d | xxd -b -g 0 -c 6 | cut -c 11-56)

    pic=""

    ## Zeile für Zeile! 
    for line in $bin
        do
            for (( i=0; i<${#line}; i=i+2 ))
                do
                    case ${line:$i:2} in
                        00)
                            pic=$pic"$A1"
                            ;;
                        01)
                            pic=$pic"$A2"
                            ;;
                        10)
                            pic=$pic"$A3"
                            ;;
                        11)
                            pic=$pic"$A4"
                            ;;
                    esac
                done
            pic=$pic'\n'
        done
    echo -e "$pic" | $bindir/thermo.sh
}




## register nickname #######################################################
nickname () {
    if [[ ${m:3} ]]
        then
            echo -e "$from heißt jetzt ${m:3}" | $bindir/thermo.sh
            if [[ $(grep "$from" "$numfile" | cut -d ";" -f 2) ]]
                then
                sed -i "s/$nummer;$from/$nummer;${m:3}/g" $numfile
            else
                echo "$nummer;${m:3}" >> $numfile
            fi
    fi
     
}


## Print Manual #######################################################
genmanual () {
echo "Das Engel-Sms-Fax
bietet neben der
schlichten Textausgabe
auch ein paar
Darstellungs-Features!
So geht es:
Vor den SMS-TEXT 4
Zeichen setzen. Das
erste ist immer '#'.
Mit dem zweiten Zeichen
wird die Aktion gewählt: 
'A' = AsciiArt
'C' = Cowsay,
'F' = Font.
Das dritte Zeichen
wählt den 'Style' aus.
Abschließend kommt ein
Leerzeichen.
Soll Stimpy in einer
Sprechblase Oi! rufen,
würde die sms lauten:
'#CS Oi!'
Alle Möglichkeiten sind folgend dargestellt:
" | $bindir/thermo.sh

echo -e "\n\n" | $bindir/thermo.sh

## ascii art
for m in $(cut -d ';' -f 1 $bindir/art.csv) ; do  intro="#A$m" ; m="#A$m "; parser | $bindir/thermo.sh ; done

## cowsay
for m in $(cut -d ';' -f 1 $bindir/cowsay.csv) ; do intro="#C$m" ; m="#C$m Oi!" ; parser | $bindir/thermo.sh ; done 

## figlet fonts
for m in $(cut -d ';' -f 1 $bindir/fonts.csv) ; do intro="#F$m" ; m="#F$m Oi!" ; parser | $bindir/thermo.sh ; done
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
        "#H")
            genmanual
        ;;
        "#N")
            nickname
        ;;
        "#P")
            foto
        ;;
        *)
            out
        ;;
esac
}


## Start: calling parser ##############################################

parser
