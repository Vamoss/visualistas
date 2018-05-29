int port = 12007;
int totalDots = 300;
int totalParticles = 10000;

int outputWidth = 832;
int outputHeight = 290;

  
Dot[] dots;
PVector[] particles;

float prevRotateAngle;

PVector vel = new PVector(0,0,0);
PVector dest = new PVector(0,0,0);
PVector pos = new PVector(0,0,0);
float curX = 0;
float curY = 0;
float curZ = 0;
  
import oscP5.*;
import netP5.*;  
OscP5 oscP5;
NetAddress myRemoteLocation;

void setup() {
  //size(832, 290, P3D); 
  fullScreen(P3D, 2);

  surface.setResizable(true);
  background(0);  
  frameRate(60);
  sphereDetail(3);  
  dots = new Dot[totalDots];
  for(int i=0; i<totalDots; i++){
    dots[i]= new Dot();
    dots[i].setup(outputWidth, outputHeight);
  }
  particles = new PVector[totalParticles];
  for(int i=0; i<totalParticles; i++){
    particles[i] = new PVector();
    particles[i].x = random(-800, 800);
    particles[i].y = random(-800, 800);
    particles[i].z = random(-500, 500);
  }
  
  ortho(-outputWidth / 2, outputWidth / 2, -outputHeight / 2, outputHeight / 2, 0, 1000);
  
  oscP5 = new OscP5(this,port);
  myRemoteLocation = new NetAddress("127.0.0.1",port);
} 


void oscEvent(OscMessage theOscMessage) {
  print("### received an osc message.");
  String message = theOscMessage.addrPattern();
  String[] coords = message.split(":");
  if(coords.length==3){
    vel.x = int(coords[0]);
    dest.x += vel.x;
    float max = 1000;
    if(dest.x > max) dest.x = max;
    if(dest.x < -max) dest.x = -max;
    
    vel.y = int(coords[1])/10;
    dest.y += int(vel.y);
    max = 800;
    if(dest.y > max) dest.y = max;
    if(dest.y < -max) dest.y = -max;
    
    vel.z = int(coords[2])/10;
    dest.z += int(vel.z);
    max = 600;
    if(dest.z > max) dest.z = max;
    if(dest.z < -max) dest.z = -max;
  }
  
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
}

void draw() {
  //ortho(-width / 2, width / 2, -height / 2, height / 2, 0, 1000);
  //camera(width/2, height/2, 100, width/2, height/2, 1, 0, 1, 0);
  //scale(2, 2, 2);
  fill(0, 60);
  rect(0, 0, width, height);
  translate(outputWidth/2, outputHeight/2);
  
  float tempDestX = dest.x;
  float tempDestY = dest.y;
  float tempDestZ = dest.z;
  
  float max = 1000;
  if(tempDestX > max) tempDestX = max;
  if(tempDestX < -max) tempDestX = -max;
  
  dest.y += vel.y;
  max = 800;
  if(tempDestY > max) tempDestY = max;
  if(tempDestY < -max) tempDestY = -max;
  
  dest.z += vel.z;
  max = 600;
  if(tempDestZ > max) tempDestZ = max;
  if(tempDestZ < -max) tempDestZ = -max;
  
  PVector prevPos = new PVector(pos.x, pos.y, pos.z);
  pos.x += (tempDestX-pos.x) * 0.09;
  pos.y += (tempDestY-pos.y) * 0.09;
  pos.z += (tempDestZ-pos.z) * 0.09;
  
  dest.x *= 0.95;
  dest.y *= 0.95;
  dest.z *= 0.95;
  
  vel.x = pos.x - prevPos.x;
  vel.y = pos.y - prevPos.y;
  vel.z = pos.z - prevPos.z;
  
  pushMatrix();
    translate(pos.x, pos.y, pos.z);
    
    
    stroke(255);
    for(int i=0; i<dots.length; i++){
      dots[i].update();
      dots[i].draw();
    }
  popMatrix();
  float def = 1.;
  for(int i=0; i<particles.length; i++){
    particles[i].x += vel.x/def;
    particles[i].y += vel.y/def;
    particles[i].z += vel.z/def;
    pushMatrix();
    translate(particles[i].x, particles[i].y, particles[i].z);
    rect(0, 0, 3, 3);
    popMatrix();
  }

}

void keyPressed(){
  if(key=='z'){
    vel.x = random(-1000, 1000);
    vel.y = random(-1000, 1000);
    vel.z = random(-1000, 1000);   
    dest.x += vel.x;
    dest.y += vel.y;
    dest.z += vel.z;
  }else if(key=='x'){
    dest.x = 0;
    dest.y = 0;
    dest.z = 0;
  }else{
    for(int i=0; i<totalDots; i++){
      dots[i].pos.x = 0;
      dots[i].pos.y = 0;
      dots[i].pos.z = 0;
    }
  }
}
