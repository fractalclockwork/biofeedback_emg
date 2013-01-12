
PImage muscleMap;
ArrayList muscleNames;
int muscleIndex=0;
int musclePoint=0;
int activeMuscle=-1;

ArrayList Muscles;
String getActiveMuscle() {
   if (activeMuscle == -1) return "Not Selected";
  else {
    Muscle m = (Muscle) Muscles.get(activeMuscle);
    return m.name;
  } 
}

void setupMuscleMap() {
  muscleNames = new ArrayList();
  Muscles = new ArrayList();

  setupMuscleNames();
 // setupFont();
  muscleMap = loadImage("musclemap.jpeg");
  noStroke();
  background(0);
  float h, w, s;

  if (height< muscleMap.height) {
    h=height;
    s=height/muscleMap.height;
    w=muscleMap.width*s;
  } 
  else {
    h=muscleMap.height;
    s=muscleMap.height/height;
    w=width*s;
  }

  muscleMap.resize(int(w), int(h));

  setupMusclePoints();
}

void user() {
  println("select points for: " + muscleNames.get(muscleIndex));
}

void drawMuscleMap() {
  muscleFont = createFont("Free Sans", 20);
  background(0);
  fill(255,0,0);
  image(muscleMap, 0, 0);
  //ellipse(mouseX, mouseY, 5, 5);
  snapToMuscle();
  drawNotes();
}


void listMuscleNames() {
  for (int i =0; i < muscleNames.size(); i++) 
    println( muscleNames.get(i));
}

class Muscle {
  int x0, y0, x1, y1;
  String name;
  Muscle (String s, int xx0, int yy0, int xx1, int yy1) {
    x0=xx0;
    y0=yy0;
    x1=xx1;
    y1=yy1;
    name = s;
  }
}

void snapToMuscle() {
//  println(Muscles.size());
  for (int i=0; i< Muscles.size(); i++) {
  //  print("i => ");
      Muscle m = (Muscle) Muscles.get(i);
      
      if ((dist(m.x0, m.y0, mouseX, mouseY) < 3) || (dist(m.x1, m.y1, mouseX, mouseY) < 6)) {
        println("m: " + m.name);
          ellipse(m.x0,m.y0, 6,6);
          ellipse(m.x1,m.y1, 6,6);
          text(m.name, 4*width/7, 20);
      }
  }  
}

void drawNotes() {
  
}

void mapFoucedMousePressed() {
  //println( mouseX + ", " + mouseY );
    for (int i=0; i< Muscles.size(); i++) {
  //  print("i => ");
      Muscle m = (Muscle) Muscles.get(i);
      
      if ((dist(m.x0, m.y0, mouseX, mouseY) < 3) || (dist(m.x1, m.y1, mouseX, mouseY) < 6)) {
      //  println("m: " + m.name);
          //text(m.name, 4*width/7, 20);
          activeMuscle = i;
          focus = 0;
          return;
      }
      //activeMuscle=-1;
     // focus = 0;
  } 

/*
  if (musclePoint == 1) {
    println(", " + mouseX + ", " + mouseY + "));");
    musclePoint = 0;
    muscleIndex ++;
    user();
  }
  else {
    musclePoint = 1; 
    print("Muscles.add( new Muscle(\"" + muscleNames.get(muscleIndex) + "\", " + mouseX + ", " + mouseY );
  }
  */
}

/*
void setupFont() {
  muscleFont = createFont("Free Sans", 20);
  textFont(muscleFont);
}
*/

