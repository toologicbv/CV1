function [] = testUseSVMS()

path = '/Users/Maurits/Documents/GitHub/School Projects/CV1/FinalAssign/20-train-data/';
root_dir = '/Users/Maurits/Documents/UvA AI/Computer Vision/Final Project 3/Caltech4/ImageData';



car_data_file = 'p_training_data_cars1200.mat';
car_data_file1 = 'hist_matrix_cars_test.mat';

face_data_file = 'p_training_data_faces1200.mat';
planes_data_file = 'p_training_data_planes1200.mat';
bikes_data_file = 'p_training_data_bikes1200.mat';
clustr_points = 'p_kmeansClusters1200.mat';

amount_cars_img  = 465;
amount_faces_img  = 400;
amount_plane_img  = 500;
amount_bikes_img  = 500;

total = amount_plane_img + amount_cars_img + amount_faces_img + amount_bikes_img;
cluster_points = loadMatrixFromFile(strcat(path,clustr_points));

data_car = loadMatrixFromFile(strcat(path,car_data_file));
data_faces = loadMatrixFromFile(strcat(path,face_data_file));

test_data = loadMatrixFromFile(strcat(path,car_data_file1));






labelsCars = zeros(total, 1); 
labelsFaces = zeros(total, 1);

labelsCars(1:amount_cars_img,:) = 1;
labelsCars(amount_cars_img+1:end,:) = -1;

labelsFaces(1:amount_faces_img,:) = 1;
labelsFaces(amount_faces_img+1:end,:) = -1;
 
modelCars = fitcsvm(data_car, labelsCars, 'KernelFunction', 'rbf', 'KernelScale', 'auto', 'Standardize', true);
modelFaces = fitcsvm(data_faces, labelsFaces, 'KernelFunction', 'rbf', 'KernelScale', 'auto', 'Standardize', true);



[SIFT_OUT_CARS,IMAGES_INDEX_CARS] = featureExtractionv2(root_dir, 'test', 'point', '', 'cars', false);
amount_of_images_cars = length(unique(IMAGES_INDEX_CARS(:,1)));
[ hist_matrix_cars ] = quantizeFeatures (SIFT_OUT_CARS,IMAGES_INDEX_CARS,amount_of_images_cars, cluster_points);


[labels_cars, scores_cars] = predict(modelCars, hist_matrix_cars);
[labels_faces, scores_faces] = predict(modelFaces, hist_matrix_cars);
scores_cars
scores_faces

 labels_cars
 labels_faces


end

