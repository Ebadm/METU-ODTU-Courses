#include "the2.h"
#include <iostream>

using namespace std;
//You may write your own helper functions here
void SwapValue(unsigned short &a, unsigned short &b) {
   unsigned short t = a;
   a = b;
   b = t;
}

int partition(unsigned short* arr, int size, long &swap, double & max_dist, double & sum_dist){

  unsigned short x;
  int j,i;
  i = -1;
  x = arr[size-1];
  for (int j=0; j< size-1 ; j++) {
    if (arr[j] >= x){
      i++;
      SwapValue(arr[i] , arr[j]);
      swap++;
      if ((j - i) > max_dist){
        max_dist = (j-i);
      }
      sum_dist += (j-i);
    }
  }
  SwapValue(arr[i+1] , arr[size-1]);
  if (( (size-1)  - (i+1) ) > max_dist){
    max_dist = (size-1)  - (i+1);
  }
  sum_dist += (size-1)  - (i+1);
  swap++;
  return i + 1;
}


int Hoare_Partition(unsigned short* arr, int size, long &swap, double & max_dist, double & sum_dist){

  unsigned short x;
  int j,i;
  i = -1;
  j = size;
  x = arr[(size-1)/2];
  while (true){
    do {
      j--;
    }
    while ((arr[j] < x));
    do {
      i++;
    }
    while ((arr[i] > x));
    if (i < j ){
      SwapValue(arr[i] , arr[j]);
      swap++;
      if ((j - i) > max_dist){
        max_dist = (j-i);
      }
      sum_dist += (j-i);
    }
    else{
      return j;
    }
  }
}


void quickSort(unsigned short* arr, long &swap, double & avg_dist, double & max_dist, bool hoare, int size)
{
  if (hoare){
    int p;
    double sum_dist = 0;
    long old_swaps = swap;

    if (size > 1){
      p = Hoare_Partition(arr, size, swap,max_dist,sum_dist);

      avg_dist = swap == 0 ? 0 : ((avg_dist * old_swaps) + sum_dist) / swap;
      
      int firsthalfsize = p+1;                                    //include P index in first half.
      int secondhalfsize = size - p - 1;
      unsigned short* secondhalf = (arr+p+1);
            
      quickSort(arr, swap , avg_dist, max_dist, hoare, firsthalfsize);
      quickSort(secondhalf, swap , avg_dist, max_dist, hoare, secondhalfsize);
  }
  }

  else {
    int p;
    double sum_dist = 0;
    long old_swaps = swap;

    if (size > 1){
      p = partition(arr, size, swap,max_dist,sum_dist);

      avg_dist = ((avg_dist * old_swaps) + sum_dist) / swap;

      int firsthalfsize = p;
      int secondhalfsize = size - p - 1;
      unsigned short* secondhalf = (arr+p+1);

      quickSort(arr, swap , avg_dist, max_dist, hoare, firsthalfsize);
      quickSort(secondhalf, swap , avg_dist, max_dist, hoare, secondhalfsize);

    }
	
  }
}


void threeWayPartition(unsigned short* arr, int size, long &swap,long &comparison, int& L , int& R){

  int j,i,p,min;
  j = 0;
  i = 0;
  p = size - 1;
  while (i<p){
    
    if(arr[i] > arr[size - 1]){
      comparison++;
      SwapValue(arr[i] , arr[j]);
      swap++;
      i++;
      j++;
    }
    else if (arr[i] == arr[size - 1]){
      comparison=comparison+2;
      p--;
      SwapValue(arr[i] , arr[p]);
      swap++;
    }
    else { i++; comparison=comparison+2; }
  }
  min =  (p-j) < (size-p) ? (p-j) : (size-p);
  int z = min;
  for(int k = 1; k <= min ; k++ , z--){
    SwapValue(arr[j+k-1] , arr[size-z]);
    swap++;
  }
  L = j;
  R = p-j;
}





void quickSort3(unsigned short *arr, long &swap, long &comparison, int size) {
	
    int L,R;
    if (size > 1){
      threeWayPartition(arr, size, swap,comparison, L, R);

      
      int firsthalfsize = L;                                   
      int secondhalfsize = R;
      unsigned short* secondhalf = (arr+(size-R));

      quickSort3(arr, swap , comparison , firsthalfsize);
      quickSort3(secondhalf, swap , comparison , secondhalfsize);
  }
}