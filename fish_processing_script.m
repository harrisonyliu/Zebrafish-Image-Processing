load('F:\Zebrafish test images\2015.01.20 Wt BF and FL.mat');

%This will simply autorotate and crop each fish, labeling the neurons, not
%really necessary anymore!

fish_processed = struct();
fish_processed.FL = cell(0);
fish_processed.BF = cell(0);
fish_processed.eye1 = cell(0);
fish_processed.eye2 = cell(0);
fish_processed.neuron = cell(0);
fish_processed.midpt = cell(0);

for i = 1:size(fish_stack.images,3)
%Processing fish
i
FL = fish_stack.images(:,:,i);
BF = fish_stack.images_bf(:,:,i);
[fish_processed.FL{end+1} fish_processed.BF{end+1}, fish_processed.eye1{end+1}, fish_processed.eye2{end+1}, fish_processed.neuron{end+1}, fish_processed.midpt{end+1}] = orientationTest(FL,BF);

%Saving images
fname_dir = 'F:\2015.01.20 Zebrafish Automated brain ID results\Control2';
fname_fish = ['Fish ' num2str(i)];
h = gcf; print(h,'-dpng',full_fname);close(h);
end
full_fname = fullfile(fname_dir,fname_fish);