function [ dataLabels ] = makeDataLabels( featureMatrix, objectClass, type, srcDir )
    % Function that returns the label for every feature we have, based on
    % the annotation data
    % 
    % input parameters:
    % (1) featureMatrix: matrix with the features for all the images (train/test) for one
    % object class 
    % (2) objectClass: object class/labels of the images (faces/airplanes/moterbikes/cars)
    % (3) type: train of test data
    % (4) srcDir: directory of the data annotation data
    if strcmp(srcDir, '') || strcmp(srcDir, ' ')
        srcDir = '/Users/Maurits/Documents/UvA AI/Computer Vision/Final Project/Caltech4/Annotation/';
    end 
    if ~strcmp(type, 'train') && ~strcmp(type, 'test')
        error('only train and test data is allow for this function'); 
    end 
    if  ~strcmp(objectClass, 'airplanes') && ~strcmp(objectClass, 'cars') && ~strcmp(objectClass, 'faces') && ~strcmp(objectClass, 'cars')
        error('There is not data for this object type, or there is a type'); 
    end 
    
    
    file_path = strcat(srcDir,objectClass,'_',type,'.txt');
    
    file = fopen(file_path);
    
    tline = fgetl(file)
    y = zeros(size(featureMatrix),1);
    while ischar(tline)
        tline = fgetl(file);
        splitted_line = strsplit(tline);
        image_name = splitted_line{1}
        
        label = splitted_line{2}
    end
    fclose(file);
    


    if length(img_number) == 1
        img_number = strcat('00',img_number);
    elseif length(img_number) == 2
        img_number = strcat('0',img_number);
    end 
    
end

