function generate_html(scores_cars, scores_faces, scores_bikes, scores_planes, file_name)
    
    % make a new file for the HTML table body
    fid = fopen(file_name, 'wt');
    
    % matrix of size 200 x 3
    % every row is a test example from the test set, the colums contains the score of an image, classID
    % and img ID. This matrix will be sorted on scores
    marix_cars = sort_data('cars', scores_cars);
    marix_faces = sort_data('faces', scores_faces);
    marix_bikes = sort_data('bikes', scores_bikes);
    marix_planes = sort_data('planes', scores_planes);
    
    fprintf(fid,'<tbody>\n');
    
    row = strcat('<tr><td><img src="%s"/></td><td><img src="%s"/></td><td><img src="%s"/></td><td><img src="%s"/></td></tr>\n');
                
    for i=1:length(scores_cars) 
        % function that returens the img url for every images, sorted on
        % score per class 
        car_img = getImg(marix_cars(i:i,:));
        faces_img = getImg(marix_faces(i:i,:));
        bikes_img = getImg(marix_bikes(i:i,:));
        planes_img = getImg(marix_planes(i:i,:));
        
        line = sprintf(row,planes_img,car_img,faces_img,bikes_img);
        
        fprintf(fid, '%s', line);
    end 
    fprintf(fid,'</tbody>');
    
    fclose(fid);

end

function return_img = getImg(row) 
    % match category ID of an image, with the class folder 
    if row(2) == 1
       cat = 'cars_test';
    elseif row(2) == 2
        cat = 'faces_test';
    elseif row(2) == 3
         cat = 'motorbikes_test';
    elseif row(2) == 4
        cat = 'airplanes_test';
    end
    % get image ID of the image
    if length(num2str(row(3))) == 1
        img_id = ['00',num2str(row(3))];
    elseif length(num2str(row(3))) == 2
        img_id = ['0',num2str(row(3))];
    end 
    
    % generate url of the img
    return_img = ['Caltech4/ImageData/',cat,'/img',img_id,'.jpg'];
    
    
end 

function sorted_cat =sort_data(model, scores)
    %ID's of the images classes
    
    img_cat_cars = 1;
    img_cat_faces = 2;
    img_cat_bikes = 3;
    img_cat_planes = 4;
	cats = zeros(200,1);
    img_ids = cat(1,linspace(1,50,50)',linspace(1,50,50)',linspace(1,50,50)',linspace(1,50,50)');
    
    % the order in which the classes appear in the test_data for each model
    if strcmp(model,'cars')
        cats(1:50) = img_cat_cars; 
        cats(51:100) = img_cat_faces;
        cats(101:150) = img_cat_planes;
        cats(151:200) = img_cat_bikes;
    elseif strcmp(model,'faces')
        
        cats(1:50) = img_cat_faces; 
        cats(51:100) = img_cat_cars;
        cats(101:150) = img_cat_planes;
        cats(151:200) = img_cat_bikes;
    elseif strcmp(model,'bikes')
        cats(1:50) = img_cat_bikes; 
        cats(51:100) = img_cat_cars;
        cats(101:150) = img_cat_faces;
        cats(151:200) = img_cat_planes;
    elseif strcmp(model,'planes')
        cats(1:50) = img_cat_planes; 
        cats(51:100) = img_cat_cars;
        cats(101:150) = img_cat_faces;
        cats(151:200) = img_cat_bikes;
    end
    % this matrix contains is sorted on the score for each test example,
    % each row contains the score, category ID and img_id, use
    matrix =  [scores(:,1), cats, img_ids]; 
    sorted_cat = sortrows(matrix, 1);
end 