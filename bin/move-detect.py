#!/bin/env python3

import RPi.GPIO as GPIO
import time
import signal
import os
import sys
import random
import threading

## Pfad zu den Soundsamples
SAMPLES_PATH="/home/alarm/samples/"

## Wartezeit bis der Bewegungsmelder wieder aktiviert wird (in sec)
SLEEP_MIN=5
SLEEP_MAX=30
SLEEP_STEP=5

## GPIO - PINs
SENSOR_PIN = 4
LED_PIN_A = 17
LED_PIN_B = 27

## Setup GPIO
GPIO.setmode(GPIO.BCM)
GPIO.setup(SENSOR_PIN, GPIO.IN)
GPIO.setup(LED_PIN_A, GPIO.OUT)
GPIO.setup(LED_PIN_B, GPIO.OUT)  

## Builtin-PWN-Objekte: PIN,Frequenz 
auge1=GPIO.PWM(LEN_PIN_A,100)  
auge2=GPIO.PWM(LED_PIN_B,100) 

## Sigterm-Funktion - Alles wieder zurücksetzen
def signal_term_handler(signal, frame):
    GPIO.remove_event_detect(SENSOR_PIN)
    auge1.stop()
    auge2.stop() 
    GPIO.cleanup()
    sys.exit(0)

## Sigterm abfangen
signal.signal(signal.SIGTERM, signal_term_handler)

## PWM Funktion
def blink():
    ## Event entfernen, damit nicht mehrere Nachrichten Zeitgleich abgespielt werden
    GPIO.remove_event_detect(SENSOR_PIN)
    ## Soundausgabe als Thread
    ton = threading.Thread(target=sprich)
    ton.start()
    ## "Änderungsgeschwindigkeit" der Helligkeit
    pause_time = 0.02
    ## Starte mit Helligkeit 0
    auge1.start(0)
    auge2.start(0)
    ## pwm loop
    while ton.is_alive():
        # Heller werden  
        for i in range(0,101,10): 
            auge1.ChangeDutyCycle(i)  
            auge2.ChangeDutyCycle(i)  
            time.sleep(pause_time)
        # Dunkler werden  
        for i in range(100,-1,-10): 
            auge1.ChangeDutyCycle(i)  
            auge2.ChangeDutyCycle(i) 
            time.sleep(pause_time)
    # LEDs ausschalten
    auge1.stop()
    auge2.stop() 
    ## Warte zufällig lange bis es wieder losgehen kann
    time.sleep( random.randrange(SLEEP_MIN, SLEEP_MAX, SLEEP_STEP) )
    GPIO.add_event_detect(SENSOR_PIN, GPIO.RISING, callback=sprich, bouncetime=300)



## Sprachausgabe
def sprich(bla):
    ## Zufällige Wave-Datei abspielen
    WAVE_FILE=random.choice( WAVE_FILES )
    os.system("/usr/bin/aplay " + SAMPLES_PATH + WAVE_FILE)

## Event für den Bewegungsmelder
GPIO.add_event_detect(SENSOR_PIN, GPIO.RISING, callback=blink, bouncetime=300)	



## Loop forever!!!
try:
    while True:
        pass

except:
    print("Beende...")
    GPIO.remove_event_detect(SENSOR_PIN)
    auge1.stop()
    auge2.stop() 
    GPIO.cleanup()




