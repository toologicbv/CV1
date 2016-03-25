function [labelsFaces, labelsCars]=pipeLine(img_used_for_training, mode)
    % The following steps are perfomed by this function in order to build
    % four classifiers for the object recognition of cars, faces, airplanes
    % and motorbikes:
    % (1) build the visual codebook (by means of k-means)
    % (2) extract the features per image and quantize the features to the
    % visual words of the codebook (128 histogram vector)
    % (3) build the annotation vector for each category, only used for training 
    %
    %
    % Input parameters
    % (1)  img_used_for_training: the number of images per category that is
    % used for training purposes
    % (2)  mode: 'train' or 'test' (prediction) mode
    %
    %
    % Computervision I / Final Assignment
    % Jörg Sander / 10881530
    % Maurits Bleeker / 10694439
    tic

    % root dirs for development
    
    root_dir_maurits = '/Users/Maurits/Documents/UvA AI/Computer Vision/Final Project/Caltech4/ImageData/test/';
    root_dir_jorg = 'S:/workspace/cv_final/ImageData';
    root_dir = root_dir_jorg;
    % for testing puposes
    notJorg = false;
    % don't want to compute the codebook each time...takes too long on my
    % machine
    codebook = false;
    
    % parameters for the models, this should change depending on what you want to test  
    % choice between point and dense sampling
    sampling =  'point';
    img_cats = {'airplanes', 'cars', 'faces', 'motorbikes'};
    img_cats = {'airplanes', 'faces', 'cars'};
    % different colormodels used for SIFT feature extraction
    % if empty only grayscale is used
    cspaces = '';
    % indicates whether the featureExtractionv2 function will store/save
    % the intermediate results to a file
    save_data = false;
    % number of k-means clusters
    k = 200;
    % filename for k-means clusters...the codebook
    codebookFilename = 'kmeansClusters.mat';
    
    % In order to build the k-means model we extract from each image
    % category a certain number of images (by sampling).
    % the function returns a matrix N x 128 where N is the number of
    % features extracted from all sampled images.
    
    if strcmp(mode, 'train') && codebook
        % for training we need to extract features by sampling images and
        % then build the codebook by means of k-means
        X = featureExtractionKmeans(root_dir, mode, sampling, cspaces, img_used_for_training);
        % train k-means
        [C, ~ ] = kMeansClustering( X, k );
        % save the codebook
        save(codebookFilename, 'C');
    else
        % test mode, load the codebook from file
        C = loadMatrixFromFile(codebookFilename);
    end
    % total number of images variable
    t_num_of_img = 0;
    % in case we don't use all categories, initialize all matrices
    hist_matrix_planes = [];
    hist_matrix_cars = [];
    hist_matrix_faces = [];
    hist_matrix_bikes = [];
    % loop through categories and extract features from images for test or
    % training, then quantize the features based on codebook
    for c=1:length(img_cats)
        
        if strcmp(img_cats{c}, 'airplanes')
            [SIFT_OUT_PLANES,IMAGES_INDEX_PLANES] = ...
                featureExtractionv2(root_dir, mode, sampling, cspaces, img_cats{c}, save_data);
                amount_of_images_planes = length(unique(IMAGES_INDEX_PLANES(:,1)));
                t_num_of_img = t_num_of_img + amount_of_images_planes;
                [ hist_matrix_planes ] = ...
                    quantizeFeatures (SIFT_OUT_PLANES,IMAGES_INDEX_PLANES,amount_of_images_planes, C);
        elseif  strcmp(img_cats{c}, 'cars')
            [SIFT_OUT_CARS,IMAGES_INDEX_CARS] = ...
                featureExtractionv2(root_dir, mode, sampling, cspaces, img_cats{c}, save_data);
                amount_of_images_cars = length(unique(IMAGES_INDEX_CARS(:,1)));
                t_num_of_img = t_num_of_img + amount_of_images_cars;
                [ hist_matrix_cars ] = ...
                    quantizeFeatures (SIFT_OUT_CARS,IMAGES_INDEX_CARS,amount_of_images_cars, C);
        elseif strcmp(img_cats{c}, 'faces')
            [SIFT_OUT_FACES,IMAGES_INDEX_FACES] =...
                featureExtractionv2(root_dir, mode, sampling, cspaces, img_cats{c}, save_data);
                amount_of_images_faces = length(unique(IMAGES_INDEX_FACES(:,1)));
                t_num_of_img = t_num_of_img + amount_of_images_faces;
                [ hist_matrix_faces ] = ...
                    quantizeFeatures (SIFT_OUT_FACES,IMAGES_INDEX_FACES,amount_of_images_faces, C);
        elseif strcmp(img_cats{c}, 'motorbikes')
            [SIFT_OUT_BIKES,IMAGES_INDEX_BIKES] = ...
                featureExtractionv2(root_dir, mode, sampling, cspaces, img_cats{c}, save_data);
            	amount_of_images_bikes = length(unique(IMAGES_INDEX_BIKES(:,1)));
                t_num_of_img = t_num_of_img + amount_of_images_bikes;
                [ hist_matrix_bikes ] = ...
                    quantizeFeatures (SIFT_OUT_BIKES,IMAGES_INDEX_BIKES,amount_of_images_bikes, C);
        end
    end
    
    % make label vector for the complete data set
    % 1: indicates a true positive
    % -1: indicates a true negative
    % first we concatenate the histograms
    labelsAirplanes = [];
    training_data_planes = [];
    labelsCars = [];
    training_data_cars = [];
    labelsFaces = [];
    training_data_faces = [];
    labelsBikes = [];
    training_data_bikes = [];
    % by the way, we need two sequential for-loops (the previous and this
    % one) through the image categories because in in this step we need the
    % total number of images, which we know, AFTER we've looped once
    % through all the image category directories.
    for c=1:length(img_cats)
        
        if strcmp(img_cats{c}, 'airplanes')
            training_data_planes = cat(1,hist_matrix_planes,...
                                         hist_matrix_cars,...
                                         hist_matrix_faces,...
                                         hist_matrix_bikes);
            labelsAirplanes = zeros(t_num_of_img, 1); 
            labelsAirplanes(1:amount_of_images_planes) = 1;
            labelsAirplanes(amount_of_images_planes+1:end) = -1;
            
        elseif  strcmp(img_cats{c}, 'cars')
            % cars
            training_data_cars = cat(1,hist_matrix_cars,...
                                       hist_matrix_faces,...
                                       hist_matrix_planes,...
                                       hist_matrix_bikes);
            labelsCars = zeros(t_num_of_img, 1); 
            labelsCars(1:amount_of_images_cars) = 1;
            labelsCars(amount_of_images_cars+1:end) = -1;
        elseif strcmp(img_cats{c}, 'faces')
            % faces
            training_data_faces = cat(1,hist_matrix_faces,...
                                        hist_matrix_cars,...
                                        hist_matrix_planes,...
                                        hist_matrix_bikes);
            labelsFaces = zeros(t_num_of_img, 1); 
            labelsFaces(1:amount_of_images_faces) = 1;
            labelsFaces(amount_of_images_faces+1:end) = -1;
        elseif strcmp(img_cats{c}, 'motorbikes')
            % motorbikes
            training_data_bikes = cat(1,hist_matrix_bikes,...
                                        hist_matrix_cars,...
                                        hist_matrix_faces,...
                                        hist_matrix_planes);
            labelsBikes = zeros(t_num_of_img, 1); 
            labelsBikes(1:amount_of_images_bikes) = 1;
            labelsBikes(amount_of_images_bikes+1:end) = -1;
        end
    end
    % Train the four classifies with the libsvm function
    if strcmp(mode, 'train') && notJorg
        modelPlanes = svmtrain(labelsAirplanes, training_data_planes, '-c 1 -g 0.07 -b 1');
        modelCars = svmtrain(labelsCars, training_data_cars, '-c 1 -g 0.07 -b 1');
        modelFaces = svmtrain(labelsFaces, training_data_faces, '-c 1 -g 0.07 -b 1');
        modelBikes = svmtrain(labelsBikes, training_data_bikes, '-c 1 -g 0.07 -b 1');
        % save the models to file, we'll need them for the prediction phase 
        save('modelPlanes.mat', 'modelPlanes');
        save('modelCars.mat', 'modelCars');
        save('modelFaces.mat', 'modelFaces');
        save('modelBikes.mat', 'modelBikes');

    elseif strcmp(mode, 'test') && notJorg
        % load SVM models from file
        modelPlanes = loadMatrixFromFile('modelPlanes.mat');
        modelCars = loadMatrixFromFile('modelCars.mat');
        modelFaces = loadMatrixFromFile('modelFaces.mat');
        modelBikes = loadMatrixFromFile('modelBikes.mat');
        % NEEDS IMPLEMENTATION....libsvm predict
        
    end
    toc
end

