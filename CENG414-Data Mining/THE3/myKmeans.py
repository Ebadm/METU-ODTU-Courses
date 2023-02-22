import numpy as np
import pandas as pd
import random

#arr = np.array([[1, 2, 3, 4, 5, 6,7,8,9,10,11,12,13],[11, 12, 13, 14, 15, 16,17,18,19,20,21,22,23],[21, 22, 23, 24, 25, 26,27,28,29,30,31,32,33],[31, 32, 33, 34, 35, 36,37,38,39,40,41,42,43]])

data = np.load("dataset.npy")
df = pd.DataFrame(data)


def calc_distance(X1, X2):
    #Remove nan values when calculating euc distance
    indices_1 = np.isnan(X1)
    indices_2 = np.isnan(X2)
    indices_total = indices_1 + indices_2
    X1 = X1[~indices_total]
    X2 = X2[~indices_total]
    return(sum((X1 - X2)**2))**0.5

def cluster_kmeans(X,cluster,centroids):
    diff = 1

    while diff:

        # for each observation
        for i, row in enumerate(X):

            mn_dist = float('inf')
            # dist of the point from all centroids
            for idx, centroid in enumerate(centroids):
                d = calc_distance(centroid, row)

                # store closest centroid 
                if mn_dist >= d:
                    mn_dist = d
                    cluster[i] = idx

        new_centroids = pd.DataFrame(X).groupby(by=cluster).mean().values   #start new iteration

        try:
            if np.count_nonzero(centroids-new_centroids) == 0:  # if centroids are same then stop
                break
            else:
                centroids = new_centroids
        except:
            centroids = new_centroids


    return centroids, cluster  





def kmeans(k, init, manual_init = None ):
  
    cluster = np.zeros(data.shape[0])                        #initialise all to 0

    if (init == "Random"):
        # select k random centroids
        random_indices = np.random.choice(len(data), size=k, replace=False)  #get random initial index
        centroids = data[random_indices, :]  #get 3 centroids, 12 row each

    elif (init == "Manual"):
        centroids = np.array(manual_init)

    elif (init == "Average"):
        new_data = np.array_split(data, k)                     #split dataset to k sets
        centroids = []
        for i in range(len(new_data)):
            avg_col = np.nanmean(new_data[i],axis=0)        #get average of each column 
            centroids.append(avg_col)                       #Cluster i's centroid is appended

    else:
        print("Error!")

    centroids, cluster = cluster_kmeans(data,cluster,centroids)

    return centroids, cluster  

def findEucDistance(x1, y1):
    distance = 0
    for i in range(len(x1)):
        distance = distance + (x1[i] - y1[i])**2
    return distance**0.5 

def calcDunnIndex(points, cluster):

    numer = float('inf')
    for c1 in cluster:
        for c2 in cluster: # for each cluster vs cluster
            if (c1 == c2).all(): #ignore same cluster's comparison with itself
                continue
            intercluster_distance = findEucDistance(c1, c2)
            numer = min(numer, intercluster_distance) # find distance between centroids
            
    denom = 0
    for clst in cluster: # for each cluster
        for p in points:
            for t in points: # for each point vs point
                if (t == p).all():
                     continue           #ignore point's comparison with itself
                intracluster_distance = findEucDistance(t, p)
                denom = max(denom, intracluster_distance)
                
    return numer/denom


def main():
    k = 3               #k == 3 set for testing
    init = input("Input Initialization Technique (Manual,Random,Average): ")
    if (init == "Manual"):
        input("Enter 2d list with an array of shape (n_clusters, n_features) = :" )

    centroids, clusters = kmeans(k,init)
    print(clusters)               
    print(centroids) 
    print("DUNN INDEX = ", calcDunnIndex(data,centroids))
    

if __name__ == "__main__":
    main()