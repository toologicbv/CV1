function pipeLine(img_used_for_training, mode, cspace, sampling, k)
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
    
    % give the root dir where all the images are located
    root_dir = '/Users/Maurits/Documents/UvA AI/Computer Vision/Final Project 3/Caltech4/ImageData';
    
    
    
    % don't want to compute the codebook each time...takes too long on my
    % machine, use this for developemt
    codebook = true;
    
    % parameters for the models, this should change depending on what you want to test  
    % choice between point and dense sampling
    % sampling =  'point';
    img_cats = {'airplanes', 'cars', 'faces', 'motorbikes'};

    
    
    % filename for k-means clusters...the codebook. this file will be used
    % in test-mode. The kmeans model will be saved during training and
    % loaded while testing
    codebookFilename = [sampling(1), '_', cspace, '_kmeansClusters', num2str(k), '.mat'];
    
    % In order to build the k-means model we extract from each image
    % category a certain number of images (by sampling).
    % the function returns a matrix N x 128 where N is the number of
    % features extracted from all sampled images.
    
    if strcmp(mode, 'train') && codebook
        % for training we need to extract features by sampling images and
        % then build the codebook by means of k-means
        X = featureExtractionKmeans(root_dir, sampling, cspace, img_used_for_training);
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
                featureExtractionv2(root_dir, mode, sampling, cspace, img_cats{c});
                amount_of_images_planes = length(unique(IMAGES_INDEX_PLANES(:,1)));
                t_num_of_img = t_num_of_img + amount_of_images_planes;
                [ hist_matrix_planes ] = ...
                    quantizeFeatures (SIFT_OUT_PLANES,IMAGES_INDEX_PLANES,amount_of_images_planes, C);
        elseif  strcmp(img_cats{c}, 'cars')
            [SIFT_OUT_CARS,IMAGES_INDEX_CARS] = ...
                featureExtractionv2(root_dir, mode, sampling, cspace, img_cats{c});
                amount_of_images_cars = length(unique(IMAGES_INDEX_CARS(:,1)));
                t_num_of_img = t_num_of_img + amount_of_images_cars;
                [ hist_matrix_cars ] = ...
                    quantizeFeatures (SIFT_OUT_CARS,IMAGES_INDEX_CARS,amount_of_images_cars, C);
        elseif strcmp(img_cats{c}, 'faces')
            [SIFT_OUT_FACES,IMAGES_INDEX_FACES] =...
                featureExtractionv2(root_dir, mode, sampling, cspace, img_cats{c});
                amount_of_images_faces = length(unique(IMAGES_INDEX_FACES(:,1)));
                t_num_of_img = t_num_of_img + amount_of_images_faces;
                [ hist_matrix_faces ] = ...
                    quantizeFeatures (SIFT_OUT_FACES,IMAGES_INDEX_FACES,amount_of_images_faces, C);
        elseif strcmp(img_cats{c}, 'motorbikes')
            [SIFT_OUT_BIKES,IMAGES_INDEX_BIKES] = ...
                featureExtractionv2(root_dir, mode, sampling, cspace, img_cats{c});
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
            data_planes = cat(1,hist_matrix_planes,...
                                         hist_matrix_cars,...
                                         hist_matrix_faces,...
                                         hist_matrix_bikes);
            labelsAirplanes = zeros(t_num_of_img, 1); 
            labelsAirplanes(1:amount_of_images_planes) = 1;
            labelsAirplanes(amount_of_images_planes+1:end) = -1;
            save([sampling(1),'_', cspace, '_',mode,'_data_planes', num2str(k), '.mat'], 'training_data_planes');
            save([sampling(1), '_', cspace,'_labelsAirplanes', num2str(k), '.mat'], 'labelsAirplanes');
        elseif  strcmp(img_cats{c}, 'cars')
            % cars
            data_cars = cat(1,hist_matrix_cars,...
                                       hist_matrix_faces,...
                                       hist_matrix_planes,...
                                       hist_matrix_bikes);
            labelsCars = zeros(t_num_of_img, 1); 
            labelsCars(1:amount_of_images_cars) = 1;
            labelsCars(amount_of_images_cars+1:end) = -1;
            save([sampling(1), '_', cspace, '_',mode,'_data_cars', num2str(k), '.mat'], 'training_data_cars');
            save([sampling(1), '_', cspace, '_labelsCars', num2str(k), '.mat'], 'labelsCars');
        elseif strcmp(img_cats{c}, 'faces')
            % faces
            data_faces = cat(1,hist_matrix_faces,...
                                        hist_matrix_cars,...
                                        hist_matrix_planes,...
                                        hist_matrix_bikes);
            labelsFaces = zeros(t_num_of_img, 1); 
            labelsFaces(1:amount_of_images_faces) = 1;
            labelsFaces(amount_of_images_faces+1:end) = -1;
            save([sampling(1), '_', cspace, '_',mode,'_data_faces', num2str(k), '.mat'], 'training_data_faces');
            save([sampling(1), '_', cspace, '_labelsFaces', num2str(k), '.mat'], 'labelsFaces');
        elseif strcmp(img_cats{c}, 'motorbikes')
            % motorbikes
            data_bikes = cat(1,hist_matrix_bikes,...
                                        hist_matrix_cars,...
                                        hist_matrix_faces,...
                                        hist_matrix_planes);
            labelsBikes = zeros(t_num_of_img, 1); 
            labelsBikes(1:amount_of_images_bikes) = 1;
            labelsBikes(amount_of_images_bikes+1:end) = -1;
            save([sampling(1), '_', cspace, '_',mode,'_data_bikes', num2str(k), '.mat'], 'training_data_bikes');
            save([sampling(1), '_', cspace, '_labelsBikes', num2str(k), '.mat'], 'labelsBikes');
        end
    end
    % Train the four classifies with the libsvm function
    if strcmp(mode, 'train') 
        
        modelPlanes = fitcsvm(data_planes, labelsAirplanes, 'KernelFunction', 'rbf', 'KernelScale', 'auto', 'Standardize', true);
        modelCars = fitcsvm(data_cars, labelsCars, 'KernelFunction', 'rbf', 'KernelScale', 'auto', 'Standardize', true);
        modelFaces = fitcsvm(data_faces, labelsFaces, 'KernelFunction', 'rbf', 'KernelScale', 'auto', 'Standardize', true);
        modelBikes = fitcsvm(data_bikes, labelsBikes, 'KernelFunction', 'rbf', 'KernelScale', 'auto', 'Standardize', true);
        
        % save the models to file, we'll need them for the prediction phase 
        save('modelPlanes.mat', 'modelPlanes');
        save('modelCars.mat', 'modelCars');
        save('modelFaces.mat', 'modelFaces');
        save('modelBikes.mat', 'modelBikes');

    elseif strcmp(mode, 'test') 
        % load SVM models from file
        modelPlanes = loadMatrixFromFile('modelPlanes.mat');
        modelCars = loadMatrixFromFile('modelCars.mat');
        modelFaces = loadMatrixFromFile('modelFaces.mat');
        modelBikes = loadMatrixFromFile('modelBikes.mat');
        
        
    end
    
    if strcmp(mode, 'test')
        % get the AP for each model, and the scores for each training
        % example
        [AP_PLANES, scores_planes] = apScore(modelPlanes, data_planes, labelsAirplanes);
        [AP_CARS, scores_cars ]  = apScore(modelCars, data_cars, labelsCars);
        [AP_FACES, scores_faces ] = apScore(modelFaces, data_faces, labelsFaces);
        [AP_BIKES, scores_bikes ] = apScore(modelBikes, data_bikes, labelsBikes);

        MAP = (AP_PLANES + AP_CARS + AP_FACES + AP_BIKES) / 4
        AP_PLANES
        AP_CARS
        AP_FACES
        AP_BIKES
        
        % generate the HTML template (only the table body will be generated)
        generate_html(scores_cars, scores_faces, scores_bikes, scores_planes, 'htmloutput800dense.txt');
    end 
    toc
end

