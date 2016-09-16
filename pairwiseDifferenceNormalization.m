function [res_pos, res_neg] = pairwiseDifferenceNormalization(pos, neg)
%This function was written to explicitly work with
%PAPER_z_factor_bootstrapping.m This script will take in a 48 element
%dataset, split into four plates of 12 replicated each, calculate the
%median of the negative controls, and then subtract the median from all the
%data to normalize the data on a plate-by-plate basis. These steps are
%consistent with those in "Illustration of SSMD, z Score, SSMD*, z* Score,
%and t Statistic for Hit Selection in RNAi High-Throughput Screens by
%Xiaohua Douglas Zhang (Journal of Biomolecular Screening, 2011)

pos = reshape(pos,4,12); neg = reshape(neg, 4, 12);
median_array = nanmedian(neg,2); %This is the median of the negative controls;
median_array_large = repmat(median_array,1,12);
res_pos = pos - median_array_large; res_neg = neg - median_array_large;
res_pos = reshape(res_pos,48,1); res_neg = reshape(res_neg,48,1);