function well_per_comp = simulateScreen
%Probability that fish will DIE (index = number of compound/well)
p = [0.014,0.021 0.032, 0.047, 0.071,0.106,0.159,.239,.357,.536];
num_rep = 10000;
well_per_comp = [0,0,0,0,0,0];
x_axis = [1,2,3,4,5,6,7,8,9,10];
well_per_comp(1) = 1;

arr_10 = zeros(1,num_rep);
for i = 1:num_rep
    arr_10(i) = run_ten(p);
end
figure();hist(arr_10,linspace(1,max(arr_10),max(arr_10)));title('Ten compounds/well');
well_per_comp(10) = mean(arr_10) / 10;

arr_9 = zeros(1,num_rep);
for i = 1:num_rep
    arr_9(i) = run_nine(p);
end
figure();hist(arr_9,linspace(1,max(arr_9),max(arr_9)));title('Nine compounds/well');
well_per_comp(9) = mean(arr_9) / 9;

arr_8 = zeros(1,num_rep);
for i = 1:num_rep
    arr_8(i) = run_eight(p);
end
figure();hist(arr_8,linspace(1,max(arr_8),max(arr_8)));title('Eight compounds/well');
well_per_comp(8) = mean(arr_8) / 8;

arr_7 = zeros(1,num_rep);
for i = 1:num_rep
    arr_7(i) = run_seven(p);
end
figure();hist(arr_7,linspace(1,max(arr_7),max(arr_7)));title('Seven compounds/well');
well_per_comp(7) = mean(arr_7) / 7;

arr_6 = zeros(1,num_rep);
for i = 1:num_rep
    arr_6(i) = run_six(p);
end
figure();hist(arr_6,linspace(1,max(arr_6),max(arr_6)));title('Six compounds/well');
well_per_comp(6) = mean(arr_6) / 6;

arr_five = zeros(1,num_rep);
for i = 1:num_rep
    arr_5(i) = run_five(p);
end
figure();hist(arr_5,linspace(1,max(arr_5),max(arr_5)));title('Five compounds/well');
well_per_comp(5) = mean(arr_5) / 5;

arr_4 = zeros(1,num_rep);
for i = 1:num_rep
    arr_4(i) = run_four(p);
end
figure();hist(arr_4,linspace(1,max(arr_4),max(arr_4)));title('Four compounds/well');
well_per_comp(4) = mean(arr_4) / 4;

arr_3 = zeros(1,num_rep);
for i = 1:num_rep
    arr_3(i) = run_three(p);
end
figure();hist(arr_3,linspace(1,max(arr_3),max(arr_3)));title('Three compounds/well');
well_per_comp(3) = mean(arr_3) / 3;

arr_2 = zeros(1,num_rep);
for i = 1:num_rep
    arr_2(i) = run_two(p);
end
figure();hist(arr_2,linspace(1,max(arr_2),max(arr_2)));title('Two compounds/well');
well_per_comp(2) = mean(arr_2) / 2;

close all;
figure();plot(x_axis, well_per_comp,'b.');title('Optimal compound per well selection');
xlabel('Number of wells/compound');ylabel('Wells needed to screen 1 compound');
x = x_axis; y = well_per_comp; c = cellstr(num2str(well_per_comp'));
dx = 0; dy = 0.05; 
text(x+dx, y+dy, c);
end

%The result returned by each of the below functions is how many wells were
%screened in order to reach a final conclusion
function res = run_ten(p)
num = rand; %If num > p then the fish is alive, otherwise it's dead!
if num > p(10)
    res = 1; %The fish is alive! We can extrapolate results :)
else
    %The fish has died :( Now we have to screen 5 and 5
    temp = run_five(p);
    temp = temp + run_five(p);
    res = temp + 1;
end
end

function res = run_nine(p)
num = rand; %If num > p then the fish is alive, otherwise it's dead!
if num > p(9)
    res = 1; %The fish is alive! We can extrapolate results :)
else
    %The fish has died :( Now we have to screen 5 and 5
    temp = run_four(p);
    temp = temp + run_five(p);
    res = temp + 1;
end
end

function res = run_eight(p)
num = rand; %If num > p then the fish is alive, otherwise it's dead!
if num > p(8)
    res = 1; %The fish is alive! We can extrapolate results :)
else
    %The fish has died :( Now we have to screen 5 and 5
    temp = run_four(p);
    temp = temp + run_four(p);
    res = temp + 1;
end
end

function res = run_seven(p)
num = rand; %If num > p then the fish is alive, otherwise it's dead!
if num > p(7)
    res = 1; %The fish is alive! We can extrapolate results :)
else
    %The fish has died :( Now we have to screen 5 and 5
    temp = run_four(p);
    temp = temp + run_three(p);
    res = temp + 1;
end
end

function res = run_six(p)
num = rand; %If num > p then the fish is alive, otherwise it's dead!
if num > p(6)
    res = 1; %The fish is alive! We can extrapolate results :)
else
    %The fish has died :( Now we have to screen 5 and 5
    temp = run_three(p);
    temp = temp + run_three(p);
    res = temp + 1;
end
end

function res = run_five(p)
num = rand; %If num > p then the fish is alive, otherwise it's dead!
if num > p(5)
    res = 1; %The fish is alive! We can extrapolate results :)
else
    %The fish has died :( Now we have to screen 5 and 5
    temp = run_three(p);
    temp = temp + run_two(p);
    res = temp + 1;
end
end

function res = run_four(p)
num = rand; %If num > p then the fish is alive, otherwise it's dead!
if num > p(4)
    res = 1; %The fish is alive! We can extrapolate results :)
else
    %The fish has died :( Now we have to screen 5 and 5
    temp = run_two(p);
    temp = temp + run_two(p);
    res = temp + 1;
end
end

function res = run_three(p)
num = rand; %If num > p then the fish is alive, otherwise it's dead!
if num > p(3)
    res = 1; %The fish is alive! We can extrapolate results :)
else
    %The fish has died :( Now we have to screen 5 and 5
    temp = run_two(p);
    res = temp + 2; %Add an extra 1 well to account for the fact that we have to image one more (split 2 and 1)
end
end

function res = run_two(p)
num = rand; %If num > p then the fish is alive, otherwise it's dead!
if num > p(2)
    res = 1; %The fish is alive! We can extrapolate results :)
else
    %The fish has died :( Now we have to screen 5 and 5
    res = 2;
end
end
