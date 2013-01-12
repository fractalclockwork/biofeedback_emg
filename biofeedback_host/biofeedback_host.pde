/*
 *  biofeedback_host v0.3
 *  tested with Processing 1.5.1 
 *  brentAthorne <at> gmail.com
 *  5 Nov 2012  first release
 *  19 Dec 2012 added simple dt' waveform
 *  12 Jan 2013 added automatic serial port selection and muscle map
 */

import processing.serial.*;    

PrintWriter output;  //file writer
Serial myPort;       //serial port            
PFont myFont;        //some font
PFont muscleFont;

int   buffer[][];        //buffer pointer
int   s=0;
float samplePeriod = 5000;
float myScale = 1.0/(samplePeriod);

boolean serialConnected = false;
float gradulation = 500.0; //500ms
boolean recording = false;

int focus = 0;  //0 is button focus, 1 is map focus

void setup() {  
  size(800, 640);
  setupFont();

  //data buffer
  buffer= new int[width][2]; // create buffer; [][0] is sample , [][1] is y

  //zero buffer
  for (int i=0; i<width; i++) {
    buffer[i][0]=0;
    buffer[i][1]=height/2;
  }

  //connect serial
  if ( establishSerialConnection()) {
    println("Serial connection established.");
  } 
  else exit();
  setupMuscleMap();
}

void draw() {
  //drawMuscleMap();
  if (focus == 0) {
    textFont(myFont);
    background(0);
    drawGraph();
    drawButtons();
  }
  if (focus == 1) {
    textFont(muscleFont);
    drawMuscleMap();
  }
}

void drawButtons() {
  stroke(0, 255, 0);
  strokeWeight(1);
  fill(0, 255, 0);

  /*
  text("<SPACE> start/stop recording", 10, 30);
   text("<S> screenshot", 10, 50);
   */
  if (recording) 
    text("RECORDING...", width - 100, 30);

  //record button
  if (!recording) {
    if (dist(mouseX, mouseY, width - 190, 50)< 30)
      fill(0, 255, 0);
    else
      fill(255, 0, 0);
    rect(width - 200, 30, 10, 30);
    rect(width - 180, 30, 10, 30);
    text("Press to Record", width - 160, 50);
  } 
  else {
    if (dist(mouseX, mouseY, width - 190, 50)< 30)
      fill(0, 255, 0);
    else
      fill(255, 0, 0);
    rect(width - 200, 30, 30, 30);
    text("Press to Stop Recording", width - 160, 50);
  }

  //muscle button

  if (dist(mouseX, mouseY, 50, 45)< 30)
    fill(0, 255, 0);
  else
    fill(255, 0, 0);
  ellipse(50, 45, 30, 30);
  text("Press to Select Muscle", 80, 50);
  String s = "Muscle Group: ";
  s+= getActiveMuscle();
  text(s, 45, 80);
}

void mousePressed() {
  if (focus == 0) {
    if (dist(mouseX, mouseY, width - 190, 50)< 30) {//record button
      if (recording)
         stopRecording();
      else
        startRecording();
    }

    if (dist(mouseX, mouseY, 50, 40)< 30) { //muslce selection button
      focus = 1;
      recording = false;
    }
  }
  if (focus == 1) 
    mapFoucedMousePressed();
}

void drawGraph() {
  float t=0.0001;

  noFill();
  fill(0, 255, 0);

  String message = "Scale ";
  message += gradulation;
  message += " ms";
  text(message, width - 100, height-30);


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
    line ( t*myScale, map( (buffer[i-1][1] - buffer[i-2][1]), 0, 1023, height-50, height- height/2), 
    (t+buffer[i][0])*myScale, map( (buffer[i][1]- buffer[i-1][1]), 0, 1023, height-50, height-height/2 ));

    //update time    
    t+=buffer[i][0];

    if (s==i) {
      stroke(255, 0, 0);
      line (t*myScale, 0, t*myScale, height);
      stroke(0, 255, 0);
    }
  }
}

void serialEvent(Serial myPort) { 

  if (!serialConnected) {
    disconnectedSerialEvent(myPort);
    return;
  }

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
       if (recording) 
             output.println( nums[0] + "," + nums[1] );
/*
      if (recording) {
        for (int i=0; i<width; i++) {
            output.println( buffer[i][0] + "," + buffer[i][1] );
        }
      }
      */
    }
  }
  println();
}

void setupFont() {
  //String[] fontList = PFont.list();
  //println(fontList);
  myFont = createFont("Free Sans", 12);
  muscleFont = createFont("Free Sans", 20);
  textFont(myFont);
}


void keyPressed() {
  int k=key;
  println   (k);

  //record
  if (k == int(' ') || k == int('R') || k == int('r')) {
    if (recording)  //close file
      stopRecording();
    else
      startRecording();

    if  (k == int('M') || k == int('m'))
      focus = 1;

    if (k == 's' || k == 'S')
      saveFrame("screenShot###.jpg");  //fix name
  }
}

void startRecording() {
  
      String s= "M_" + year() + '_' + month() + '_' + day() + "__" + hour() + '_' + minute() + '_' + second() + '_';
       s+= getActiveMuscle();
      output = createWriter(s);  //fix name
      recording = true;
}

void stopRecording() {
      if (recording) {
      recording = false;
      output.flush(); // Writes the remaining data to the file
      output.close(); // Finishes the file
      }
}

