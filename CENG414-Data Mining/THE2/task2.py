import pandas as pd
import numpy as np
from math import sqrt
from random import seed
from random import randrange
import statistics as st


#Calculate the Euclidean distance b/w rows
def euclidean_distance(r1, r2):
  dist = 0.0
  for i in range(len(r1)-2):
    if( r1[i] != None):
      dist += (r1[i] - r2[i])**2
  return sqrt(dist)


# Locate the most similar neighbors
def get_neighbors(train, test_row, num_neighbors):
  euc_distances = []
  for train_row in train:
    dist = euclidean_distance(test_row, train_row)
    euc_distances.append((train_row, dist))
  euc_distances.sort(key=lambda tup: tup[1])
  neighbors = []
  distances = []
  for i in range(num_neighbors):
    neighbors.append(euc_distances[i][0])
    distances.append(euc_distances[i][1])   
  return neighbors,distances

 
# Split a dataset into k folds
def cross_validation_split(dataset, n_folds):
	dataset_split = list()
	dataset_copy = list(dataset)
	fold_size = int(len(dataset) / n_folds)
	for _ in range(n_folds):
		fold = list()
		while len(fold) < fold_size:
			index = randrange(len(dataset_copy))
			fold.append(dataset_copy.pop(index))
		dataset_split.append(fold)
	return dataset_split
 
# Calculate accuracy percentage
def accuracy_metric_MSE(actual, predicted):
    summation = 0 
    n = len(actual)
    #print(actual,predicted)
    for i in range (0,n):
        difference = actual[i] - predicted[i]
        squared_difference = difference**2
        summation += squared_difference
    MSE = summation/n 
    return MSE

def mape(actual,pred):
    actual, pred = np.array(actual), np.array(pred)
    return np.mean(np.abs((actual - pred) / actual)) * 100

  
def evaluate_algorithm(dataset, algorithm, n_folds, label, *args):
  folds = cross_validation_split(dataset, n_folds)
  scores = []
  for i in range(len(folds)-1):
    train_set = list(folds)
    #print(len(train_set))
    train_set.pop(i)
    train_set = sum(train_set, [])
    test_set = list()
    for row in folds[i]:
      row_copy = list(row)
      test_set.append(row_copy)
      row_copy[label] = None
  
    predicted = algorithm(train_set, test_set, *args, label)
    actual = [row[label] for row in folds[i]]
    #print(predicted,actual)
    MAPE = mape(actual,predicted)
    accuracy = accuracy_metric_MSE(actual, predicted)
    scores.append(accuracy)
    
  return scores, MAPE

def numm_class(data_set, test_row, num_neighbors, predict_column):
  predictions = list()
  for row in test_row:
    output = predict_numerical_classification(data_set, row, num_neighbors, predict_column)
    predictions.append(output)
  return(predictions)


# Make a classification prediction with neighbors
def predict_numerical_classification(data_set, test_row, num_neighbors, predict_column):
  neighbors,distances = get_neighbors(data_set, test_row, num_neighbors)
  output_values = [row[predict_column] for row in neighbors]
  weightage = [(1/d**2) for d in distances]
  prediction = 0
  for i in range(len(weightage)-1):
    prediction += weightage[i]*output_values[i]

  prediction /= sum(weightage)
  return prediction


def main():
    file_path = "auto-mpg.data"
    car_data = pd.read_csv(file_path, delim_whitespace=True, header=None)

    cross_folds = 3
    label_to_predict = 1
    k_Neighbours = [2,3,4,5,6,7,8,9,10]

    predicted_value = 0

    MAPEL = []
    RMSEL = []
    MSEL = []
  
    
    for k in k_Neighbours:
      scores, MAPE = evaluate_algorithm(car_data.values, numm_class, cross_folds, label_to_predict, k)
      MSE = st.mean(scores)
      RMSE = sqrt(MSE)
      MSEL.append(MSE)
      RMSEL.append(RMSE)
      MAPEL.append(MAPE)
    i = 0
    for i in range(0,len(k_Neighbours)-1):
      print('For K = %s MSE: %s' % (k_Neighbours[i],MSEL[i]))
    for i in range(0,len(k_Neighbours)-1):
      print('For K = %s RMSE: %s' % (k_Neighbours[i],RMSEL[i]))
    for i in range(0,len(k_Neighbours)-1):
      print('For K = %s MAPE: %s' % (k_Neighbours[i],MAPEL[i]))


if __name__ == "__main__":
    main()



