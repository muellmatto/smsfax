#!/bin/bash

/usr/bin/sleep 30

/usr/bin/gammu getdatetime && /usr/bin/gammu getdatetime | /home/matto/Workspace/engelsmsfax/smsfax/bin/thermo.sh || echo "Das Modem deines Engel-SMS-Fax funktioniert nicht richtig :(" | /home/matto/Workspace/engelsmsfax/smsfax/bin/thermo.sh

/usr/bin/sleep 5

/usr/bin/gammu-smsd --pid=/var/run/gammu-smsd.pid --daemon

