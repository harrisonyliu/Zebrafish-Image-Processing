head = ones(450,501);

for i = 1:450
    for j = 1:501
        if i/3. + abs(j-250) > 250;
            head(i,j) = -1;
        end
    end
end

tail = imrotate(head,180);
figure();imagesc(head);colormap gray;axis image;title('Head up');
figure();imagesc(tail);colormap gray;axis image;title('Tail up');