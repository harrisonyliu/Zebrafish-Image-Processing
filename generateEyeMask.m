eyeFilter = ones(200,150);
for i = 1:200
    for j = 1:150
        temp = ((j-75)/65)^2 + ((i-100)/90)^2;
        if temp < 1
            eyeFilter(i,j) = -1;
        end
    end
end

for i = 1:200
    for j = 1:150
        temp = ((j-75)/10)^2 + ((i-100)/10)^2;
        if temp < 1
            eyeFilter(i,j) = 0;
        end
    end
end

figure();imagesc(eyeFilter);colormap gray;axis image;
hold on;plot(75,100,'go');