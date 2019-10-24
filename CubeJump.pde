int sizeC = 40;
int numM = 75;
ArrayList<Player> ai;
ArrayList<NeuralNetwork> brain;

NeuralNetwork fittest;
NeuralNetwork allTimeFit;
int currentHigh;
int fitIndex;

Map[] map = new Map[numM];

float gravity = sizeC/12 ;
int mChangeR = 70;

int oFit = 0;
int genCount = 1;

int mapString = 1;
int shortestMS = 3;
int terrainString = 1;


int currFrame = 0;
float accel = 1;

int pop = 100;
int randomPop = (pop*9)/10;

float br = 78;
float bg = 85;
float bb = 75;


void setup(){
  size(1000,600);
  background(br, bg, bb);
  frameRate(60);
  
  
  brain = new ArrayList<NeuralNetwork>();
  ai = new ArrayList<Player>();
  
  brain.add(new NeuralNetwork(64,40,2));
  ai.add(new Player((9*sizeC)/2  ,((2*height)/3)-sizeC,sizeC));
  
  
  for(int i = 1; i < pop; i++){
    brain.add(new NeuralNetwork(64,40,2));
    ai.add(new Player((9*sizeC)/2 ,((2*height)/3)-sizeC,sizeC));
  }
  
  map[0] = new Map(-(sizeC/2) * (numM/3),(2*height)/3,sizeC);
   
  for(int i = 1; i < numM; i++){
      map[i] = new Map(int(map[i-1].loc.x + (sizeC)),(2*height)/3,sizeC);
  }  
  
  fittest = new NeuralNetwork(64,40,2);
  allTimeFit = new NeuralNetwork(64,40,2);
}

void draw(){
  background(br, bg, bb);
    
  for(int i = 0; i < pop; i++){
    float[] inputs = {ai.get(i).loc.x/width,ai.get(i).loc.y/height,ai.get(i).vel.y,distG(i)/height,inputCheckX(1)/width,inputCheckY(1)/height, bFloat(map[checkAhead(1)].t),inputCheckX(2)/width,inputCheckY(2)/height,bFloat(map[checkAhead(2)].t),
                inputCheckX(3)/width,inputCheckY(3)/height,bFloat(map[checkAhead(3)].t),inputCheckX(4)/width,inputCheckY(4)/height,bFloat(map[checkAhead(4)].t),inputCheckX(5)/width,inputCheckY(5)/height,bFloat(map[checkAhead(5)].t),
              inputCheckX(6)/width,inputCheckY(6)/height,bFloat(map[checkAhead(6)].t),inputCheckX(7)/width,inputCheckY(7)/height,bFloat(map[checkAhead(7)].t),inputCheckX(8)/width,inputCheckY(8)/height,bFloat(map[checkAhead(8)].t),
            inputCheckX(9)/width,inputCheckY(9)/height, bFloat(map[checkAhead(9)].t),inputCheckX(10)/width,inputCheckY(10)/height,bFloat(map[checkAhead(10)].t),inputCheckX(11)/width,inputCheckY(11)/height,bFloat(map[checkAhead(11)].t),
            inputCheckX(12)/width,inputCheckY(12)/height,bFloat(map[checkAhead(12)].t),inputCheckX(13)/width,inputCheckY(13)/height,bFloat(map[checkAhead(13)].t),inputCheckX(14)/width,inputCheckY(14)/height,bFloat(map[checkAhead(14)].t),
           inputCheckX(15)/width,inputCheckY(15)/height,bFloat(map[checkAhead(15)].t),inputCheckX(16)/width,inputCheckY(16)/height,bFloat(map[checkAhead(16)].t),inputCheckX(17)/width,inputCheckY(17)/height,bFloat(map[checkAhead(17)].t)
         ,inputCheckX(18)/width,inputCheckY(18)/height,bFloat(map[checkAhead(18)].t),inputCheckX(19)/width,inputCheckY(19)/height,bFloat(map[checkAhead(19)].t),inputCheckX(20)/width,inputCheckY(20)/height,bFloat(map[checkAhead(20)].t)};
     
     if((map[checkAhead(0)].loc.y != map[checkAhead(1)].loc.y || map[checkAhead(0)].t == true) && ai.get(i).dead != true){
       brain.get(i).fit++;
     }
     
     if(ai.get(i).dead == true){
       ai.get(i).loc.y = height + (sizeC *2);
     }
                
    aiMove(inputs,brain.get(i).feedForward(inputs),i);
    checkDead(i);
    update(i);
  }
  //
    
  fittest = getFittest();
  if(allDead()){
    //println(fittest.fit + " " + allTimeFit.fit);
    //newGenRT();
    if(fittest.fit >= allTimeFit.fit){
      newGen();
      println("New From Current Best");
    }
   else{
      //newGen();
      //println("New From Current Best");
      newGenA();
      println("New From All Time Best");
    }
    
  }
  
  //println(ai.get(i).loc);
  for(int a = 0; a < numM; a++){
    map[a].show();
  }
  
  
  
  map[checkAhead(20)].r = 255;
     
  map[checkAhead(0)].r = 50;
  
  
  
  
  moveMap(accel);
  
  
  textSize(30);
  fill(255);
  textAlign(CENTER);
  text("Gen: " + genCount, width/4, 60);
   textAlign(CENTER);
  text("Alive: " + alive(), width/2, 60);
  textAlign(CENTER);
  text("Best: " + allTimeFit.fit, (3*width)/4, 60);
  textAlign(CENTER);
  //fill( ai.get(fitIndex).r, ai.get(fitIndex).g, ai.get(fitIndex).b);
  text("Current: " + fittest.fit, ai.get(fitIndex).loc.x, ai.get(fitIndex).loc.y - 50);
 
  currFrame++;  
}

