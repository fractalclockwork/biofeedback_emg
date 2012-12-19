/*
 *  biofeedback_host v0.2
 *  tested with Processing 2.0b5
 *  brentAthorne <at> gmail.com
 *  5 Nov 2012  first release
 *  19 Dec 2012 added simple dt' waveform
 */

import processing.serial.*;    

PrintWriter output;  //file writer
Serial myPort;       //serial port            
PFont myFont;        //some font

int   buffer[][];        //buffer pointer
int   s=0;
float myScale = 1.0/11000;

void setup() {  
  size(800, 640);
  println(Serial.list()); 
  myPort = new Serial(this, Serial.list()[0], 115200);
  myPort.bufferUntil('\n');
  setupFont();

  delay(100);
  myPort.write("A");
  //data buffer
  buffer= new int[width][2]; // create buffer; [][0] is sample , [][1] is y

  //zero buffer
  for (int i=0; i<width; i++) {
    buffer[i][0]=0;
    buffer[i][1]=height/2;
  }
}


float gradulation = 500.0; //500ms
void draw() {
  float t=0.0001;
  background(0);

  //stroke(255);
  stroke(0, 255, 0);
  strokeWeight(1);
  fill(0, 255, 0);
  text("<SPACE> start/stop recording", 10, 30);
  text("<S> screenshot", 10, 50);
  if (recording) 
    text("RECORDING...", width - 100, 30);
  noFill();
  
  String message = "Scale ";
  message += gradulation;
  message += " ms";
  text(message, width - 100, height-30);

  //nonconnected
  if (!connected) {
    //lost connection
    //myPort.write("A");
    //delay(10000);

    //establishConnection();
  }
  //screen width/scale_in_microseconds = microsecond per screen
  int ms = int(gradulation*width*myScale);
  
  stroke(0, 55, 0);
  for (int i = 0; i< width; i+=ms)
     line(i, 0, i, height); 
    

  for (int i=2; i<width; i++) {
    //display v/dt
    stroke(0, 255, 0);
    line ( t*myScale, map(buffer[i-1][1], 0, 1023, height, 0), 
    (t+buffer[i][0])*myScale, map(buffer[i][1], 0, 1023, height, 0 ));

    //display v/dt'
    stroke(255, 255, 0);
    line ( t*myScale,  map( (buffer[i-1][1] - buffer[i-2][1]), 0, 1023, height-50, height- height/2), 
    (t+buffer[i][0])*myScale, map( (buffer[i][1]- buffer[i-1][1]) , 0, 1023, height-50, height-height/2 ));

    //update time    
    t+=buffer[i][0];

    if (s==i) {
      stroke(255, 0, 0);
      line (t*myScale, 0, t*myScale, height);
      stroke(0, 255, 0);
    }
  }
}

boolean connected = false;
void serialEvent(Serial myPort) { 
  connected = true;
  String myString;
  myPort.write("A");
  myString = myPort.readStringUntil('\n');

  myString = trim(myString);
  int nums[] = int(split(myString, ','));
  for (int i=0; i < nums.length; i++) {
    print(nums[i]);
    print(":");
  }
  if (nums.length == 2) {
    buffer[s][0]=nums[0];
    buffer[s][1]=nums[1];
    s++;
    if (s >=width) {
      s=0;
      if (recording) {
        for (int i=0; i<width; i++) {
          output.println( buffer[i][0] + "," + buffer[i][1] );
        }
      }
    }
  }
  println();
}

void setupFont() {
  //String[] fontList = PFont.list();
  //println(fontList);
  myFont = createFont("Free Sans", 12);
  textFont(myFont);
  //  text("Hello", 10, 50);
}

boolean recording = false;
void keyPressed() {
  int k=key;
  println   (k);
  if (k == int(' ')) {
    println("got space");
    if (recording) {  //close file
      recording = false;
      output.flush(); // Writes the remaining data to the file
      output.close(); // Finishes the file
    }
    else {
      //open file
      output = createWriter("dataOut.txt");
      recording = true;
    }
  }
  if (k == 's' || k == 'S')
    saveFrame("screenShot###.jpg");
}

