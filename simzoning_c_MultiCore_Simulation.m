%% run simulations using energyPLus and multicore processors 
%inputs: .idfs files, weather files (.EPW)

% Load imput variables
load ImputVariables.mat
% open the Eplus folder
cd (EPlusPath)
% defining the folder to place simulation outputs
destination=SimresultsOUTPUTpath;
% copy the RunDirMulti.bat to the simulation folder
copyfile ("RunDirMulti.bat",destination,'f')
cd (destination)
%% Reading and editing the .bat file
file_name='RunDirMulti.bat';
% Read the file
file_id=fopen(file_name,'r');
text_cell=cell(1);
while 1
    text_line_read=fgetl(file_id);
    if text_line_read == -1
        break
    else
        text_cell(end,1)=cellstr(text_line_read);
        text_cell(end+1,1)=cell(1);
    end
end
fclose(file_id);

% Searching and writting the required information in the RunDirMulti.bat file to run simulations with
% several weather files and multiple processors

% Writting the main EnergyPlus Directory
[SetmainDIr,~]=find(~cellfun(@isempty, regexp(text_cell,'SET maindir=','ignorecase')));
text_cell{SetmainDIr(1),1}=char(strcat('SET maindir=',{' '},EPlusPath));
% Writting a tag to substitute the weather file in each run
[SetmainDIr,~]=find(~cellfun(@isempty, regexp(text_cell,'SET weather=','ignorecase')));
text_cell{SetmainDIr(1),1}='SET weather= EPWfile_to_be_substituted';
% Writting the number of processors used for parallel simulation
[SetmainDIr,~]=find(~cellfun(@isempty, regexp(text_cell,'SET numProc=','ignorecase')));
expre=char(strcat('SET numProc=',num2str(Num_of_cores)));
text_cell{SetmainDIr(1),1}=expre;
% updating and saving the text file
file_id=fopen(file_name,'w');
for i=1:length(text_cell)
    fprintf(file_id,'%s\n', text_cell{i});
end
fclose(file_id);

cd ..
cd (mainProjectFolder)

cd Weatherfiles
% Copying temporarily selected Weather files for simulation from the simzoning/weatherfiles folder to the Eplus Weather Folder
for j=1:numel(Epws_torunSIm)
    file=Epws_torunSIm{j};
copyfile(file, WeatherPath,'f')
end
cd(mainProjectFolder)
%% Creation of .RVI (Report Variable Input) file to obtain custom output files (.CSV) from EnergyPlus

% Some performance indicators adopted for climatic zoning require Post-processing. (e.g. Discomfort hours and Mould Growth Risk)
% This script uses a .RVI file to obtaining custom output files (.CSV) from
% EnergyPlus.

% Variables needed to calculate selected Performance indicators for each building zone defined by the user.
B={',Zone Operative Temperature',',Zone Air Relative Humidity',',Zone Thermal Comfort ASHRAE 55 Adaptive Model Temperature'};
A={'eplusout.eso';'eplusout.csv';'Site Outdoor Air Drybulb Temperature'};
% Schedules  
for j=1:numel(Building_Zones_occupation)
    schedule_r{j}=char(strcat(Building_Zones_occupation{j,1},',Schedule Value' ));
end
% Vertical concatenation
C=vertcat(schedule_r{:});

% Idf files directory
source = BuildingIDFPath;
% Climatic variables of each building zone
v=1;
for i=1:numel(BuildingZones_considered_for_PerformanceIndex_calculation)
    for r=1:numel(B)
        Var{v}=char(strcat(BuildingZones_considered_for_PerformanceIndex_calculation{i},B{r}));
        v=v+1;
    end
end
% List of Idf files
idffiles=dir(fullfile((BuildingIDFPath),'\*.idf'));
for k=1:length(idffiles)
    baseFileName=idffiles(k).name;
    idfFiles{k} = baseFileName(1:end-4);
