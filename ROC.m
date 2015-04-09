load ('2015.04.07 ratiometric ROC.mat'); 

thresh = 0:0.25:9;
TP_arr = zeros(1,length(thresh));
FP_arr = zeros(1,length(thresh));

for i = 1:length(thresh)
    thresh_temp = thresh(i);
    TP_temp = 0;
    FP_temp = 0;
    for j = 1:length(good)
        if good(j) > thresh_temp
            TP_temp = TP_temp + 1;
        end
    end
    
    for k = 1:length(bad)
        if bad(k) > thresh_temp
            FP_temp = FP_temp + 1;
        end
    end
    
    TP_arr(i) = TP_temp;
    FP_arr(i) = FP_temp;
end

figure();plot(FP_arr,TP_arr,'b.');xlabel('True Positive Rate');
ylabel('False Positive Rate');title('ROC Curve for Inner/Outer Neuron Feature');
x = FP_arr; y = TP_arr; c = cellstr(num2str(thresh'));
dx = 0.5; dy = 0.05; 
text(x+dx, y+dy, c);

%Now print out the ones that didn't make the cut!
dmso_ratio = dmso_inner ./ dmso_outer;
dmso_ratio(dmso_ratio == Inf) = 100;dmso_ratio(isnan(dmso_ratio) == 1) = 0;
mtz_ratio = mtz_inner ./ mtz_outer;
mtz_ratio(mtz_ratio == Inf) = 100;mtz_ratio(isnan(mtz_ratio) == 1) = 0;

dmso_inner(dmso_ratio < 2) = 0;
mtz_inner(mtz_ratio < 2) = 0;