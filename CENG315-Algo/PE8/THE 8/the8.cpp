#include "the8.h"

//DO NOT ADD OTHER LIBRARIES

using namespace std;


long Hash(const string& X, int len){
  
  long h=0;
  int d = 26;
  int q = 7919;
    for (int i = 0; i < len; i++)
    {
        h = (d * h + X[i]) % q;
        if (h < 0) { h = h + q; }
    }
  return h;
}

long UpdateHash(const string& X, char o, char n, long t, int m){

  int d = 26;
  int q = 7919;
  int h = 1;

  for (int i = 0; i < m - 1; i++)
        h = (h * d) % q;

  t = (d*(t - o*h) + n) % q;

  if (t < 0)
    t = (t + q);
  return t;
}

vector<int> the8(const string& text, const vector<string>& patterns){

    vector<int> shifts; //DO NOT CHANGE THIS
    int s;
    int n = text.length();
    int m = patterns.at(0).length();
    long t = Hash(text,m);          // hash value for txt
    long p;
    vector<long> pattern_hashes;
    for(auto i = begin(patterns); i  != end(patterns); i++){
        p = Hash(*i, m);
        if (p==t && text.compare(0,m,*i)==0){
          shifts.push_back(0);
        }
        pattern_hashes.push_back(p);
    }

    for (s=0; s < n-m; s++){
      t = UpdateHash(text,text[s],text[s+m],t,m);
      for(unsigned int i = 0; i < patterns.size(); i++){
        p = pattern_hashes.at(i);
        if (p==t && text.compare(s+1,m,patterns.at(i))==0){
          shifts.push_back(s+1);
      }
    }
    
    }
    return shifts; //DO NOT CHANGE THIS
}