float[] randomT(){
  float[] choice = {random(0,1),random(0,1),random(0,1)};
  return choice;
}

float distG(int i){
  float dist = height;
  
  dist = map[checkOn()].loc.y - ai.get(i).loc.y;

  return dist;
}

float inputCheckX(int ahead){
  
  int curr = checkOn();
  int diff = ahead + curr - (numM -1);  
  
  if(ahead + curr > numM -1){
    return map[diff].loc.x;
  }
  else{
    return map[curr + ahead].loc.x;
  }
}

float inputCheckY(int ahead){
  
  int curr = checkOn();
  int diff = ahead + curr - (numM -1);  
  
  if(ahead + curr > numM -1){
    return map[diff].loc.y;
  }
  else{
    return map[curr + ahead].loc.y;
  }
}


float bFloat(boolean x){
  float result = 0;
  
  if(x){
    result =1;
  }
  
  return result;
}

void aiMove(float[] inputs,float[] outputs, int i){
  
  
  if(outputs[1] < outputs[0]  && onGround(i) == true){
    //do nothing
  }
  else{
    ai.get(i).jump();
    //brain.get(i).fit -= 5;
  }
    
}

int mapPOS(int i){
  int yValue = (2*height)/3;
  
  //int picker = int(random(1,3));
  float chance = random(100);
 
  float curr = 0;
  float uD = random(100);
  
  if(map[i-1].loc.y == 400){
    curr = 1;
  }
  if(map[i-1].loc.y == 400){
    curr = 2;
  }
  if(map[i-1].loc.y == 580){
    curr = 3;
  }
   
  if(mapString <= (shortestMS -1)){
    chance = 0;
  }
  
  
  if(chance <= mChangeR){              
        yValue = int(map[i-1].loc.y);
        mapString++;
  }
  else{
    if(curr == 2){
      if(uD >= 50){
        yValue = int(map[i-1].loc.y + 180);
      }
      if(uD  < 50){
        yValue = int(map[i-1].loc.y - 180);
      }
    }
    if(curr == 1){
      yValue = int(map[i-1].loc.y + 180);
    }
    if(curr == 3){
      yValue = int(map[i-1].loc.y - 180);
    }
    
    mapString = 1;
   }
  return yValue;
}


boolean checkDead(int i){
  
  if(dist(ai.get(i).loc.x,ai.get(i).loc.y,map[checkOn()].spike.loc.x,map[checkOn()].spike.loc.y) < sizeC && map[checkOn()].t == true){
    ai.get(i).dead = true;
    ai.get(i).vel.y = 0;  
  }
  
  if(ai.get(i).loc.y > height + (sizeC *2)){
    ai.get(i).dead = true;
    ai.get(i).vel.y = 0;    
  }
  
  return ai.get(i).dead;
}

boolean onGround(int i){
  boolean result = false;
  
  if(ai.get(i).loc.y >= map[checkOn()].loc.y - (11*sizeC)/10 && ai.get(i).loc.y <= map[checkOn()].loc.y - (sizeC/2) && ai.get(i).loc.x <= (9*sizeC)/2 + (sizeC/2) && ai.get(i).loc.x >= (9*sizeC)/2 - (sizeC/2)){
    result = true;
  }
  else{
    result = false;
  }
  
  if(ai.get(i).vel.y > 0 && ai.get(i).loc.y > map[checkOn()].loc.y && ai.get(i).loc.y < map[checkOn()].loc.y + (3*sizeC)/2){
    result = true;
  }
  
  return result;
}

void update(int i){
  
  ai.get(i).update();
  if(onGround(i) == true){
    ai.get(i).vel.y = 0;
    ai.get(i).loc.y = map[checkOn()].loc.y - sizeC;
  }
  if(onGround(i) == false){
    if(ai.get(i).vel.y >= (sizeC)){
      ai.get(i).vel.y = (sizeC);
    }
    else{
      ai.get(i).vel.y += gravity;
    }
  }
  
  ai.get(i).show();    
  
}

