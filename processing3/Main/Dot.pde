class Dot
{
  PVector pos;
  PVector destPos;
  PVector start = new PVector(0,0,0);
  float velocity;
  float counter;
  float step;
  float ease = 0.05;
  int ww;
  int hh;
  void setup(int w, int h) {
   ww = w;
   hh = h;
   counter = random(1000);
   destPos = new PVector();
   destPos.x = random(-ww/2, ww/2);
   destPos.y = random(-hh/2, hh/2);
   destPos.z = random(-hh/2, hh/2);
   velocity = random(0.001, 0.005); 
   step = random(1000);
   
   pos = new PVector();
  }
  
  void update(){
    counter+=velocity;
    
    destPos.x = (noise(counter*0.5+step)-0.5)*ww*4;
    destPos.y = (noise(counter*0.3+step)-0.5)*hh*4;
    destPos.z = (noise(counter*0.1+step)-0.5)*hh*4;
    
    pos.x += (destPos.x-pos.x)*ease;
    pos.y += (destPos.y-pos.y)*ease;
    pos.z += (destPos.z-pos.z)*ease;
  }
  
  void draw(){
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    sphere(10);
    popMatrix();
  }
}
