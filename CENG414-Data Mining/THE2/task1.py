import pandas as pd
from math import sqrt




#Calculate the Euclidean distance b/w rows
def euclidean_distance(r1, r2):
	dist = 0.0
	for i in range(len(r1)-2):
		dist += (r1[i] - r2[i])**2
	return sqrt(dist)


# Locate the most similar neighbors
def get_neighbors(train, test_row, num_neighbors):
  euc_distances = []
  for train_row in train:
    print(test_row,train_row)
    dist = euclidean_distance(test_row, train_row)
    euc_distances.append((train_row, dist))
  euc_distances.sort(key=lambda tup: tup[1])
  neighbors = []
  distances = []
  for i in range(num_neighbors):
    neighbors.append(euc_distances[i][0])
    distances.append(euc_distances[i][1])   
  return neighbors,distances
 

# Make a classification prediction with neighbors

def predict_numerical_classification(data_set, test_row, num_neighbors,predict_column):

  neighbors,distances = get_neighbors(data_set, test_row, num_neighbors)
  output_values = [row[predict_column] for row in neighbors]
  weightage = [(1/d**2) for d in distances]
  prediction = 0
  for i in range(len(weightage)-1):
    prediction += weightage[i]*output_values[i]

  prediction /= sum(weightage)
  return prediction


def predict_category_classification(data_set, test_row, num_neighbors,predict_column):
  neighbors = get_neighbors(data_set, test_row, num_neighbors)[0]
  output_values = [row[predict_column] for row in neighbors]
  prediction = max(set(output_values), key=output_values.count)
  return prediction


def main():
  file_path = "auto-mpg.data"
  car_data = pd.read_csv(file_path, delim_whitespace=True, header=None)
  row0 = [17.0,8,305.5,130.5,3506.,12.0,70,1,"ODTU F1 Car"]
  
  category_columns = [1,6,7]
  numerical_columns = [0,2,3,4,5]
  
  label_to_predict = int(input("Input the prediction column: "))
  k_Neighbours = int(input("Input the K Neighbours number: K = "))

  predicted_value = 0
  
  if (label_to_predict in category_columns):
    predicted_value = predict_category_classification(car_data.values,row0,
                                                  k_Neighbours,label_to_predict)
    print('Column = {0}, Prediction: {1}'.format(label_to_predict, predicted_value))
  elif (label_to_predict in numerical_columns):
    predicted_value = predict_numerical_classification(car_data.values,row0,
                                                  k_Neighbours,label_to_predict)
    print('Column = {0}, Prediction: {1:.2f}'.format(label_to_predict, 
predicted_value))
  else:
    print("Enter a valid column")



if __name__ == "__main__":
    main()



