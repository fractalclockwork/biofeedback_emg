/*
 *  biofeedback_client v0.2
 *  tested with Arduino 1.0.1
 *  brentAthorne <at> gmail.com
 *  5 Nov 2012  first release
 *  19 Dec 2012 
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




unsigned long time=0;
unsigned long previous_time=0;

void setup()
{
  Serial.begin(115200);
  establishContact();  // send a byte to establish contact until receiver responds 
}

void loop()
{
  takeSample();
}

void takeSample() {
  int s0;    //initial sample
  int s1;    //second sample

  unsigned long dt0;
  unsigned long dt1;
  //this is to keep from overflowing the host's buffer
  if (Serial.available() <= 0) {
    delay(10);
    return;
  }

  Serial.read(); //ignore actual input

  //take sample every 10ms
  delay(10);
  s0 = analogRead(0);
  dt0 = getDeltaTime();
  
  delay(10);
  s1 = analogRead(0);
  dt1 = getDeltaTime();

  Serial.print(dt0);  //in milliseconds
  Serial.print(",");
  Serial.println(s0); 

  Serial.print(dt1);  //in milliseconds
  Serial.print(",");
  Serial.println(s1); 

}

unsigned long getDeltaTime() {
  unsigned long dt = 0;
  //compute delta time
  time = micros();
  if (time >= previous_time) {
    dt = time- previous_time;
  }
  else {
    dt = time + (ULONG_MAX - previous_time);  
  }
  previous_time= time;
  return dt;
}

void establishContact() {
  getDeltaTime();  //reset count
  while (Serial.available() <= 0) {
    Serial.print(0,DEC);
    Serial.print(",");
    Serial.println(0);   // send an initial string
    delay(1000);
  }
}






