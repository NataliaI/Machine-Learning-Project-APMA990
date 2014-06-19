function [I]=form_dist_matrix(x_train_data, x_test_data, cat_ind, num_ind)
% form_dist_matrix creates a matrix which stores distances
% between all possible pairs of points in training and testing data.
% Inputs: x_train_data: matrix of training data 
%         x_test_data: matrix of testing data (or training data) 
% Outputs: I : indices of sorted entries in dist_matrix
%              Entries sorted from smallest to largest row by row
%--------------------------------------------------------------------------
    
    dist_matrix=zeros(size(x_test_data,1),size(x_train_data,1));
    for i=1:size(x_test_data,1)
        for j=1:size(x_train_data,1)
           %Using Euclidean norm for numerical variables
            numDist=norm(x_test_data(i,num_ind)-x_train_data(j,num_ind));
           %Using Hamming distance for categorical variables
            catDist=pdist([x_test_data(i,cat_ind);x_train_data(j,cat_ind)],'hamming');
           %Final distance is a weighted sum of the two
              dist_matrix(i,j)=(length(num_ind)*numDist+length(cat_ind)*catDist)/(length(cat_ind)+length(num_ind));
        end  
    end
    %sorting distance matrix by row
    [S,I]=sort(dist_matrix,2); 
end 




    

