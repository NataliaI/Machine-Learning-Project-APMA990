function [pred_ydata] = knn(y_train_data,I, k)
% obtains the indices of the k-closest points to each test point and
% returns the average of the corresponding y-values.
%--------------------------------------------------------------------------
    indices=I(:,1:k); %indices corresponding to k-smallest distances
    pred_ydata=mean(y_train_data(indices),2);
end

    
