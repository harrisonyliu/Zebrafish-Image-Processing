function metascore = calc_metascore(w,feat_struct,bias,scaling)
%Will take in a weight vector w and a structure feat_struct in which each
%field represents a feature. Each field should consist of a 1xN cell in
%which each cell represents an 8x12 array of plate data (e.g. N plates
%worth of data per field). This function will then calculate the resultant
%metascore for the data. If bias and scaling are empty then this function
%will assume the first and last columns are the positive and negative
%controls respectively, and scale the data based upon that.

features = fieldnames(feat_struct);
numplates = eval(['numel(feat_struct.' features{1} ')']);
metascore = cell(1,numplates);

for i = 1:numplates
    temp_array = zeros(8,12,numel(features));
    for j = 1:numel(features)
        %Fill up the temp array with each array along the z dimension
        %representing a unique feature
        eval(['temp = feat_struct.' features{j} '{' num2str(i) '};']); 
        %Now we need to rescale everything
        if isempty(bias) == 1
            ctrl_data = temp(:,[1,7]);
            ctrl_data = reshape(ctrl_data,1,numel(ctrl_data));
            bias = nanmean(ctrl_data); scaling = nanstd(ctrl_data);
            temp = (temp - bias) ./ scaling;
            temp_array(:,:,j) = temp;
            bias = [];
        else
            temp = (temp - bias) ./ scaling;
            temp_array(:,:,j) = temp;
        end
    end
    %Now let's collapse all the features into one!
    res_array = zeros(8,12);
    for row = 1:size(res_array,1)
        for col = 1:size(res_array,2)
            res_array(row,col) = dot(squeeze(temp_array(row,col,:)), w);
            metascore{i} = res_array;
        end
    end
end

%Now let's correct the metascore so that all values are positive and
%greater values mean the sample looks more like the positive controls.
min_array = zeros(1,3);
for i = 1:numel(metascore)
    min_array(i) = min(min(metascore{i}));
end

correction = min(min_array);
for i = 1:numel(metascore)
    temp = metascore{i};
    temp = -1 * temp - correction;
    metascore{i} = temp;
end
end

