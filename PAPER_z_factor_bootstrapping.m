close all
clear all

load 'PAPER_data_z_factor.mat';

%First let's calculate some baseline stats for our assay
conv_pos75 = log2(0.75*(aggregateData.Intensity_TotalIntensity_ghettoconv.posctrl));
conv_pos = log2(aggregateData.Intensity_TotalIntensity_ghettoconv.posctrl);
conv_neg = log2(aggregateData.Intensity_TotalIntensity_ghettoconv.negctrl);

MAD_pos = log2(aggregateData.Intensity_MADIntensity_eyes_removed_cropped_Neurons.posctrl);
MAD_neg = log2(aggregateData.Intensity_MADIntensity_eyes_removed_cropped_Neurons.negctrl);

Int_pos = log2(aggregateData.Intensity_TotalIntensity_eyes_removed_cropped_Neurons.posctrl);
Int_neg = log2(aggregateData.Intensity_TotalIntensity_eyes_removed_cropped_Neurons.negctrl);

% conv_pos = aggregateData.Intensity_TotalIntensity_ghettoconv.posctrl;
% conv_neg = aggregateData.Intensity_TotalIntensity_ghettoconv.negctrl;
% 
% MAD_pos = aggregateData.Intensity_MADIntensity_eyes_removed_cropped_Neurons.posctrl;
% MAD_neg = aggregateData.Intensity_MADIntensity_eyes_removed_cropped_Neurons.negctrl;
% 
% Int_pos = aggregateData.Intensity_TotalIntensity_eyes_removed_cropped_Neurons.posctrl;
% Int_neg = aggregateData.Intensity_TotalIntensity_eyes_removed_cropped_Neurons.negctrl;

%Here we do some platewise normalization (subtract off median of neg
%controls)
% [conv_pos, conv_neg] = pairwiseDifferenceNormalization(conv_pos, conv_neg);
% [MAD_pos, MAD_neg] = pairwiseDifferenceNormalization(MAD_pos, MAD_neg);
% [Int_pos, Int_neg] = pairwiseDifferenceNormalization(Int_pos, Int_neg);

pos_idx = isnan(MAD_pos); MAD_pos(pos_idx) = []; Int_pos(pos_idx) = []; conv_pos(pos_idx) = []; conv_pos75(pos_idx) = [];
neg_idx = isnan(MAD_neg); MAD_neg(neg_idx) = []; Int_neg(neg_idx) = []; conv_neg(neg_idx) = [];

[MAD_z, ~, MAD_ssmd] = calcScreenQuality(MAD_pos, MAD_neg);
['MAD Z-factor is: ' num2str(MAD_z)]
['MAD SSMD is: ' num2str(MAD_ssmd)]

[Int_z, ~, Int_ssmd] = calcScreenQuality(Int_pos, Int_neg);
['Intensity Z-factor is: ' num2str(Int_z)]
['Intensity SSMD is: ' num2str(Int_ssmd)]

[conv_z, conv_z_robust, conv_ssmd] = calcScreenQuality(conv_pos, conv_neg);
['Convolutional Z-factor is: ' num2str(conv_z)]
['Convolutional robust Z-factor is: ' num2str(conv_z_robust)]
['Convolutional SSMD is: ' num2str(conv_ssmd)]

%Next let's combine our features together by multiplying them (healthy
%neurons = high MAD and high fluorescence)

compound_pos = MAD_pos .* Int_pos;
compound_neg = MAD_neg .* Int_neg;
[compound_z, ~, compound_ssmd] = calcScreenQuality(compound_pos, compound_neg);

%For the next step we bootstrap the data
[score_zfactor, score_ssmd, score_robust_zfactor] = bootstrapSample(Int_pos,Int_neg,1000,3);
Z_factor_avg = mean(score_zfactor); ssmd_avg = mean(score_ssmd); robust_Z_factor_avg = mean(score_robust_zfactor);
['Bootstrapped N=3 Intensity Z-factor is: ' num2str(Z_factor_avg)]
['Bootstrapped N=3 Intensity Robust Z-factor is: ' num2str(robust_Z_factor_avg)]
['Bootstrapped N=3 Intensity ssmd_avg is: ' num2str(ssmd_avg)]

% [score_zfactor, score_ssmd] = bootstrapSample(MAD_pos,MAD_neg,1000,3);
% Z_factor_avg = mean(score_zfactor); ssmd_avg = mean(score_ssmd);
% ['Bootstrapped N=3 MAD Z-factor is: ' num2str(Z_factor_avg)]
% ['Bootstrapped N=3 MAD ssmd_avg is: ' num2str(ssmd_avg)]
% 
% [score_zfactor, score_ssmd] = bootstrapSample(compound_pos,compound_neg,1000,3);
% Z_factor_avg = mean(score_zfactor); ssmd_avg = mean(score_ssmd);
% ['Bootstrapped N=3 compound Z-factor is: ' num2str(Z_factor_avg)]
% ['Bootstrapped N=3 compound ssmd_avg is: ' num2str(ssmd_avg)]

