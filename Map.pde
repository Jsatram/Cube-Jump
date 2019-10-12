class Map{
  Terrain spike;
  PVector loc;
  int size;
  
  float tChance = 10;
  float tChoice = 100;
  boolean t = false;
  
  float r = 50;
  float g = 50;
  float b = 50;
  
  Map(int x, int y, int sValue){
    loc = new PVector(x,y);
    size = sValue;

    spike = new Terrain(loc.x,loc.y, size);
  }
  
  void show(){
    rectMode(CENTER);
    strokeWeight(5);
    stroke(0);
    fill(r,g,b);
    rect(loc.x,loc.y,size,size);  
    
    if(t == true){
      spike.show();
    }
    
  }
  
  
  
};
