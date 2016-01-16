#!/bin/bash

SMS_1_NUMBER="deinem SMS-Engel-Fax"

bindir="/home/alarm/Workspace/engelsmsfax/smsfax/bin"

source $bindir/sms.sh


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
