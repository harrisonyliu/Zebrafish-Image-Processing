% close all;
% avg = [3.0	6.4	5.0	3.0	9.1	11.2	7.4	21.5	21.7	12.0];
% x = [1:10];
% CI = [1.6	2.5	1.7	3.5	4.3	6.1	5.7	17.1	6.4	1.7];
% 
% y1 = [2
% 2
% 5
% 1
% 5]';
% 
% y2 =[11
% 7
% 4
% 4
% 6]';
% 
% y3 = [9
% 6
% 8
% 5
% 2
% 3
% 3
% 4];
% 
% y4 = [1
% 3
% 0
% 8];
% 
% y5 = [6
% 14
% 11
% 4
% 15
% 0
% 14];
% 
% y6 = [20
% 16
% 0
% 12
% 4
% 15];
% 
% y7 = [3
% 14
% 2
% 21
% 3
% 0
% 9];
% 
% y8 = [35
% 37
% 1
% 13];
% 
% y9 = [24
% 7
% 18
% 33
% 25
% 23];
% 
% y10 = [11
% 10
% 16
% 10
% 12
% 13];
% 
% cutoff = avg(end) - CI(end);
% 
% chart = bar(x,avg);
% hold on;
% ehandle = errorbar(x,avg,CI,'.');
% title('Mtz Gradient Experiment');
% ylabel('Neuron Count'); xlabel('Mtz Concentration');
% axis([0.5 10.5 0 40]);
% set(gca,'XTickLabel',{'9mM', '4.5mM', '2.25mM', '1.125mM', '560uM', '280uM', '140uM', '70uM', '35uM', '0uM'})
% plot([0 11], [cutoff cutoff], 'b--');
% set(chart,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9]);
% set(ehandle,'Color','black');
% 
% for i = 1:10
%     varname = ['y' num2str(i)];
%     arr_length = length(eval(varname)); 
%     plot(ones(1,arr_length)*i + linspace(-0.1,0.1,arr_length), eval(varname),'rx');
% end

close all;
avg = [0.0956	0.1020	0.1015	0.0950	0.1403	0.1618	0.1313	0.3787	0.4652	0.1911];
x = [1:10];
CI = [0.0273	0.0155	0.0112	0.0537	0.0372	0.0463	0.0458	0.3234	0.1661	0.0156];

y1 = [0.0657
0.0872
0.1314
0.0683
0.1253]';

y2 =[0.1157
0.1256
0.0932
0.0914
0.0842]';

y3 = [0.1058
0.0928
0.1138
0.1257
0.0765
0.0924
0.0903
0.114549];

y4 = [0.0495
0.0733
0.0829
0.1745];

y5 = [0.1070
0.1015
0.1526
0.1079
0.2362
0.1058
0.1713];

y6 = [0.1819
0.2277
0.0738
0.1947
0.1098
0.1830];

y7 = [0.1048
0.1614
0.0857
0.1439
0.2529
0.0871
0.0831];

y8 = [0.7798
0.5172
0.0864
0.1313];

y9 = [0.6730
0.1591
0.4536
0.2484
0.7122
0.5448];

y10 = [0.1865
0.1747
0.1877
0.1712
0.2295
0.1972];

cutoff = avg(end) - CI(end);

chart = bar(x,avg);
hold on;
ehandle = errorbar(x,avg,CI,'.');
title('Mtz Gradient Experiment');
ylabel('Convolutional Measure (a.u.)'); xlabel('Mtz Concentration');
axis([0.5 10.5 0 .8]);
set(gca,'XTickLabel',{'9mM', '4.5mM', '2.25mM', '1.125mM', '560uM', '280uM', '140uM', '70uM', '35uM', '0uM'})
plot([0 11], [cutoff cutoff], 'b--');
set(chart,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9]);
set(ehandle,'Color','black');

for i = 1:10
    varname = ['y' num2str(i)];
    arr_length = length(eval(varname));
    plot(ones(1,arr_length)*i + linspace(-0.1,0.1,arr_length), eval(varname),'rx');
end

