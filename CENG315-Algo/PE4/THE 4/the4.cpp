#include "the4.h"



int recursive_sln(int i, int*& arr, int &number_of_calls){ //direct recursive
  number_of_calls+=1;
  int x,y;
  int val;
  
  if (i==0){
    return arr[0];
  }
  if (i==1){
    return (arr[1] > arr[0]? arr[1] : arr[0]);
  }
  if (i==2){
    val = ( (arr[2] > arr[1]) ? arr[2] : arr[1]);
    val = ( (arr[0] > val) ? arr[0] : val);
    return val;
  }

  x = recursive_sln(i-3,arr,number_of_calls) + arr[i];
  y = recursive_sln(i-1,arr,number_of_calls) ;


  return ( (x>y) ? x: y);
}


int memoization_sln(int i, int*& arr, int*& mem){ //memoization

  int x,y,z,val;
  mem[0] = arr[0];
  mem[1] = arr[1] > mem[0] ? arr[1] : mem[0];
  mem[2] = arr[2] > mem[1] ? arr[2] : mem[1];

  if (( i >= 3) && (mem[i-3] == -1) ) 
    x=memoization_sln(i-3, arr, mem) + arr[i];
  else 
    x=mem[i-3]+arr[i];

  if ((i >= 3) && (mem[i-2] == -1)) 
    y=memoization_sln(i-2, arr, mem); 
  else 
    y=mem[i-2];

  if ((i >= 3) && (mem[i-1] == -1)) 
    z=memoization_sln(i-1, arr, mem); 
  else 
    z=mem[i-1];   
  
  val = ( (x > y) ? x : y);
  val = ( (z > val) ? z : val);
  mem[i]= val;
  return (mem[i]); 
}



int dp_sln(int size, int*& arr, int*& mem){ //dynamic programming

  int x,y,z,val;
  mem[0] = arr[0];
  mem[1] = arr[1] > mem[0] ? arr[1] : mem[0];
  mem[2] = arr[2] > mem[1] ? arr[2] : mem[1];
  for (int i = 3; i < size; i++){
    val = (mem[i-3]+arr[i] > mem[i-2] ? mem[i-3]+arr[i] : mem[i-2]);
    val = (mem[i-1]  > val ? mem[i-1] : val);
    mem[i] = val;
  }

  return mem[size-1];
}

