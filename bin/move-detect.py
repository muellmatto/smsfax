#!/bin/env python3

import RPi.GPIO as GPIO
import time
import signal
import os
import sys
import random


SAMPLES_PATH="/home/alarm/samples/"
TEXTE_FILE = "/home/alarm/texte.txt"

SENSOR_PIN = 4
LED_PIN = 23

## sleep time in sec
SLEEP_MIN=5
SLEEP_MAX=30
SLEEP_STEP=5


## Get list of files
WAVE_FILES=os.listdir(SAMPLES_PATH)

## Setup GPIO
GPIO.setmode(GPIO.BCM)
GPIO.setup(SENSOR_PIN, GPIO.IN)
GPIO.setup(LED_PIN, GPIO.OUT) # Gelb  

## Sigterm abfangen und LEDs wieder aus machen!!
def signal_term_handler(signal, frame):
    GPIO.remove_event_detect(SENSOR_PIN)
    GPIO.output(LEN_PIN,False) 
    GPIO.cleanup()
    sys.exit(0)

signal.signal(signal.SIGTERM, signal_term_handler)

## Sprachausgabe
def sprich(bla):
    GPIO.remove_event_detect(SENSOR_PIN)
    GPIO.output(LED_PIN, True)
    WAVE_FILE=random.choice( WAVE_FILES )
    os.system("/usr/bin/aplay " + SAMPLES_PATH + WAVE_FILE)
    time.sleep( random.randrange(SLEEP_MIN, SLEEP_MAX, SLEEP_STEP) )
    GPIO.output(LED_PIN, False)
    GPIO.add_event_detect(SENSOR_PIN, GPIO.RISING, callback=sprich, bouncetime=300)


GPIO.add_event_detect(SENSOR_PIN, GPIO.RISING, callback=sprich, bouncetime=300)	

## Loop forever!!!
try:
    while True:
        pass

except:
    print("Beende...")
    GPIO.remove_event_detect(SENSOR_PIN)
    GPIO.output(LED_PIN,False) 
    GPIO.cleanup()
