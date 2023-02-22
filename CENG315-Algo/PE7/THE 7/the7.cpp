#include "the7.h"



void gen_inner_Path(int u, int v,int **pred, std::vector<int>& path){

  if (pred[u][v] != -1){
    gen_inner_Path(u,pred[u][v],pred,path);
    path.push_back(pred[u][v]);
    gen_inner_Path(pred[u][v],v,pred,path);
  }
}


void gen_Path(int u, int v, int intm1 , int intm2 ,int **pred, std::vector<int>& path){

  path.push_back(u);
  gen_inner_Path(u,intm1,pred,path);
  path.push_back(intm1);
  gen_inner_Path(intm1,intm2,pred,path);
  path.push_back(intm2);
  gen_inner_Path(intm2,v,pred,path);
  path.push_back(v);

}

//undirected graph shortest path 

void FindRoute(int n, std::vector<Road> roads, int s, int d, int x, int y) {
  // You can change these variables. These are here for demo only.
  std::vector<int> path;
  int cost = INT_MAX;
  int final_cost = INT_MAX;
  int **dist, i, j, k;
  dist = new int*[n];
  for (int i = 0; i < n; i++) {
    dist[i] = new int[n];
    for (int j = 0; j < n; j++) {
        if (i == j){
          dist[i][j] = 0;
        }
        else{
        dist[i][j] = cost;
        }
    }
  }

  int **pred;
  pred = new int*[n];
  for (int i = 0; i < n; i++) {
    pred[i] = new int[n];
    for (int j = 0; j < n; j++) {
        pred[i][j] = -1;
    }
  }

  for (auto it = roads.begin(); it != roads.end(); ++it) {
      dist[it->endpoints.first][it->endpoints.second] = it->time;
      dist[it->endpoints.second][it->endpoints.first] = it->time;
  }

  for (k = 0; k < n; k++) {
    for (i = 0; i < n; i++) {
      for (j = 0; j < n; j++) {
          if (dist[i][j] > (dist[i][k] + dist[k][j])
              && (dist[k][j] != cost
              && dist[i][k] != cost)){
                dist[i][j] = dist[i][k] + dist[k][j];
                //cout << i << j  <<  k << endl;
                pred[i][j] = k;
            }
        }
      }
    }


    if ( dist[s][x]+dist[x][y]+dist[y][d] >  dist[s][y]+dist[y][x]+dist[x][d]){
      final_cost = dist[s][y]+dist[y][x]+dist[x][d];
      gen_Path(s,d,y,x,pred,path);

    }
    else{
      final_cost = dist[s][x]+dist[x][y]+dist[y][d];
      gen_Path(s,d,x,y,pred,path);
    }



  // Your output should be like this. You can change this as long as you keep
  // the output format. PrintRange function helps you print elements of
  // containers with iteratos (e.g., std::vector).

  std::cout << final_cost << " ";
  PrintRange(path.begin(), path.end());
  std::cout << std::endl;


}