end
% Writting a RVI file for each model
cd (BuildingIDFPath)
for i=1:numel(idffiles)
    txtFileName = fullfile((BuildingIDFPath), sprintf([idfFiles{i},'.rvi']));
    txtFileID = fopen(txtFileName, 'w');
    fprintf(txtFileID, '%s\n', A{:});
    fprintf(txtFileID, '%s\n', schedule_r{:});
    fprintf(txtFileID, '%s\n', Var{:});
    fprintf(txtFileID, '%s\n', '0');
    fclose(txtFileID);
end

% Moving .idf files and .rvi files to the simulation folder
filesrvi=dir(fullfile((BuildingIDFPath),'\*.rvi'));
filesidf=dir(fullfile((BuildingIDFPath),'\*.idf'));
destination=SimresultsOUTPUTpath;

% Folders of simulations
cd(SimresultsOUTPUTpath)
if jmax>numel(Epws_torunSIm)
    jmax=numel(Epws_torunSIm);
end
% weather files defined by the user in the input file
for j=jmin:jmax 
    % A folder for each climate file is created with the name of the
    % weather file
    folderclima=char(strcat('mkdir Clima',Epws_torunSIm{j}(1:end-4)));
    if not(isfolder( folderclima))
        dos(folderclima);
    end
    for e=1:length(filesidf)
        fileidfname=char(strcat(source,filesidf(e).name));
        rvifilename=char(strcat(source,filesrvi(e).name));
        %IDF and .RVI files are copied in the simulation folder of each climate
        copyfile(rvifilename, destination,'f')
        copyfile(fileidfname, destination,'f')
    end

    cd (SimresultsOUTPUTpath)
    % the weather file to run simulation is identified and written in the batch file to run parallel simulations
    clima=((Epws_torunSIm{j}(1:end-4)));
    fin = fopen('RunDirMulti.bat');
    fout = fopen('RunDirMulti2.bat','wt');

    while ~feof(fin)
        s = fgetl(fin);
        % The weather file is written in the batch file subtituting the expression edited by the user 'EPWfile_to_be_substituted' in the RunDirMulti2.bat file
        s = strrep(s, 'EPWfile_to_be_substituted', clima);
%         % The number of processors to run multicore simulations is written in the batch file subtituting the expression edited by the user 'Num_of_cores' in the RunDirMulti2.bat file
        fprintf(fout,'%s\n',s);
        disp(s);
    end
    fclose(fin);
    fclose(fout);
    fclose('all');
%     %%
    pdest=char(strcat('Clima',Epws_torunSIm{j}(1:end-4)));
    movefile('RunDirMulti2.bat',pdest);% the bacth file is moved into the folder where simulations take place
    movefile('*.idf', pdest);% .IDfs files are moved to the same folder
    movefile('*.rvi', pdest);% .RVI files are moved to the same folder
    cd(pdest)
  

    dos('RunDirMulti2.bat')% parallel simulations are executed
    t = tic();
    while toc(t) < 5 % this part of the routine checks every certain period of time if the number of outputs is equal to the number of IDF files
        pause(1);
        S= dir(fullfile('*.audit'));
        audit=numel(S);
        P= dir(fullfile('*.idf'));
        idff=numel(P);
        while audit~= idff
            S= dir(fullfile('*.audit'));
            audit=numel(S);
            P= dir(fullfile('*.idf'));
            idff=numel(P);
            pause(0.1)
            if audit==idff
                % Clear files
                delete('*.html','*.tab','*.eso','*.dxf','*.shd','*.mtr','*.mtd','*.eio','*.bnd','*.svg','*.err','*.audit','*.rvaudit','*.rdd','*.bat','*.mdd','*.bat','*.xml','*.expidf','*.idf','*.rvi')
                rmdir tempsim* s % unused files and folders are deleted
            end
        end
        cd ..
    end
   
   
end
fclose ("all")
%Delete weather files in the Eplus Weather Folder
cd(WeatherPath)
for j=1:numel(filesepw)
    file=filesepw(j).name;
 
delete(file)
end
cd(mainProjectFolder)


