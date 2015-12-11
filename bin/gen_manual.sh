#!/bin/bash

SMS_1_NUMBER="deinem SMS-Engel-Fax"
# m1=$SMS_1_TEXT

source sms.sh


echo "Das Engelsmsfax bietet neben der schlichten Textausgabe auch ein paar Darstellungs-Features! So geht es:
Vor den SMS-TEXT 4 Zeichen setzen. Das erste ist immer '#'.
Mit dem zweiten Zeichen wird die die Aktion gewählt: 
'A' = AsciiArt
'C' = Cowsay,
'F' = Font.
Das dritte Zeichen wählt den 'Style' aus. Abschließend kommt ein Leerzeichen.

Soll Stimpy in einer Sprechblase 'Oi!' rufen, würde die sms lauten: 
'#CS Oi!'

Alle Möglichkeiten sind folgend dargestellt:
" | /home/matto/bin/thermo.sh

echo -e "\n\n" | /home/matto/bin/thermo.sh

# for m in "#AB " "#CC " "#CR " "#CS " "#CB " "#FC " "#FS " "#FI " "#F3 " ; do intro="$m" ; m="$m Oi!" ; parser | /home/matto/bin/thermo.sh ; done 

for m in "#AB " ; do intro="$m" ; m="$m Oi!" ; parser | /home/matto/bin/thermo.sh ; done 

for m in "#CB " "#Cb " "#CC " "#CE " "#CH " "#CK " "#CL " "#CM " "#CR " "#CS " "#Cs " "#CT " "#CV "  ; do intro="$m" ; m="$m Oi!" ; parser | /home/matto/bin/thermo.sh ; done 

for m in "#FC " "#FS " "#FI " "#F3 " ; do intro="$m" ; m="$m Oi!" ; parser | /home/matto/bin/thermo.sh ; done 
