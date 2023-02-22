#include "the1.h"


//You can add your own helper functions

void SwapValue(int &a, int &b) {
   int t = a;
   a = b;
   b = t;
}

int sillySort(int* arr, long &comparison, long & swap, int size) 
{

    int num_of_calls=1;
    int q1,q2,q3,q4;
    
	if (size <= 2){
	    if (size == 2){
	        comparison++;
	        if (arr[0] > arr[1]){
    	        SwapValue(arr[0],arr[1]);
    	        swap++;
	        }
	    }
	}
	else{
	    
	    q1 = size/4; q2=size/2; q3 = 3*(size/4); q4 = size;
	    
	    int q1q2size = q2;
	    num_of_calls += sillySort(arr,comparison,swap,q1q2size);
	    
	    
	    int q2q3size = q3-q1;
	    int* arrq2q3 = arr;
        for (int i= 0; i < q1 ; i++)
        	{
        	    arrq2q3++;
        	}
   
	    num_of_calls += sillySort(arrq2q3,comparison,swap,q2q3size);
	    

	    int q3q4size = q4-q2;
	    int* arrq3q4 = arr;
        for (int i= 0; i < q2 ; i++)
        	{
        	    arrq3q4++;
        	}

	    num_of_calls += sillySort(arrq3q4,comparison,swap,q3q4size);
	  
        //working
	    
	    num_of_calls += sillySort(arr,comparison,swap,q1q2size);
	    
	    
	    num_of_calls += sillySort(arrq2q3,comparison,swap,q2q3size);
	    
	    
	    num_of_calls += sillySort(arr,comparison,swap,q1q2size);
	    
	}
	return num_of_calls;
}

//merge pseduocode and https://www.geeksforgeeks.org/merge-sort/ used to get merge function but
//q1 and q3 merged instead so change the function abit.

int * merge(int * leftArr, int* rightArr, int subsize1 ,int subsize2, long &comparison){


    int i,j;
    int * resArr = new int[subsize1+subsize2];

    int indexLeftArr = 0;               // Initial index of first sub-array
    int indexRightArr = 0;              // Initial index of second sub-array
    int indexMergedArr = 0;            //index array of merged array
    
    i=1; j = 1;
    while (indexLeftArr < subsize1 && indexRightArr < subsize2) {
        if (leftArr[indexLeftArr] <= rightArr[indexRightArr]) {
            comparison++;
            resArr[indexMergedArr] = leftArr[indexLeftArr];
            indexLeftArr++;
        }
        else {
            comparison++;
            resArr[indexMergedArr] = rightArr[indexRightArr];
            indexRightArr++;
        }
        indexMergedArr++;
    }

    while (indexLeftArr  < subsize1) {
        resArr[indexMergedArr]  = leftArr[indexLeftArr];
        indexLeftArr++;
        indexMergedArr++;
    }
    while (indexRightArr < subsize2) {
        resArr[indexMergedArr] = rightArr[indexRightArr];
        indexRightArr++;
        indexMergedArr++;
    }

  return resArr;
}



int crossMergeSort(int *arr, long &comparison, int size)
{
    int q1,q2,q3,q4;
    int num_of_calls=1;
    int *h1, *h2, *temp;
    if (size < 4){
	    if (size == 2){
	        comparison++;
	        if (arr[0] > arr[1]){
    	        SwapValue(arr[0],arr[1]);
	        }
	    }
    }
    else{
    q1 = size/4; q2=size/2; q3 = 3*(size/4); q4 = size;
    
    num_of_calls += crossMergeSort(arr,comparison,size/4);
    num_of_calls += crossMergeSort(arr+q1,comparison,size/4);
    num_of_calls += crossMergeSort(arr+q2,comparison,size/4);
    num_of_calls += crossMergeSort(arr+q3,comparison,size/4);
    
    int q1size = size/4;

    int q2size = size/4;
	int* arrq2 = arr;
    for (int i= 0; i < q1 ; i++)
    {
        arrq2++;
    }

    int q3size = size/4;
	int* arrq3 = arr;
    for (int i= 0; i < q2 ; i++)
    {
        arrq3++;
    }
    int q4size = size/4;
	int* arrq4 = arr;
    for (int i= 0; i < q3 ; i++)
    {
        arrq4++;
    }

    h1 =  merge(arr,arrq3,q1size,q2size,comparison);

    h2 =  merge(arrq2,arrq4,q2size,q4size,comparison);

    temp = merge(h1,h2,size/2,size/2,comparison);

    for (int i=0; i<size;i++) {
      arr[i] = temp[i];
    }
	
  }
  return num_of_calls;
}
