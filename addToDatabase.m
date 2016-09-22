function addToDatabase(datablock, outputFolder)
%This function will save a datablock produced by the functon calcSSMD into
%an Excel file that contains data from each plate screened thus far. This
%function first opens the Excel file, checks to see if any plates of the
%same name are already stored inside. If so, it will overwrite the old data
%with the new data. Otherwise it will insert the new datablock into the
%Excel file. This way we have a centralized database that we can reference
%and compare different week's screening results against.

fname = 'CURRENT Consolidated Screen Data.xls'; %Note: you can start a new consolidated database by changing this name.
fullname = fullfile(outputFolder,fname);

%First step is to read the file, we need to check if our current plate has
%any duplicates (and therefore would need to be overwritten)
try
    [num,txt,~] = xlsread(fullname);
    %Let's also copy the old file and save it in case something goes wrong (so
    %we don't lose all our precious data!)
    newname = ['OLD ' fname ' ' date '.xls'];
    copyfile(fullname,fullfile(outputFolder,newname));
    delete(fullname);
    %Unfortunately matlab does a very messy job of reading the Excel files
    %since the text and number elements are separated. Therefore we'll have to
    %manually stitch the original datablock file back together.
    %Fields are {'Plate Quadrant','Tag','Cmpd_ID','Date','SSMD','Brain Health Score','NumObs'};
    datablock_old = cell(size(txt));
    datablock_old(1,:) = txt(1,:);
    datablock_old(2:end,1) = txt(2:end,1); %This is the plate quadrant
    datablock_old(2:end,2) = txt(2:end,2); %This is the Tag
    datablock_old(2:end,3) = txt(2:end,3); %This is the Cmpd_ID
    datablock_old(2:end,4) = txt(2:end,4); %This is the Date
    datablock_old(2:end,5) = num2cell(num(:,1)); %This is the SSMD
    datablock_old(2:end,6) = num2cell(num(:,2)); %This is the BHS
    datablock_old(2:end,7) = num2cell(num(:,3)); %This is the NumObs
    
    %Next step is to search the file to see if the plate in question has been
    %seen yet
    new_plates = unique(datablock(2:end,1));
    old_plates = unique(datablock_old(:,1));
    for i = 1:numel(new_plates)
        temp_plate = new_plates(i); %This means one or more plates are overlapping!
        plt_cmp = sum(strcmp(temp_plate,old_plates)); %See if any of the new plates are found in the old plate file
        if plt_cmp > 0 %A replicate plate exists somewhere within the data file!
            %Now we need to find the corresponding data and remove it!
            rpt_idx = strcmp(datablock_old(:,1),temp_plate); %This is where the repeats occur
            datablock_old(rpt_idx,:) = []; %Delete them!
        end
    end
    
    datablock_new = [datablock_old; datablock(2:end,:)]; %Now let's add the data (we have ensured there are no repeated plates)
    xlswrite(fullname,datablock_new);
    msgbox(['Scores from this plate has been successfully added to the database! You can find it at: ' ...
        fullname]);
catch err
    msgbox('Note: either an error occured, or this is a new consolidated database!');
    %If the file hasn't been created yet, we can just write in the data!
    fname = ['NEW or error ' fname]; fullname = fullfile(outputFolder,fname);
    xlswrite(fullname,datablock);
end