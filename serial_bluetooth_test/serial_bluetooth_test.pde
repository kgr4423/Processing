import processing.serial.Serial;
Serial myPort;

boolean started = false;
int serialTimer = 0;
int counter = 0;
int oldCounter = 0;

void setup() {
  size(320, 240); 
  background(0);
  myPort = new Serial(this, Serial.list()[1], 230400);  
  myPort.clear();
  println("setup finished");
  delay(2000); // wait for stable connection
}

void draw() {
  
  if (started == false) {
    started = true;  
    println("start");
    myPort.write('S');
    myPort.clear();    
    delay(10);
    return;
  }
  
  final int interval = 1;
  if (millis() - serialTimer > interval) {
    serialTimer = millis();   
    if (myPort.available() <= 0) return;

    while (myPort.available() > 0) {
      int getCounter = (int)myPort.read();
      if(oldCounter != getCounter-1 && getCounter != 0)println("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      print(getCounter);
      print("  ");
      print(counter);
      print(" : ");
      if(counter % 10 == 0)println("");
      ++counter;
      oldCounter = getCounter;
    }
    
  }
  
}

void keyPressed() {
  myPort.write('S');
}
