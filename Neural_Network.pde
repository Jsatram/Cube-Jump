class NeuralNetwork{
  
  int inputL;
  int hiddenL;
  int outputL;
  int fit = 0;
  
  float mutR = 15;
  float mutAmount = 5;
  float lr = .5;
  
  
  Matrix biash;
  Matrix biaso;
  Matrix weightsih; 
  Matrix weightsho;
  
  
  NeuralNetwork(int i, int h, int o){
    inputL = i;
    hiddenL = h;
    outputL = o;    
    
    weightsih = new Matrix(hiddenL,inputL);
    weightsih.randomize();
    
    weightsho = new Matrix(outputL, hiddenL);
    weightsho.randomize();
    
    biash = new Matrix(hiddenL, 1);
    biash.randomize();
    biaso = new Matrix(outputL, 1);
    biaso.randomize();
  }
  
  NeuralNetwork(NeuralNetwork x){
    inputL = x.inputL;
    hiddenL = x.hiddenL;
    outputL = x.outputL;    
    
    weightsih = x.weightsih;
    
    weightsho = x.weightsho;
    
    fit = x.fit;
    
    biash = x.biash;
    biaso = x.biaso;
  }
  
  void setTo(NeuralNetwork x){
    inputL = x.inputL;
    hiddenL = x.hiddenL;
    outputL = x.outputL;    
    
    weightsih = x.weightsih;
    
    weightsho = x.weightsho;
    
    fit = x.fit;
    
    biash = x.biash;
    biaso = x.biaso;
  }
  
  
  NeuralNetwork crossG(NeuralNetwork a){
    
    NeuralNetwork x = new NeuralNetwork(a);
    
 
    for(int i = 0; i < x.hiddenL; i++){
      for(int j = 0; j < x.inputL; j++){
        float choice = random(100);
        
        if(choice > 50){
          x.weightsih.data[i][j] = weightsih.data[i][j];
        }
        else{
          x.weightsih.data[i][j] = x.weightsih.data[i][j];
        }
        
      }
    }
    
    for(int i = 0; i < x.outputL; i++){
      for(int j = 0; j < x.hiddenL; j++){
        float choice = random(100);
        if(choice > 50){
          x.weightsho.data[i][j] = weightsho.data[i][j];
        }
        else{
          x.weightsho.data[i][j] = x.weightsho.data[i][j];
        }
      }
    }
    
    
    for(int i = 0; i < x.hiddenL; i++){
      
      float choice = random(100);
        if(choice > 50){
          x.biash.data[i][0] = biash.data[i][0];
        }
        else{
          x.biash.data[i][0] = x.biash.data[i][0];
        }
      
      
    }
    for(int i = 0; i < x.outputL; i++){
      float choice = random(100);
        if(choice > 50){
          x.biaso.data[i][0] = biaso.data[i][0];
        }
        else{
          x.biaso.data[i][0] = x.biaso.data[i][0];
        }
    }

    return x;
  }
  
  
  
  NeuralNetwork mut(NeuralNetwork x){
    
    NeuralNetwork a = x;
    float factorU = (1+(mutAmount/100));
    float factorD  =(1-(mutAmount/100));
    float choice;
    
    for(int i = 0; i < a.hiddenL; i++){
      for(int j = 0; j < a.inputL; j++){
        choice = random(0,100);
        if(choice < mutR){
          choice = random(0,100);
          if(choice > 50){
            a.weightsih.data[i][j] = weightsih.data[i][j] * factorU;
          }
          else{
            a.weightsih.data[i][j] = weightsih.data[i][j] * factorD;
          }

        }
        else{
          a.weightsih.data[i][j] = weightsih.data[i][j];
        }
      }
    }
    
    for(int i = 0; i < a.outputL; i++){
      for(int j = 0; j < a.hiddenL; j++){
        choice = random(0,100);
        if(choice < mutR){
          choice = random(0,100);
          if(choice > 50){
            a.weightsho.data[i][j] = weightsho.data[i][j] * factorU;
          }
          else{
            a.weightsho.data[i][j] = weightsho.data[i][j] * factorD;
          }
        }
        else{
          a.weightsho.data[i][j] = weightsho.data[i][j];
        }
      }
    }
    
    for(int i = 0; i < a.hiddenL; i++){
        choice = random(0,100);
        if(choice < mutR){
          choice = random(0,100);
          if(choice > 50){
            a.biash.data[i][0] = biash.data[i][0] *factorU;
          }
          else{
            a.biash.data[i][0] = biash.data[i][0] * factorD;
          }
        } 
        else{
          a.biash.data[i][0] = biash.data[i][0];
        }
    }
    
    for(int i = 0; i < a.outputL; i++){
        choice = random(0,100);
        if(choice < mutR){
          choice = random(0,100);
          if(choice > 50){
            a.biaso.data[i][0] = biaso.data[i][0] * factorU;
          }
          else{
            a.biaso.data[i][0] = biaso.data[i][0] * factorD;
          }
        }  
        else{
          a.biaso.data[i][0] = biaso.data[i][0];
        }
    }
    
    
    
    return a;
  }
  
  float[] feedForward(float[] input){
       
    Matrix inputs = new Matrix(input.length, 1);
     
    
    for(int i = 0; i < input.length; i++){
      inputs.data[i][0] = input[i];
    }
    
    Matrix hidden = weightsih.mProduct(inputs);
    
    hidden.mAdd(biash);
    
    for(int i = 0; i < hidden.rows; i++){
      for(int j = 0; j < hidden.cols; j++){
        hidden.data[i][j] = sigmoid(hidden.data[i][j]);
      }
    }
    
    Matrix output = weightsho.mProduct(hidden);
    output.mAdd(biaso);
    
    for(int i = 0; i < output.rows; i++){
      for(int j = 0; j < output.cols; j++){
        output.data[i][j] = sigmoid(output.data[i][j]);
      }
    }
       
    float[] done = new float[output.rows*output.cols];
    
    int count = 0;
    
    for(int i = 0; i < output.rows; i++){
      for(int j = 0; j < output.cols; j++){
        done[count] = output.data[i][j];
        count++;
      }
    }
    
    return done;
  }
  
  void train(float[] input,float[] answer){
     Matrix inputs = new Matrix(input.length, 1);
    for(int i = 0; i < input.length; i++){
      inputs.data[i][0] = input[i];
    }
    
    Matrix hidden = weightsih.mProduct(inputs);
    hidden.mAdd(biash);
    

    for(int i = 0; i < hidden.rows; i++){
      for(int j = 0; j < hidden.cols; j++){
        hidden.data[i][j] = sigmoid(hidden.data[i][j]);
      }
    }
    
    
    Matrix output = weightsho.mProduct(hidden);
    output.mAdd(biaso);
    
    for(int i = 0; i < output.rows; i++){
      for(int j = 0; j < output.cols; j++){
        output.data[i][j] = sigmoid(output.data[i][j]);
      }
    }
            
    Matrix answers = new Matrix(answer.length,1);
    for(int i = 0; i < answer.length; i++ ){
      answers.data[i][0] = answer[i]; 
    }
    
 
    Matrix oErrors = output.subtract(answers);
     
    Matrix hoT = weightsho.transpose();
    Matrix hErrors = hoT.mProduct(oErrors);
       
    
    Matrix gradient = output;
    for(int i = 0; i < gradient.rows; i++){
      for(int j = 0; j < gradient.cols; j++){
        gradient.data[i][j] = dsigmoid(output.data[i][j]);
      }
    }
    
    gradient.mMult(oErrors);
    gradient.mMult(lr);
    
         
    Matrix hiddenT = hidden.transpose();
    Matrix weighthoD = gradient.mProduct(hiddenT);
    
    
    weightsho.mAdd(weighthoD);
    biaso.mAdd(gradient);
    
    Matrix hgradient = hidden;
    
     for(int i = 0; i < hidden.rows; i++){
      for(int j = 0; j < hidden.cols; j++){
        
        hgradient.data[i][j] = dsigmoid(hidden.data[i][j]);
      }
    }
    
    hgradient.mMult(hErrors);
    hgradient.mMult(lr);
    
    Matrix inputsT = inputs.transpose(); 
    Matrix weightihD = hgradient.mProduct(inputsT);
    weightsih.mAdd(weightihD);
  
    biash.mAdd(hgradient);        
  }
    
   float sigmoid(float x){

     
     x = exp(x)/(exp(x)+1);
     
  
    return x;
    
    
  }
  
  float dsigmoid(float y){
    return y * (1-y);
  }
  
};
