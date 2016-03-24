function [  ] = pipeLine()
    tic
    root_dir_maurits = '/Users/Maurits/Documents/UvA AI/Computer Vision/Final Project/Caltech4/ImageData/test/';
    root_dir_jorg = 'S:/workspace/cv_final/ImageData';
    
    mode = 'train';
    sampling =  'point';
    img_cats = {'airplanes', 'cars', 'faces', 'motorbikes'};
    cspaces = '';
    save_data = false;
    k = 200;
    
    % ik heb een nieuwe fucntie gemaakt featureExtractionKmeans, deze neemt
    % van iedere cat random n(minimaal 50) images en neemt daar de
    % descriptors van, deze worden gebruikt voor het trainen van de K-means
    X = featureExtractionKmeans(root_dir_maurits, sampling, cspaces, 50);

    % train k-means
    [C, ~ ] = kMeansClustering( X, k );
    
    
    % voor iedere class get the features for every img
    
    img_used_for_training = 50;
    
    [SIFT_OUT_PLANES,IMAGES_INDEX_PLANES,amount_of_images_planes] = featureExtractionv1(root_dir_maurits, mode, sampling, cspaces, 'airplanes', save_data, img_used_for_training);
    [SIFT_OUT_CARS,IMAGES_INDEX_CARS,amount_of_images_cars] = featureExtractionv1(root_dir_maurits, mode, sampling, cspaces, 'cars', save_data, img_used_for_training);
    [SIFT_OUT_FACES,IMAGES_INDEX_FACES,amount_of_images_faces] = featureExtractionv1(root_dir_maurits, mode, sampling, cspaces, 'faces', save_data, img_used_for_training);
    [SIFT_OUT_BIKES,IMAGES_INDEX_BIKES,amount_of_images_bikes] = featureExtractionv1(root_dir_maurits, mode, sampling, cspaces, 'motorbikes', save_data, img_used_for_training);
    
    
    [ hist_matrix_planes ] = quantizeFeatures (SIFT_OUT_PLANES,IMAGES_INDEX_PLANES,amount_of_images_planes, C);
    [ hist_matrix_cars ] = quantizeFeatures (SIFT_OUT_CARS,IMAGES_INDEX_CARS,amount_of_images_cars, C);
    [ hist_matrix_faces ] = quantizeFeatures (SIFT_OUT_FACES,IMAGES_INDEX_FACES,amount_of_images_faces, C);
    [ hist_matrix_bikes ] = quantizeFeatures (SIFT_OUT_BIKES,IMAGES_INDEX_BIKES,amount_of_images_bikes, C);
    
    labels = zeros(img_used_for_training*4,1);
    
    
    % ik heb het even gecheckt, in folder airplains zitten alleen maar img
    % die 1 hebben voor airplain,zelfde geldt voor faces etc. etc. we
    % hebben die labels dus helemaal niet nodig, zoals we ervoor zorgen dat
    % we alleen img uit een bepaalde map halen kunnen we die gewoon
    % allemaal een 1 geven de test 1-
    labels(1:img_used_for_training) = 1;
    labels(img_used_for_training+1:end) = -1;
    
    
    % door het aantal img per class gelijk te zetten, en de images per data
    % set op een andere manier te Concatenaten kunnen we dezelfde labels
    % gebruiken voor iedere dataset 
    training_data_planes = cat(1,hist_matrix_planes,hist_matrix_cars,hist_matrix_faces,hist_matrix_bikes);
    training_data_cars = cat(1,hist_matrix_cars,hist_matrix_planes,hist_matrix_bikes);
    training_data_faces = cat(1,hist_matrix_faces,hist_matrix_cars,hist_matrix_planes,hist_matrix_bikes);
    training_data_bikes = cat(1,hist_matrix_bikes,hist_matrix_cars,hist_matrix_faces,hist_matrix_planes);
    
    modelPlanes = svmtrain(labels, training_data_planes, '-c 1 -g 0.07 -b 1');
    modelCars = svmtrain(labels, training_data_cars, '-c 1 -g 0.07 -b 1');
    modelFaces = svmtrain(labels, training_data_faces, '-c 1 -g 0.07 -b 1');
    modelBikes = svmtrain(labels, training_data_bikes, '-c 1 -g 0.07 -b 1');
    toc
end

