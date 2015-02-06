res = autorotate(im,bf);
first_crop = im(res.crop1(1):res.crop1(2),res.crop1(3):res.crop1(4));
figure();imagesc(first_crop);colormap gray; axis image;
rotate_im = imrotate(first_crop,res.phi,'crop');
figure();imagesc(rotate_im);colormap gray; axis image;
final_crop = rotate_im(res.crop2(1):res.crop2(2),res.crop2(3):res.crop2(4));
figure();imagesc(final_crop);colormap gray; axis image;

hold on;plot(res.eye1(1),res.eye1(2),'r*');plot(res.eye2(1),res.eye2(2),'r*');plot([res.eye1(1) res.eye2(1)],[res.eye1(2) res.eye2(2)],'r-');
plot(res.neuron(1),res.neuron(2),'go');plot([res.midpt(1) res.neuron(1)],[res.midpt(2) res.neuron(2)],'g-');hold off;