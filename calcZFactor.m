function [z_factor, ssmd] res = calcScreenQuality(pos, neg)

'Z-factor is: '
res = 1 - (3*(std(pos) + std(neg))) / abs(mean(pos) - mean(neg));