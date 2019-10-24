class Matrix{
  int rows;
  int cols;
  
  float[][] data;
  
  Matrix(int r, int c){
    rows = r;
    cols = c;
    data = new float[rows][cols];
    
    for(int i = 0; i < rows; i++){
      for(int j = 0; j < cols; j++){
        data[i][j] = 0;
      }
    }
  }
  
  //elementwise scaler addition
  void mAdd(Matrix n){
    for(int i = 0; i < rows; i++){
      for(int j = 0; j < cols; j++){
        data[i][j] += n.data[i][j];
      }
    }
  }
  
  Matrix subtract(Matrix n){
    Matrix r = new Matrix(rows,cols);
    for(int i = 0; i < r.rows; i++){
      for(int j = 0; j < r.cols; j++){
        r.data[i][j] = n.data[i][j] - data[i][j];
      }
    }
    return r;
  }

  //addition scaler
  void mAdd(float n){
    for(int i = 0; i < rows; i++){
      for(int j = 0; j < cols; j++){
        data[i][j] += n;
      }
    }
  }
  
  //elementwise scaler multipy
  void mMult(Matrix n){
    for(int i = 0; i < rows; i++){
      for(int j = 0; j < cols; j++){
        data[i][j] *= n.data[i][j];
      }
    }
  }
  
  //multiply scaler
  void mMult(float n){
    for(int i = 0; i < rows; i++){
      for(int j = 0; j < cols; j++){
        data[i][j] *= n;
      }
    }
  }
  
   Matrix mProduct(Matrix n){
      Matrix result = new Matrix(rows,n.cols); 
      for(int i = 0; i < rows; i++){
        for(int j = 0; j < n.cols; j++){
          float sum = 0;
          for(int k = 0; k < cols; k++){
            sum += data[i][k] * n.data[k][j];
          }
          result.data[i][j] = sum;
        }
      }    
      return result;
  }
  
  Matrix transpose(){    
    Matrix result = new Matrix(cols,rows);
    for(int i = 0; i < rows; i++){
      for(int j = 0; j < cols; j++){
        result.data[j][i] = data[i][j];
      }
    }
    return result;
  }
  
  
  
  //fill with random values
  void randomize(){
    for(int i = 0; i < rows; i++){
      for(int j = 0; j < cols; j++){
        data[i][j] = random(0,1);
      }
    }
  }

};
