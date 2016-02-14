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

## get list of wave files
WAVE_FILES = os.listdir(SAMPLES_PATH)

## 
START_TIME = time.time()
#MAX_TIME = 60
MAX_TIME = 60*60*3

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
auge1=GPIO.PWM(LED_PIN_A,100)  
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



## Sprachausgabe
def sprich():
    ## Zufällige Wave-Datei abspielen
    WAVE_FILE=random.choice( WAVE_FILES )
    os.system("/usr/bin/aplay " + SAMPLES_PATH + WAVE_FILE)



def runtime():
    """Gibt die Zeit in Seknden zurück, die das
    Script bereits läuft."""
    return time.time() - START_TIME

def coinToss(WKEIT):
    """Führe ein Zufallsexperiment mit gegebener
    Wahrscheinlichkeit aus. Bei Erfolg wird 1, 
    sonst 0 zurückgegeben."""
    return random.random() < WKEIT;

def wahrscheinlichkeit(Zeit):
    """Berechnet eine Wahrscheinlichkeit aus gegebener Zeit"""
    # Nach Zeit TIME soll spätestens ein neues Ereignis kommen!
    WKEIT = Zeit/MAX_TIME
    return WKEIT

def maybespeak(bla):
    """Versuch zu sprechen!"""
    if coinToss( wahrscheinlichkeit(runtime() ) ):
        ## Event entfernen, damit nicht mehrere Nachrichten Zeitgleich abgespielt werden
        GPIO.remove_event_detect(SENSOR_PIN)
        blink()
        START_TIME = time.time()
        GPIO.add_event_detect(SENSOR_PIN, GPIO.RISING, callback=blink, bouncetime=1000)

## Event für den Bewegungsmelder
GPIO.add_event_detect(SENSOR_PIN, GPIO.RISING, callback=maybespeak, bouncetime=1000)	

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

