function [  ] = pipeLine()
    % tic is a time measurement for development and performance
    % optimization
    tic
    
    % root dirs for development
    % NOTE: I made a folder test, with 50 imgs per class for development
    root_dir_maurits = '/Users/Maurits/Documents/UvA AI/Computer Vision/Final Project/Caltech4/ImageData/test/';
    root_dir_jorg = 'S:/workspace/cv_final/ImageData';
    
    % parameters for the models, this should change depending on what you want to test  
    mode = 'train';
    sampling =  'point';
    img_cats = {'airplanes', 'cars', 'faces', 'motorbikes'};
    cspaces = '';
    save_data = false;
    k = 200;
    
    % Ik heb een nieuwe fucntie gemaakt featureExtractionKmeans, deze neemt
    % van iedere cat random n (minimaal 50) images en neemt daar de
    % descriptors van, deze worden gebruikt voor het trainen van de K-means
    X = featureExtractionKmeans(root_dir_maurits, sampling, cspaces, 50, 50);

    % train k-means
    [C, ~ ] = kMeansClustering( X, k );
    
    
    % voor iedere class get the features for every img
    img_used_for_training = 50;
    
    [SIFT_OUT_PLANES,IMAGES_INDEX_PLANES,amount_of_images_planes] = featureExtractionv1(root_dir_maurits, mode, sampling, cspaces, 'airplanes', save_data, img_used_for_training);
    %[SIFT_OUT_CARS,IMAGES_INDEX_CARS,amount_of_images_cars] = featureExtractionv1(root_dir_maurits, mode, sampling, cspaces, 'cars', save_data, img_used_for_training);
    %[SIFT_OUT_FACES,IMAGES_INDEX_FACES,amount_of_images_faces] = featureExtractionv1(root_dir_maurits, mode, sampling, cspaces, 'faces', save_data, img_used_for_training);
    %[SIFT_OUT_BIKES,IMAGES_INDEX_BIKES,amount_of_images_bikes] = featureExtractionv1(root_dir_maurits, mode, sampling, cspaces, 'motorbikes', save_data, img_used_for_training);
    
    
    [ hist_matrix_planes ] = quantizeFeatures (SIFT_OUT_PLANES,IMAGES_INDEX_PLANES,amount_of_images_planes, C);
    %[ hist_matrix_cars ] = quantizeFeatures (SIFT_OUT_CARS,IMAGES_INDEX_CARS,amount_of_images_cars, C);
    %[ hist_matrix_faces ] = quantizeFeatures (SIFT_OUT_FACES,IMAGES_INDEX_FACES,amount_of_images_faces, C);
    %[ hist_matrix_bikes ] = quantizeFeatures (SIFT_OUT_BIKES,IMAGES_INDEX_BIKES,amount_of_images_bikes, C);
    
    
    % make labels for the training data
    labels = zeros(img_used_for_training*4,1);
    
    
    % per class weten we dat alle images een label van 1 hebben, deze
    % kunnen we dus op 1 zetten, de rest op -1
    labels(1:img_used_for_training) = 1;
    labels(img_used_for_training+1:end) = -1;
    
    % per class maak een matrix met alle data, het eerste deel is de data
    % van die class bv. planes, de rest de andere data. Hierdoor kunnen we
    % dus altijd dezeflde labels gebruiken
    
    
    training_data_planes = cat(1,hist_matrix_planes,hist_matrix_cars,hist_matrix_faces,hist_matrix_bikes);
    %training_data_cars = cat(1,hist_matrix_cars,hist_matrix_planes,hist_matrix_bikes);
    %training_data_faces = cat(1,hist_matrix_faces,hist_matrix_cars,hist_matrix_planes,hist_matrix_bikes);
    %training_data_bikes = cat(1,hist_matrix_bikes,hist_matrix_cars,hist_matrix_faces,hist_matrix_planes);
    
    % maak een appart model per img cat
    
    modelPlanes = svmtrain(labels, training_data_planes, '-c 1 -g 0.07 -b 1');
    %modelCars = svmtrain(labels, training_data_cars, '-c 1 -g 0.07 -b 1');
    %modelFaces = svmtrain(labels, training_data_faces, '-c 1 -g 0.07 -b 1');
    %modelBikes = svmtrain(labels, training_data_bikes, '-c 1 -g 0.07 -b 1');
    toc
end

