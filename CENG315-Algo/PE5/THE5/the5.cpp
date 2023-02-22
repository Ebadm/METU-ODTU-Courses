#include "the5.h"
// do not add extra libraries here

/*
W: the width of the field
L: the length of the field
partitions: 2D Boolean array for partitions, if a partition of w x l exists then partitions[x][y] is true.
numberOfCalls/numberOfIterations: method specific control parameter
*/

int recursiveMethod(int W, int L, bool** partitions, int* numberOfCalls){

  *numberOfCalls +=1;
  int t1,t2;
  int WastedArea = W * L;

  if (partitions[W][L] == 1){
    WastedArea = 0;
  } 

  if (WastedArea != 0) {
  for(int i = 1; i <= W/2 ; i++){
    WastedArea = std::min( WastedArea ,
         recursiveMethod(W-i, L, partitions,numberOfCalls) + recursiveMethod(i, L, partitions,numberOfCalls));
  }
  for(int j = 1; j <= L/2 ; j++){
    WastedArea = std::min( WastedArea ,
        recursiveMethod(W, L-j, partitions,numberOfCalls) + recursiveMethod(W, j, partitions,numberOfCalls));
    }  
  }


  return WastedArea;
}


int mem[605][605];


void mem_initialiser(int W, int L){
  
  for(int i = 1; i <= W; i++){
    for(int j = 1; j <= L; j++){
      mem[i][j] = -1;
    }
  } 
}

int memoizationMethod(int W, int L, bool** partitions, int* numberOfCalls){

  int WastedArea = W * L;
  int t11,t12,t21,t22,t1f,t2f;

  if ( *numberOfCalls == 0){
    mem_initialiser(W,L);
    *numberOfCalls +=1;
  }
  
  *numberOfCalls +=1;
    
  if (partitions[W][L] == 1){
    WastedArea = 0;
    mem[W][L] = 0;
  }

  if (WastedArea != 0) {
    for(int i = 1; i <= W/2 ; i++){
      if (mem[W-i][L] == -1){
        t11 = memoizationMethod(W-i, L, partitions,numberOfCalls);
      }
      else{
        t11 = mem[W-i][L];
        *numberOfCalls +=1;
      }
      if (mem[i][L] == -1){
        t12 = memoizationMethod(i, L, partitions, numberOfCalls);
      }
      else{
        t12 = mem[i][L];
        *numberOfCalls +=1;
      }
      t1f = t11 + t12;
      WastedArea = std::min( WastedArea , t1f);
    }

    for(int j = 1; j <= L/2 ; j++){
      if (mem[W][L-j] == -1){
        t21 = memoizationMethod(W, L-j, partitions,numberOfCalls);
      }
      else{
        t21 = mem[W][L-j];
        *numberOfCalls +=1;
      }
      if (mem[W][j] == -1){
        t22 = memoizationMethod(W, j, partitions,numberOfCalls);
      }
      else{
        t22 = mem[W][j];
        *numberOfCalls +=1;
      }
      t2f = t21 + t22;
      WastedArea = std::min( WastedArea , t2f);
      }
    mem[W][L] = WastedArea; 
  }

  return WastedArea;
}




int mem2[605][605];


void mem2_initialiser(int W, int L){
  
  for(int i = 1; i <= W; i++){
    for(int j = 1; j <= L; j++){
      mem2[i][j] = 605*605;
    }
  } 
}


int bottomUpMethod(int W, int L, bool** partitions, int* numberOfIterations){

  int WastedArea;
  if ( *numberOfIterations == 0){
    mem2_initialiser(W,L);
    (*numberOfIterations)++;
  }
  


  for(int i = 1; i < W+1; i++){
    for(int j = 1; j < L+1; j++){
      if (partitions[i][j] == 1){
        WastedArea = 0;
        //(*numberOfIterations)++;
      }
      else{
        WastedArea = i * j;
      }
      if (i == 1 && j ==1){
        mem2[i][j] = WastedArea;
        (*numberOfIterations)++;
      }
      else if (WastedArea != -1 && WastedArea != 0 ) {
        for(int x = i; x > 0 ; x--){
          WastedArea = std::min( WastedArea , mem2[i-x][j] + mem2[x][j]);
          (*numberOfIterations)++;
        }
        for(int y = j; y > 0 ; y--){
          WastedArea = std::min( WastedArea , mem2[i][j-y] + mem2[i][y]);
          (*numberOfIterations)++;
        }
      }
      else{}
    mem2[i][j] = WastedArea; 
    }
  }

  return mem2[W][L];
}
