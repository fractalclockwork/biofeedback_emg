/*
 *  biofeedback_client v0.2
 *  tested with Arduino 1.0.1
 *  brentAthorne <at> gmail.com
 *  5 Nov 2012  first release
 *  19 Dec 2012 double smapling
 *  12 Jan 2013 added serial port hankshake
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

boolean serialConnected = false;
unsigned long time=0;
unsigned long previous_time=0;
int samplePeriod = 5; //milliseconds

void setup()
{
  Serial.begin(115200);
  while(!serialConnected) 
    establishContact();  // send a byte to establish contact until receiver responds 
    Serial.println("Client response.");
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
  delay(samplePeriod-1);
  s0 = analogRead(0);
  dt0 = getDeltaTime();

  delay(samplePeriod);
  s1 = analogRead(0);
  dt1 = getDeltaTime();

  Serial.print(dt0);  //in useconds
  Serial.print(",");
  Serial.println(s0); 

  Serial.print(dt1);  //in useconds
  Serial.print(",");
  Serial.println(s1); 

}

unsigned long getDeltaTime() {
  unsigned long dt = 0;
  //compute delta time
  time = micros();
  if (time >= previous_time) {
    dt = time - previous_time;
  }
  else {
    dt = time + (ULONG_MAX - previous_time);  
  }

  previous_time= time;
  return dt;
}

void establishContact() {
  delay(250);
  while (!serialConnected) {
    while (Serial.available() <= 0) {
      delay(250);
    }

    Serial.println("biofeedback v1!");
    delay(250);

    //test for alive query
    char buffer[81];
    byte len = Serial.readBytesUntil( '?', buffer, 80);
    if (len > 0) buffer[len] = '\0'; //null terminate

    String s = buffer;
    if ( s.startsWith("biofeedback v1") ){
      Serial.println("biofeedback v1!");
      serialConnected = true;
      getDeltaTime();
    } 
    else {
      Serial.println("biofeedback v1 connection failed");
    }
  }
}







