class Player{
  PVector loc;
  PVector vel;
  int size;
  
  
  boolean dead = false;
  
  float r;
  float g;
  float b;
  float a = 75;
  
  Player(float xValue, float yValue,int sValue){
    loc = new PVector(xValue,yValue);  
    vel = new PVector(0,0);
    size = sValue;
    r = random(0,255);
    g = random(0,255);
    b = random(0,255);
  }
  
  void jump(){
    if(vel.y == 0){
      vel.y = - size;    
    }
    else{
      vel.y = vel.y;
    }
  }
  
  void fall(float gravity){
    if(vel.y != 0){
      vel.y += gravity * 3;  
    }
    else{
      vel.y = vel.y;
    }
  }
    
  void update(){
    loc.add(vel); 
    
  }
  void show(){
    strokeWeight(5);
    stroke(0,0,0,a);
    rectMode(CENTER);
    fill(r,g,b,a);
    rect(loc.x,loc.y,size,size);  
  }
  

  
  
};
