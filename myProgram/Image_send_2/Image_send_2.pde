import processing.serial.Serial;
import java.io.*;
Serial myPort;

PImage img;
final static int WIDTH = 320;
final static int HEIGHT = 240;
boolean started = false;
int serialTimer = 0;
int total = 0;
int x = 0;
int y = 0;

void setup() {
  size(320, 240); 
  background(0);
  img = createImage(WIDTH, HEIGHT, RGB); 
  myPort = new Serial(this, Serial.list()[1], 38400);  
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
    total = 0;      
    delay(1000);
    return;
  }

  // To get stable connection, please adjsut this interval
  final int interval = 1;
  if (millis() - serialTimer > interval) {
    serialTimer = millis();   
    if (myPort.available() <= 0) return;

    while (myPort.available() > 0) {    
      char lbyte = (char)myPort.read();
      char ubyte = (char)myPort.read();
      x = total % WIDTH;
      y = total / WIDTH;
      color c = CalculateColor(lbyte, ubyte);
      img.set(x, y, c);
      ++total;
      println(total);

      if (total >= WIDTH*HEIGHT) {
        println("end");
        myPort.write('E');
        myPort.clear();
        started = false;
        total = 0;
        image(img, 0, 0);
        break;
      }
      
      //while(myPort.available()<=0){
      //  ;
      //}
    }
  }
}

color CalculateColor(char lbyte, char ubyte){
  int value = (ubyte << 8) | (lbyte); // RGB565 format
  char r = (char)(((value & 0xf800) >> 11) << 3);
  char g = (char)(((value & 0x07E0) >> 5)  << 2);
  char b = (char)((value & 0x001f) << 3);
  
  return color(r, g, b);
}

void keyPressed() {
  myPort.write('S');
}
