#!/bin/env python3

import RPi.GPIO as GPIO
import time
import signal
import os
import sys
import random
import threading

SAMPLES_PATH="/home/alarm/samples/"
TEXTE_FILE = "/home/alarm/texte.txt"

SENSOR_PIN = 4
LED_PIN_A = 17
LED_PIN_B = 27

## sleep time in sec
SLEEP_MIN=5
SLEEP_MAX=30
SLEEP_STEP=5


## Get list of files
WAVE_FILES=os.listdir(SAMPLES_PATH)

## Setup GPIO
GPIO.setmode(GPIO.BCM)
GPIO.setup(SENSOR_PIN, GPIO.IN)
GPIO.setup(LED_PIN_A, GPIO.OUT) # Rot
GPIO.setup(LED_PIN_B, GPIO.OUT) # Rot  


## Builtin-PWN-Objekte: PIN,Frequenz 
auge1=GPIO.PWM(LEN_PIN_A,100)  
auge2=GPIO.PWM(LED_PIN_B,100) 

## Starte mit Helligkeit 0
auge1.start(0) 
auge2.start(0)

pause_time = 0.01


## PWM Funktion
def blink():
    while LEUCHTE==1:  
        for i in range(0,101): 
            auge1.ChangeDutyCycle(i)  
            auge2.ChangeDutyCycle(i)  
            time.sleep(pause_time)  
        for i in range(100,-1,-1): 
            auge1.ChangeDutyCycle(i)  
            auge2.ChangeDutyCycle(i) 
            time.sleep(pause_time)  

## Sigterm abfangen und LEDs wieder aus machen!!
def signal_term_handler(signal, frame):
    GPIO.remove_event_detect(SENSOR_PIN)
    auge1.stop()
    auge2.stop() 
    GPIO.cleanup()
    sys.exit(0)

signal.signal(signal.SIGTERM, signal_term_handler)

## Sprachausgabe
def sprich(bla):
    GPIO.remove_event_detect(SENSOR_PIN)
    ## Thread
    LEUCHTE=1
    augen=threading.Thread(target=blink)
    augen.start()
    WAVE_FILE=random.choice( WAVE_FILES )
    os.system("/usr/bin/aplay " + SAMPLES_PATH + WAVE_FILE)
    LEUCHTE=0
    time.sleep( random.randrange(SLEEP_MIN, SLEEP_MAX, SLEEP_STEP) )
    GPIO.add_event_detect(SENSOR_PIN, GPIO.RISING, callback=sprich, bouncetime=300)


GPIO.add_event_detect(SENSOR_PIN, GPIO.RISING, callback=sprich, bouncetime=300)	



## Loop forever!!!
try:
    while True:
        pass

except:
    print("Beende...")
    GPIO.remove_event_detect(SENSOR_PIN)
    # GPIO.output(LED_PIN,False) 
    # GPIO.output(LED_PIN_A,False) 
    # GPIO.output(LED_PIN_B,False)
    auge1.stop()
    auge2.stop() 
    GPIO.cleanup()