[score_zfactor, score_ssmd, score_robust_zfactor] = bootstrapSample(conv_pos,conv_neg,1000,3);
Z_factor_avg = mean(score_zfactor); ssmd_avg = mean(score_ssmd); robust_Z_factor_avg = mean(score_robust_zfactor);
['Bootstrapped N=3 convolutional Z-factor is: ' num2str(Z_factor_avg)]
['Bootstrapped N=3 convolutional Robust Z-factor is: ' num2str(robust_Z_factor_avg)]
['Bootstrapped N=3 convolutional ssmd_avg is: ' num2str(ssmd_avg)]

%Theoretical hit that is only 75% as strong as the positive control
[score_zfactor, score_ssmd, score_robust_zfactor] = bootstrapSample(conv_pos75,conv_neg,1000,3);
Z_factor_avg = mean(score_zfactor); ssmd_avg = mean(score_ssmd); robust_Z_factor_avg = mean(score_robust_zfactor);
['Bootstrapped N=3 convolutional Z-factor (theoretical hit) is: ' num2str(Z_factor_avg)]
['Bootstrapped N=3 convolutional Robust Z-factor is (theoretical hit): ' num2str(robust_Z_factor_avg)]
['Bootstrapped N=3 convolutional ssmd_avg (theoretical hit) is: ' num2str(ssmd_avg)]

%% Here let's see how the SSMD increases as we increase the number of bootstraps
score_zfactor = cell(1,5); score_ssmd = score_zfactor; score_robust_zfactor = score_zfactor;
ssmd_plot = zeros(1,5); zfactor_plot = zeros(1,5);
ssmd_std = ssmd_plot; zfactor_std = zfactor_plot;
for i = 1:5
    [score_zfactor{i}, score_ssmd{i}, score_robust_zfactor{i}] = bootstrapSample(conv_pos,conv_neg,1000,i);
    ssmd_plot(i) = mean(score_ssmd{i}); ssmd_std = std(score_ssmd{i});
    zfactor_plot(i) = mean(score_zfactor{i}); zfactor_std = std(score_zfactor{i});
    robust_zfactor_plot(i) = mean(score_robust_zfactor{i}); zfactor_std = std(score_robust_zfactor{i});
end
figure(); plot(ssmd_plot,'b.-');title('SSMD as Samples Increase'); xlabel = ('Number of Averaged Larvae');
ylabel('SSMD*');
figure();plot(zfactor_plot,'b.-');title('Z-factor as Samples Increase'); xlabel = ('Number of Averaged Larvae');
ylabel('Z-factor'); hold on;
;plot(robust_zfactor_plot,'r.-');title('Robust Z-factor as Samples Increase'); xlabel = ('Number of Averaged Larvae');
ylabel('Robust Z-factor'); legend('Z-factor', 'Robust Z-factor', 'Location','Best');

%% Here we perform some chi-squared tests on the categorical data as well
%EX: The round vs. flat bottom wells

% Observed data
n1 = 55; N1 = 80; %These are the round well plates, where n1 = number of good poses and N1 = total number of fish
n2 = 34; N2 = 80; %As above, but now for normal (flat) plates
% Pooled estimate of proportion
p0 = (n1+n2) / (N1+N2)
% Expected counts under H0 (null hypothesis)
n10 = N1 * p0;
n20 = N2 * p0;
% Chi-square test, by hand
observed = [n1 N1-n1 n2 N2-n2];
expected = [n10 N1-n10 n20 N2-n20];
chi2stat = sum((observed-expected).^2 ./ expected)
p = 1 - chi2cdf(chi2stat,1)

%% Here I am going to calculate the number of larvae needed to hit specific screening criterion as the effect size decreases
Z_alpha = 2.807; Z_beta = 1.2816; %These settings are for 10% false negative rate, 0.5% false positive rate
pooled_sd = 0.56911; %from 2016.02.04 Z-factor preselected_recovered.xlsx, the Brain Health Score tab
effect_size = linspace(25,100,16);
samples = zeros(numel(effect_size),1);
control_size = 1.278698+0.80009; %From the same file as above.
for i = 1:numel(samples)
    temp_mod_effect_size = effect_size(i)/100*control_size;
    samples(i) = (2*pooled_sd^2)*(Z_alpha + Z_beta)^2/(temp_mod_effect_size/0.80009)^2;
end
figure();plot(effect_size(4:end),samples(4:end),'b.-');title('Sample size as effect size increases');
ylabel('Number of larvae required');
xlabel('Effect size (%)');