function [w,b,x] = svm_param_calc(meas) 
load('SVM_model_withconv');

%Now before we calculate anything we need to rescale all the data
shift = svmModel.ScaleData.shift; scale = svmModel.ScaleData.scaleFactor;
shift = repmat(shift,size(meas,1),1);
scale = repmat(scale,size(meas,1),1);
x = (meas + shift) .* scale;
sv = x(svmModel.SupportVectorIndices,:);
alpha = svmModel.Alpha;
y = sign(alpha);
lambda = repmat(alpha,1,size(sv,2));
w = sum(sv .* lambda);

b_vec = zeros(1,size(sv,1));
for i = 1:numel(b_vec)
    b_vec(i) = y(i) - dot(w,sv(i,:));
end
b = mean(b_vec);

% %Now to calculate the slope and intercept (only for verify that things are
% %working correctly)
% m = -w(1)/w(2);
% intercept = -b/w(2);
% label = sign(grp);
% x_axis = [-5, 5];
% y1 = m*x_axis(1) + intercept;
% y2 = m*x_axis(2) + intercept;
% figure();gscatter(x(:,1),x(:,2),label);
% xlim = get(gca,'xlim');ylim = get(gca,'ylim');
% hold on;plot(x_axis,[y1 y2]);
% axis([xlim ylim]);title('Manually calculated SVM line');
% 
% % Last sanity check, let's classify everything and see if the groups agree
% class_vec = zeros(size(x,1),1);
% for i = 1:size(x,1)
%     class_vec(i) = sign(dot(w,x(i,:))+b);
% end
% figure();gscatter(x(:,1),x(:,2),class_vec);
% xlim = get(gca,'xlim');ylim = get(gca,'ylim');
% hold on;plot(x_axis,[y1 y2]);
% axis([xlim ylim]);title('Manually calculated SVM classification (Verification)');
    


