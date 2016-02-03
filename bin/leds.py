#!/usr/bin/env python3

import signal
import sys
import time
import RPi.GPIO as GPIO
import random
GPIO.setmode(GPIO.BCM)  # BCM Pin Nummern 
GPIO.setup(6, GPIO.OUT) # Rot  
GPIO.setup(13, GPIO.OUT) # Rot  
# GPIO.setup(22, GPIO.OUT) # Grün


## Sigterm abfangen und LEDs wieder aus machen!!
def signal_term_handler(signal, frame):
    auge1.stop() 
    auge2.stop()
    # GPIO.output(22,False) 
    GPIO.cleanup()
    sys.exit(0)

signal.signal(signal.SIGTERM, signal_term_handler)



## Builtin-PWN-Objekte: PIN,Frequenz 
auge1=GPIO.PWM(6,100)  
auge2=GPIO.PWM(13,100) 

## Starte mit Helligkeit 0
auge1.start(0) 
auge2.start(0)

pause_time = 0.02

## 
try:  
    while True:  
        for i in range(0,101):    # Stackoverflow: 101 because it stops when it finishes 100  
            auge1.ChangeDutyCycle(i)  
            auge2.ChangeDutyCycle(i)  
            ## Schlimmer Workaround für die Kopf-led
            # if i % 10 == 0:
            #    GPIO.output(22, bool( random.getrandbits(1) ) ) 
            time.sleep(pause_time)  
        for i in range(100,-1,-1):      # Stackoverflow: from 100 to zero in steps of -1  
            auge1.ChangeDutyCycle(i)  
            auge2.ChangeDutyCycle(i)  
            # if i % 10 == 0:
            #     GPIO.output(22, bool( random.getrandbits(1) ) ) 
            time.sleep(pause_time)  

## Alles zurücksetzen wenn was schief geht!
except:
    auge1.stop() 
    auge2.stop()
    # GPIO.output(22,False) 
    GPIO.cleanup()
    sys.exit(0)


