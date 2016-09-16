function [score_zfactor, score_ssmd, score_zfactor_robust] = bootstrapSample(pos,neg,numBootstrap,numGroup)
%This function exists to estimate the Z' and robust SSMD that will result
%when the given data is averaged over numGroup samples (e.g. 3). It will
%first bootstrap the data numBootstrap times, keep a number of samples that will
%divide evenly into numGroups. It will then group the bootstrapped data
%into groups of size numGroups and then find the corresponding Z'-factor
%and robust SSMD scores. It will then return all the scores.

%First bootstrap all the data
[~,boot_pos] = bootstrp(numBootstrap,[],pos);
[~,boot_neg] = bootstrp(numBootstrap,[],neg);

%Now we keep only data that will fit into numGroup groups
pos_idx = floor(size(boot_pos,1)/numGroup);
neg_idx = floor(size(boot_neg,1)/numGroup);

score_zfactor = zeros(1,numBootstrap); score_ssmd = score_zfactor;
score_zfactor_robust = score_zfactor;
%Now we shall iterate through all the bootstrap samples and calculate a
%Z'-factor and SSMD score for each bootstrapped sample
for i = 1:numBootstrap
    pos_temp = pos(boot_pos(1:pos_idx*numGroup,i));
    neg_temp = neg(boot_neg(1:neg_idx*numGroup,i));
    %Reshape into appropriately sized groups
    pos_temp = reshape(pos_temp,numGroup,pos_idx);
    neg_temp = reshape(neg_temp,numGroup,neg_idx);
    %Now average it out
    if numGroup > 1
        pos_avg = mean(pos_temp); neg_avg = mean(neg_temp);
    else
        pos_avg = pos_temp; neg_avg = neg_temp;
    end
    %Finally let's calculate the overall Z'-factor and SSMD for this
    %particular bootstrapped sample.
    [score_zfactor(i), score_zfactor_robust(i), score_ssmd(i)] = calcScreenQuality(pos_avg, neg_avg);
end