#include "the3.h"

// do not add extra libraries here


/*
    arr       : array to be sorted, in order to get points this array should contain be in sorted state before returning
    ascending : true for ascending, false for descending 
    n         : number of elements in the array
    l         : the number of characters used in counting sort at each time
    
    you can use ceil function from cmath
    
*/

unsigned powa( unsigned num, unsigned power) {
	if ( power <= 0 )
		return 1;
	return num * powa( num, power-1 );
}

int convertToASCII (std::string s)
{
  int res=0;
  int sum[s.length()];
  int x = s.length()-1;
  for (int i = 0; i < s.length(); i++){
    sum[i] = powa(26,x)*((int)(unsigned char)s[i]-65);
    x--;
  }
  int l = s.length();
  for (int i = 0; i < s.length(); i++){
    res += sum[i];
  }
  return res;

}


void countSort(std::string arr[], int n, int k,int &numOfIter,int l)
{
    std::string *output = NULL; int *c = NULL;
    int i;
    int highestn = powa(26,l);
    int* count = new int[highestn]{0};
    output = new std::string[n];
    std::string substr;


    for (int j = 0; j < n; j++){
        numOfIter++;
        substr = arr[j].substr(k,l);
        count[convertToASCII(substr)]++;         
    }

 
    for (i = 1; i < highestn; i++){
      count[i] += count[i - 1];
      numOfIter++;
    }
 
    for (i = n - 1; i >= 0; i--) {
      substr = arr[i].substr(k,l);
      output[count[convertToASCII(substr)]-1] = arr[i];
      count[convertToASCII(substr)]--;
      numOfIter++;
    }


    for (i = 0; i < n; i++)
    {
        arr[i] = output[i];
        numOfIter++;
    }

  delete[] output;
  delete[] count;
}


int radixSort(std::string arr[], bool ascending, int n, int l)
{
  int numOfIter=0;
	int exp, m;
  std::string reverse[n];
  bool flag = false;
  
  m = arr[0].length();
	for (exp = m-l; exp >= 0; exp -= l){
	    numOfIter++;
		countSort(arr, n, exp, numOfIter, l);
        if ((exp-l) < l){
          flag = true;
          break;
        }
    }

  if (flag){
      countSort(arr, n, 0, numOfIter, exp);
      numOfIter++;
  }
  
  if (!ascending){
  for (int i = 0; i < n; i++)
    {
      reverse[n-i-1]=arr[i] ;
    }

  for (int i = 0; i < n; i++)
    {
      arr[i] = reverse[i];
    }
  }

  return numOfIter;
}
