import processing.serial.Serial;
import java.io.*;
Serial myPort;

PImage img;
final static int WIDTH = 320;
final static int HEIGHT = 239;
boolean started = false;
int serialTimer = 0;
int serialTimer2 = 0;
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
  
  while((char)myPort.read() != 'h' && !started){
    myPort.clear();
    println("press 's' ");
    total = 0; 
    delay(1000);
    return;
  }
  
  println("receiving image");
  started = true;
  delay(100);

  // To get stable connection, please adjsut this interval
  int interval = 100;
  if (millis() - serialTimer > interval) {
    serialTimer = millis();
    if (myPort.available() <= 0) return;

    while (myPort.available() > 0) {
      x = total % WIDTH;
      y = total / WIDTH;    
      delay(1);
      char lbyte = (char)myPort.read();
      char ubyte = (char)myPort.read();
      int value = (ubyte << 8) | (lbyte); // RGB565 format
      
      //int interval2 = 1;
      //serialTimer2 = millis();
      //while(millis() - serialTimer2 < interval2){
      //   ;
      //}
      char r = (char)(((value & 0xf800) >> 11) << 3);
      char g = (char)(((value & 0x07E0) >> 5)  << 2);
      char b = (char)((value & 0x001f) << 3);
      color c = color(r, g, b);
      
      
      img.set(x, y, c);

      ++total;
      println(total);

      if (total >= WIDTH*HEIGHT) {
        println("end receiving image");
        myPort.write('e');
        myPort.clear();
        started = false;
        total = 0;
        image(img, 0, 0);
        break;
      }
    }

  }

}


void keyPressed() {
  if(key == 's')myPort.write('s');
}
