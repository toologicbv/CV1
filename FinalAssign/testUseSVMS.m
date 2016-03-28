function [] = testUseSVMS()

path = '/Users/Maurits/Documents/GitHub/School Projects/CV1/FinalAssign/20-train-data/';

root_dir = '/Users/Maurits/Documents/UvA AI/Computer Vision/Final Project 3/Caltech4/ImageData';
car_data_file = 'p_training_data_cars1200.mat';
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
%data_car = loadMatrixFromFile(strcat(path,car_data_file));
data_faces = loadMatrixFromFile(strcat(path,face_data_file));
%data_planes = loadMatrixFromFile(strcat(path,planes_data_file));
%data_bikes = loadMatrixFromFile(strcat(path,bikes_data_file));

labelsCars = zeros(total, 1); 
labelsFaces = zeros(total, 1);
labelsPlanes = zeros(total, 1);
labelsBikes = zeros(total, 1);

labelsCars(1:amount_cars_img,:) = 1;
labelsCars(amount_cars_img+1:end,:) = -1;



labelsFaces(1:amount_faces_img,:) = 1;
labelsFaces(amount_faces_img+1:end,:) = -1;
 
labelsPlanes(1:amount_plane_img,:) = 1;
labelsPlanes(amount_plane_img+1:end,:) = -1;

labelsBikes(1:amount_bikes_img,:) = 1;
labelsBikes(amount_bikes_img+1:end,:) = -1;

disp 'start'
tic


model = fitcsvm(data_faces, labelsFaces, 'KernelFunction', 'rbf', 'KernelScale', 'auto', 'Standardize', true);
toc
%modelFaces = svmtrain(labelsFaces, data_faces, '-c 1 -g 0.07 -b 1');
%modelPlanes = svmtrain(labelsCars, data_planes, '-c 1 -g 0.07 -b 1');
%modelBikes = svmtrain(labelsBikes, data_bikes, '-c 1 -g 0.07 -b 1');


[SIFT_OUT,IMAGES_INDEX] = ...
featureExtractionv2(root_dir, 'test', 'point', '', 'faces', false);

amount_of_images = length(unique(IMAGES_INDEX(:,1)));
[ hist_matrix ] = quantizeFeatures (SIFT_OUT,IMAGES_INDEX,amount_of_images, cluster_points);
[labels, scores] = predict(model, data_faces);
length(find(labels == 1))



end

