class Terrain{
  PVector loc;
  int size;
  
  Terrain(float mapX, float mapY,int s){
    size = s;
    loc = new PVector(mapX,mapY - size);    
  }
  
  void show(){

    triangle(loc.x + (size/2),loc.y+size/2,loc.x - (size/2),loc.y + size/2,loc.x, loc.y - size/2);

  }
  
};
