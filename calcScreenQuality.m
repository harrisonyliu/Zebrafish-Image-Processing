function [z_factor, robust_z_factor, ssmd] = calcScreenQuality(pos, neg)

z_factor = 1 - (3*(std(pos) + std(neg))) / abs(mean(pos) - mean(neg));
robust_z_factor = 1 - (3*(mad(pos,1) + mad(neg,1))) / abs(median(pos) - median(neg));

med_pos = median(pos); med_neg = median(neg);
pos_mad = median(abs(pos - med_pos)); neg_mad = median(abs(neg - med_neg));
ssmd = (med_pos - med_neg) / (1.4826 * sqrt(pos_mad^2 + neg_mad^2));