void setupMusclePoints() {
  Muscles.add( new Muscle("M. sternocieldo mastoideus", 81, 95, 81, 102));
  Muscles.add( new Muscle("M. deltoideus pars claviculars", 121, 130, 125, 136));
  Muscles.add( new Muscle("M. pectoralis major pars claviculars", 98, 122, 105, 126));
  Muscles.add( new Muscle("M. pectoralis major pars sternocostslis", 88, 145, 95, 145));
  Muscles.add( new Muscle("M. pectoralis major pars abdominials", 105, 157, 111, 153));
  Muscles.add( new Muscle("M. biceps brachii", 131, 167, 134, 177));
  Muscles.add( new Muscle("M. brachioradialis", 15, 216, 16, 223));
  Muscles.add( new Muscle("M. obliquus extemus", 110, 219, 106, 228));
  Muscles.add( new Muscle("M. rectus abdominis upper", 68, 185, 67, 191));
  Muscles.add( new Muscle("M. rectus abdominis lower", 64, 223, 64, 232));
  Muscles.add( new Muscle("M. obliguus internus abdominis", 55, 247, 61, 254));
  Muscles.add( new Muscle("Extensor group digitorm", 260, 52, 261, 60));
  Muscles.add( new Muscle("Extensor group carpi ulnaris", 274, 54, 271, 61));
  Muscles.add( new Muscle("Flexor group radial", 276, 70, 275, 75));
  Muscles.add( new Muscle("Flexor group ulnar", 277, 88, 275, 96));
  Muscles.add( new Muscle("Adductor group longus", 286, 176, 286, 183));
  Muscles.add( new Muscle("Adductor group brevis", 280, 173, 279, 178));
  Muscles.add( new Muscle("M. rectus femoris", 273, 186, 273, 194));
  Muscles.add( new Muscle("M. vastus femoris", 267, 199, 268, 206));
  Muscles.add( new Muscle("M. vastus medialis", 285, 215, 283, 223));
  Muscles.add( new Muscle("M. semitendinosus membranosus", 269, 283, 269, 290));
  Muscles.add( new Muscle("M. biceps femoris", 276, 288, 277, 294));
  Muscles.add( new Muscle("M. trapezius pars descendens", 98, 396, 103, 402));
  Muscles.add( new Muscle("M. infraspinatus", 100, 432, 105, 432));
  Muscles.add( new Muscle("M. deltoideus pars acromialis", 140, 433, 142, 439));
  Muscles.add( new Muscle("M. deltoideus pars spinalis", 121, 434, 124, 439));
  Muscles.add( new Muscle("M. trapezuis rhomboideus", 81, 438, 87, 438));
  Muscles.add( new Muscle("M. triceps brachii caput longum", 127, 467, 127, 473));
  Muscles.add( new Muscle("M. triceps brachii caput laterale", 136, 474, 138, 480));
  Muscles.add( new Muscle("M. latissimus dorsi", 104, 488, 108, 485));
  Muscles.add( new Muscle("M. erector spinae", 79, 501, 81, 545));
  Muscles.add( new Muscle("M. multifidus", 78, 565, 78, 571));
  Muscles.add( new Muscle("M. glutaeus medius", 109, 567, 113, 567));
  Muscles.add( new Muscle("M. glutaeus maximus", 91, 596, 93, 601));
  Muscles.add( new Muscle("M. tibialis anterior", 273, 411, 274, 417));
  Muscles.add( new Muscle("M. peronaeus", 272, 445, 272, 452));
  Muscles.add( new Muscle("M. gastrocnemius lateralis", 282, 563, 283, 569));
  Muscles.add( new Muscle("M. gastrocnemius medialis", 271, 566, 271, 571));
  Muscles.add( new Muscle("M. soleus", 270, 592, 271, 597));
}

void setupMuscleNames()
{
  
  muscleNames.add(new String("M. sternocieldo mastoideus"));
  muscleNames.add(new String("M. deltoideus pars claviculars"));
  muscleNames.add(new String("M. pectoralis major pars claviculars"));
  muscleNames.add(new String("M. pectoralis major pars sternocostslis"));
  muscleNames.add(new String("M. pectoralis major pars abdominials"));
  muscleNames.add(new String("M. biceps brachii"));
  muscleNames.add(new String("M. brachioradialis"));
  muscleNames.add(new String("M. obliquus extemus"));
  muscleNames.add(new String("M. rectus abdominis upper"));
  muscleNames.add(new String("M. rectus abdominis lower"));
  muscleNames.add(new String("M. obliguus internus abdominis"));

  muscleNames.add(new String("Extensor group digitorm"));
  muscleNames.add(new String("Extensor group carpi ulnaris"));
  muscleNames.add(new String("Flexor group radial"));
  muscleNames.add(new String("Flexor group ulnar"));
  muscleNames.add(new String("Adductor group longus"));
  muscleNames.add(new String("Adductor group brevis"));
  muscleNames.add(new String("M. rectus femoris"));
  muscleNames.add(new String("M. vastus femoris"));
  muscleNames.add(new String("M. vastus medialis"));
  muscleNames.add(new String("M. semitendinosus membranosus"));
  muscleNames.add(new String("M. biceps femoris"));

  muscleNames.add(new String("M. trapezius pars descendens"));
  muscleNames.add(new String("M. infraspinatus"));
  muscleNames.add(new String("M. deltoideus pars acromialis"));
  muscleNames.add(new String("M. deltoideus pars spinalis"));
  muscleNames.add(new String("M. trapezuis rhomboideus")); 
  muscleNames.add(new String("M. triceps brachii caput longum"));
  muscleNames.add(new String("M. triceps brachii caput laterale"));
  muscleNames.add(new String("M. latissimus dorsi"));
  muscleNames.add(new String("M. erector spinae"));
  muscleNames.add(new String("M. multifidus"));
  muscleNames.add(new String("M. glutaeus medius"));
  muscleNames.add(new String("M. glutaeus maximus"));

  muscleNames.add(new String("M. tibialis anterior"));
  muscleNames.add(new String("M. peronaeus"));

  muscleNames.add(new String("M. gastrocnemius lateralis"));
  muscleNames.add(new String("M. gastrocnemius medialis"));
  muscleNames.add(new String("M. soleus"));
}

