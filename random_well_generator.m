num_wells = 17; %Number of wells to randomly generate
well_number = nan(1,num_wells); %This stores the raw well number in an array (e.g. well 14 is B - 2

for i = 1:num_wells
    temp = 1 + floor(rand() * 96);
    while any(well_number == temp)
        temp = 1 + floor(rand() * 96);
    end
    well_number(i) = temp;
end

well_number = sort(well_number);
well_name = [];
letters = {'A - ','B - ','C - ','D - ','E - ','F - ','G - ','H - '};

for i = 1:num_wells
    temp_let = floor(well_number(i)/12);
    well_letter = letters(min(temp_let + 1,8));
    num = rem(well_number(i),12) + 1;
    well_name = [well_name; strcat(well_letter,num2str(num))];
end

well_name = cellstr(well_name)