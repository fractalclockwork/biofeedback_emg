// automatically establish serial port

//do a context change to allow connection
boolean isSerialConnected() {
  if (serialConnected) return true;
  return false;
}

boolean establishSerialConnection() {
  //cycle through serial ports testing each one
  String ports[] = Serial.list(); 
  println("Found: " + ports.length + " ports."); 
  println(ports);

  for (int i=0; i < ports.length; i++) {
    println("Testing port: " + ports[i]);
    myPort = new Serial(this, ports[i], 115200);
    myPort.bufferUntil('\n');
    myPort.clear();

    myDelay(2000);
    serialSend("biofeedback v1?");

    for (int j =0; j< 3; j++) { //retry 3 times
      myDelay(1000);
      if (isSerialConnected()) {//this is a bit dodgy
        return true;
      }
    }
    myPort.stop();
  }
  println("Failed to establish serial connection.");
  return false;
}

void serialSend(String s) {
  println("serialSend: " + s);
  for (int i=0; i< s.length(); i++)
    myPort.write(s.charAt(i));
}


void disconnectedSerialEvent(Serial myPort) {
  String s;
  s = myPort.readStringUntil('\n');
  if (s != null) {
    println("Got: " + s);
    if ( s.startsWith("biofeedback v1") )
      serialConnected = true;
      myPort.bufferUntil('\n');
  }
}

void myDelay(int m) {  //delay() is broken in 1.5.1 release
  int t0 = millis();
  int tn = t0 + m;

  while (tn-millis () > 0) {
    delay(1); //use it if it works
  }
}

