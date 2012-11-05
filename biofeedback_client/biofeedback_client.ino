/*
 *  biofeedback_client v0.1
 *  tested with Arduino 1.0.1
 *  brentAthorne <at> gmail.com
 *  5 Nov 2012
 */

/* 
 Wiring:
 -attached analog signal to A0
 -attach EMG to muscle
 RED to mid
 WHT to end 
 BLK to ref
 
 */

#include <limits.h>

int a0 = 0;    // first analog sensor
int inByte = 0;         // incoming serial byte

unsigned long delta_time = 0;
unsigned long time=0;
unsigned long previous_time=0;

void setup()
{
  Serial.begin(115200);
  establishContact();  // send a byte to establish contact until receiver responds 

}

void loop()
{
  // if we get a valid byte, read analog ins:
  if (Serial.available() > 0) {
    inByte = Serial.read(); //ignore actual input
    a0 = analogRead(0);
    time = micros();
    if (time >= previous_time) {
      delta_time =time- previous_time;
    }
    else {
      delta_time = time + (ULONG_MAX - previous_time);  
    }
    previous_time= time;

    Serial.print(delta_time);  //in milliseconds
    Serial.print(",");
    Serial.println(a0); 
  }
}

void establishContact() {
  while (Serial.available() < 0) {
    delta_time = 0;
    previous_time = micros();
    Serial.print(delta_time);
    Serial.print(",");
    Serial.println(0);   // send an initial string
    delay(300);
  }
}




