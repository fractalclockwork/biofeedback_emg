/*
 *  biofeedback_host v0.1
 *  tested with Processing 2.0b5
 *  brentAthorne <at> gmail.com
 *  5 Nov 2012
 */

import processing.serial.*;    
Serial myPort;                 
PFont myFont;
PrintWriter output;  //file writer

int   xy[][];
int   s=0;
void setup() {  
  size(800, 640);

  println(Serial.list()); 
  myPort = new Serial(this, Serial.list()[0], 115200);
  myPort.bufferUntil('\n');
  setupFont();

  //data buffer
  xy= new int[width][2]; // [][0] is x ; [][1] is y
  for (int i=0; i<width; i++) {
    xy[i][0]=0;
    xy[i][1]=height/2;
  }
}

float myScale = 1.0/20000;
void draw() {
  float t=0.0001;
  background(0);

  //stroke(255);
  stroke(0, 255, 0);
  strokeWeight(1);
  fill(0, 255, 0);
  text("<SPACE> start/stop recording", 10, 30);
  text("<S> screenshot", 10, 50);
  if(recording) 
      text("RECORDING...", width - 100, 30);
  noFill();
  // delay(10); 
  if (!connected) {
    delay(1000);
    myPort.write("A");
  }

  for (int i=1; i<width; i++) {
    stroke(0, 255, 0);
    line ( t*myScale, map(xy[i-1][1], 0, 1023, 0, height), 
    (t+xy[i][0])*myScale, map(xy[i][1], 0, 1023, 0, height));
    t+=xy[i][0];

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
  String myString = myPort.readStringUntil('\n');
  myString = trim(myString);
  int nums[] = int(split(myString, ','));
  for (int i=0; i < nums.length; i++) {
    print(nums[i]);
    print(":");
  }
  if (nums.length == 2) {
    xy[s][0]=nums[0];
    xy[s][1]=nums[1];
    s++;
    if (s >=width) {
      s=0;
      if(recording) {
        for(int i=0; i<width; i++) {
          output.println( xy[i][0] + "," + xy[i][1] );
        }
      }
    }
  }
  println();
  myPort.write("A");
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