int checkOn(){
  int index = 0;
  float diff = width;
  for(int a = 0; a < numM; a++){
    
    if( dist((9*sizeC)/2,0,map[a].loc.x,0) < diff ){
      diff = dist((9*sizeC)/2,0,map[a].loc.x,0);      
      index = a;
    }
  }
  
  return index;
}

int checkAhead(int i){
 
  if(checkOn() + i < numM ){
    return checkOn() + i;
  }
  else{
    return (checkOn() + i) - numM;
  }
}


float gridIt(float val){
  float grid = 0;
  
  while(val % sizeC != 0){
    val++;
  }
  grid = val;
  return grid;
}

void moveMap(float curr){
   for(int i = 0; i < numM; i++){
    if(i == 0 && map[i].loc.x < -(sizeC/2) * (numM/3) ){
       map[i].loc.y = mapPOS(numM);  
       map[i].loc.x = map[numM-1].loc.x + sizeC;       
       map[i].tChoice = random(100);
      }
     if(i != 0 && map[i].loc.x < -(sizeC/2) * (numM/3)){
       map[i].loc.y = mapPOS(i);
       map[i].loc.x = map[i-1].loc.x + sizeC;
       map[i].tChoice = random(100);
     }
   }
   
   int currT = 0;
   for(int i = 0; i < numM; i++){
     if(map[i].tChance >= map[i].tChoice && currT < 2){
       map[i].t =true;
       currT++;
     }     
     if(i == 0 && map[i].loc.y != map[numM-1].loc.y) {
       map[numM-1].t =false;
       currT = 0;
     }
     if(i != 0 && map[i].loc.y != map[i-1].loc.y) {
       map[i].t =false;
       currT = 0;
     } 
     map[i].loc.x -= ((sizeC/10)*curr);
     map[i].spike.loc.x = map[i].loc.x;
     map[i].spike.loc.y = map[i].loc.y - sizeC;
   }   
}

boolean allDead(){
  int i = 0;
  
  while(ai.get(i).dead == true){
    if(i == pop-1){
      accel = 1;
      return true;
    }
    i++;
  }
  
  
  return false;
}

NeuralNetwork getFittest(){
  NeuralNetwork f = new NeuralNetwork(64,40,2);
  
  for(int i = 0; i < pop; i++){
    if(f.fit < brain.get(i).fit){
      f = brain.get(i);
      fitIndex = i;
    }

  }
  
  if(currentHigh < f.fit){
    currentHigh = f.fit;
    allTimeFit = new NeuralNetwork(f);
    //println(f.fit + " " + allTimeFit.fit);
  }
  
  
  return f;
}

void newGenA(){
  fittest.fit = 0;
  
  for(int i = pop; i > 0; i--){
    brain.remove(i-1);
    ai.remove(i-1);
  }
  
  for(int i = 0; i < numM; i++){
    map[i].loc.y = (2*height)/3;
    map[i].tChoice = 100;
    map[i].t = false;
  }

  for(int i = 0; i < pop; i++){  
    
    if(i == 0){
      brain.add(new NeuralNetwork(64,40,2));
      brain.get(0).setTo(allTimeFit);
      ai.add(new Player((9*sizeC)/2,map[checkOn()].loc.y - sizeC,sizeC));
    }
    if(i >=1 ){
      brain.add(new NeuralNetwork(64,40,2));
      brain.get(i).setTo(brain.get(0).crossG(brain.get(i)));
      ai.add(new Player((9*sizeC)/2,map[checkOn()].loc.y - sizeC,sizeC));
    }   
    
    brain.get(i).fit = 0;
  }
  

  genCount++;
}



void newGen(){
  fittest.fit = 0;
  
  for(int i = pop; i > 0; i--){
    brain.remove(i-1);
    ai.remove(i-1);
  }
  
  for(int i = 0; i < numM; i++){
    map[i].loc.y = (2*height)/3;
    map[i].tChoice = 100;
    map[i].t = false;
  }

  for(int i = 0; i < pop; i++){  
    
    if(i == 0){
      brain.add(new NeuralNetwork(64,40,2));
      brain.get(0).setTo(fittest);
      ai.add(new Player((9*sizeC)/2,map[checkOn()].loc.y - sizeC,sizeC));
    }
    if(i >=1 ){
      brain.add(new NeuralNetwork(64,40,2));
      brain.get(i).setTo(brain.get(0).mut(brain.get(i)));
      ai.add(new Player((9*sizeC)/2,map[checkOn()].loc.y - sizeC,sizeC));
    }   
    
    brain.get(i).fit = 0;
  }
  

  genCount++;
  //fittest = brain.get(0);
}

int alive(){
  int amount = 0;

  for(int i = 0; i < pop; i++){
    if(ai.get(i).dead == false){
      amount++;
    }
  }
   
  return amount;
}
