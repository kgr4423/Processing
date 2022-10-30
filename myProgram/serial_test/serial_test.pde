import processing.serial.*;
Serial myPort;
PFont gothic;

void setup() {
  size(500, 500); 
  background(0);
  gothic = createFont("Monospaced", 24);  
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[1], 230400);
}

int cnt = 0;
void draw() {
  //println("in draw");
  if (myPort.available() > 0) { 
    println("in if");
    
    String message = myPort.readString();
    //message = trim(message) + ":" +cnt;
    println(message);
    textSize(24); 
    text(message, 50, 50+cnt*30);
    
    //String ret = "Hi!" + cnt +  "\r\n";
    //myPort.write(ret);
    ++cnt;
  }
  
  if(keyPressed){
    switch(key){
      case '1': 
        String ret = "Hi!";
        myPort.write(ret);
        break;
    }
  }
}
