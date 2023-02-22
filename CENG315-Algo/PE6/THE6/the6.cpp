#include "the6.h"
// Don't add any additional includes

/*
  N: Number of racers
  updates: Updates you have heard
*/


bool is_cyclic_helper(int**& graph, int n, int start, bool *visited, bool *explored, std::vector<int> &path, int &cycleend) {


   if(visited[start] == false)
  {
     // Mark the current node visited and explored
    visited[start] = true;
    explored[start] = true;

    for (int i = 0; i < n; i++) {
        if (graph[start][i] == 1) {
            if (visited[i]){
              cycleend = i;
              return true;
            }
            if (!visited[i] && is_cyclic_helper(graph, n, i, visited, explored,path,cycleend)) {
                path.insert(path.begin(),i);
                return true;
            } else if (explored[i]) {

              path.push_back(i);
                return true;
            }
            else{
              visited[i] = false; 
            }
      
        } 
      if (!path.empty()) {
        path.pop_back();
      }
    }




  }
    explored[start] = false;
    cycleend = start;
    return false;
}




bool is_cyclic(int**& adjm, int N, std::vector<int> &path) {
    bool* visited = new bool[N];
    bool* explored = new bool[N];
    int cycend;
    for (int i = 0; i < N; i++){
        visited[i] = false;
        explored[i] = false;
    }

    for (int i = 0; i < N; i++) {
        if (is_cyclic_helper(adjm, N, i, visited, explored, path, cycend)) {
            
            path.insert(path.begin(),i);
            for(unsigned int j=0; path.at(0) != cycend; i++){
              if (j < path.size())
                path.erase(path.begin());
            }

            path.push_back(cycend);
            return true;
        }
      path.clear();
      for (int i = 0; i < N; i++){
          visited[i] = false;
      }
    }

    path.clear();
    return false;
}



void find_reachable_nodes(int**& adjm, int N, int start, bool *visited, std::vector<int>& res) {
    visited[start] = true;

    for (int i = 0; i < N; i++) {
        if (adjm[start][i] == 1 && !visited[i]) {
            find_reachable_nodes(adjm, N, i, visited, res);
        }
    }

    res.push_back(start);
}


void find_topsort(int**& adjm, int N, std::vector<int>& res){


  bool* visited = new bool[N];
  for (int i = 0; i < N; i++){
    visited[i] = false;
  }
  for (int i = 0; i < N; i++) {
    if (!visited[i]) {
    find_reachable_nodes(adjm, N, i, visited, res);
    }
  }
}


std::pair<bool, std::vector<int>>
RaceResult(int N, std::vector<std::pair<int, int>> updates) {

  int **p;
  p = new int*[N];
  for (int i = 0; i < N; i++) {
    p[i] = new int[N];
    for (int j = 0; j < N; j++) {
        p[i][j] = 0;
    }
  }

  std::vector < std::pair<int,int> >::const_iterator it;
  for (it = updates.begin(); it != updates.end(); it++){
    p[it->first][it->second] = 1;
  }


  std::vector<int> path;

  if (is_cyclic(p,N,path)){

    return {false, path};

  }
  else {
        std::vector<int> result;
        std::vector<int> sortedres;
        find_topsort(p, N, result);
        for(unsigned int i=0; i < result.size(); i++){
          sortedres.insert(sortedres.begin(), result.at(i));
        }
        return {true, sortedres}; 

    }
    
}

