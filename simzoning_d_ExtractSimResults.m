


%This script extracts simulation results from EnergyPlus simulation output files
% in csv format.
% This script was tested to extract/calculate 5 performance indicators:
%% Models with HVAC (Using annual data contained in  *ModelName*Table.csv files)
% 1) Annual Cooling load per area
% 2) Annual Heating load per area
%% Natural ventilated models (Using hourly data contained in *ModelName*.csv files )
% 3) Mould Growth Risk in (Natural Ventilated model) based on %Clarke, J. A., Johnstone, C. M., Kelly, N. J., Mclean, R. C., & Nakhi, A. E. (1997). Development of a Simulation Tool for Mould Growth Prediction in Buildings. Proceedings of the Fifth International IBPSA Conference, August, 343–349.
% 4) Discomfort hours for cold (adaptive thermal comfort model) (Natural Ventilated model)
% 5) Overheating hours (adaptive thermal comfort model) (Natural Ventilated model)

%% REQUIRED
% - list of performance indicators e.g.   "PerformanceIndicator":["Cooling", "Heating", "MGR", "Overheating","Cold discomfort"],
% - Conditioning_type_tag to differentiate between natural ventilated models and models with active cooling and heating, which is a prefix of the IDF name  (defined by the user) e.g.  "Conditioning_type_tag":["HVAC","NV"],

% - To extract annual cooling and heating load.
% a)The number of rows and columns to extract annual cooling, annual
% heating from the *Table.csv output file
% EXAMPLE IN THE INPUT .ZON FILE     "Row_heating_cooling":["49","50"],
% "Column_heating_cooling":["3","2"],

% - To calculate Mould Growth Risk:
% a) Name of building zones to be considered (defined by the user)  e.g.  "Building_Zones_considered_for_PerformanceIndex_calculation":["R1","R2","LIVINGKITCH"],
% b) Occupancy schedules for each building (defined by the user) zone e.g.  "Building_Zones_occupation_Schedule":["ROOM_VENTILATION_SCHEDULE","ROOM_VENTILATION_SCHEDULE","LIVING OCCUPANCY SCHEDULE"],
% c) Zone OperativeTemperature (hourly data)for each building zone  %
% (default output variable defined in the RVI file)
% d) Zone Air Relative Humidity (hourly data) for each building zone  %
% (default output variable defined in the RVI file)

% - to calculate Discomfort hours:
% a) Zone OperativeTemperature (hourly data)(default output variable defined in the RVI file)
% b) Zone Thermal Comfort ASHRAE 55 Adaptive Model Temperature (hourly
% data) (if calculated in the model, this variable is included in the RVI file)

% This script also extracts, conditioned area, the Weather file used for
% simulation, and coordinates (Latitude and longitude).

% Outputs are store in .mat files and csv files

clearvars
load ImputVariables
% Loading list of weather files used in the process
load Epws_torunSIm.mat
% creation of a folder to store aggregated simulation results.
mkdir simresults
% Get a list of all files and folders
files=dir(SimresultsOUTPUTpath);
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Sorting files
subFolders = natsortfiles(files(dirFlags));
subFolders(arrayfun(@isempty,subFolders)) = [];
% erase data with no information from the list
subFolders(1:2) = [];
% List of EPWS used in a particular case study
ListofEPW=cellfun(@(x) x(1:end-4), Epws_torunSIm,'un', 0);
subFoldersi=struct2table(subFolders);
subFoldersi=cellfun(@(x) x(6:end), subFoldersi.name,'un', 0);

idx=ismember(subFoldersi,ListofEPW);
if readallSimulationsfolders==1
    % When all folders are read
    subFolders=subFolders;
else
    % When only certain folders are read
    subFolders=subFolders(idx);
end

% Simulation folder
cd (SimresultsOUTPUTpath)
cd (subFolders(1).name);
%directory of simulation results, assuming that the same models were
%simulated in all the climates
allfiles=dir(fullfile('*Table.csv'));
allfiles=natsortfiles(allfiles);% a third party function for natural-order sort
% number of idf files
mmax=length(allfiles);
% identification of Conditioned models (For Performance indicators 1 and 2)
% and Natural ventilated models (For performance indicators 3,4 and 5)
idfs_names=struct2table(allfiles);
% Identification of models with HVAC systems
HVACModelIndex = ~cellfun(@isempty, regexp(idfs_names.name,Conditioning_type_tag{1},'ignorecase'));
% Identification of models simulated with natural ventilation

NVModelIndex = ~cellfun(@isempty,regexp(idfs_names.name,Conditioning_type_tag{2},'ignorecase'));


%% This part of the script extracts conditioned Building area to calculate Energy demand per square meter.
fprintf('Getting area of the model \n');
for m=1:mmax
    models_Name{m}=allfiles(m).name(1:end-9);
    if HVACModelIndex(m)==1
        fin=fopen(allfiles(m).name);
        clear acharlinha;
        counter2=0;
        while ~feof(fin)
            s = fgetl(fin);
            if counter2==0
                acharlinha=regexp(s,'Net Conditioned Building Area'); %FInd the line contaning Net Conditioned Building Area
                if isempty(acharlinha)==0
                    linhaendfacility=s;
                    [C0,matches0] = strsplit(linhaendfacility,{','});
                    Areaf=C0{3};
                    Areacondit(m)= str2double( Areaf); % Conditioned area needed to calculate energy use per m2
                end
            end
        end
    end
    fclose('all');
end

%% Extraction of Cooling and Heating annual load
fprintf('Extracting annual values of cooling and heating \n')
cd ..
% Loop of climates
for e=1:numel(subFolders)
    cd (subFolders(e).name)
    % Loop of models
    for m=1:mmax
        Heatinga(e,m)=csvread(allfiles(m).name,str2num(Row_heating_cooling{1}),str2num(Column_heating_cooling{1}),[str2num(Row_heating_cooling{1}),str2num(Column_heating_cooling{1}),str2num(Row_heating_cooling{1}),str2num(Column_heating_cooling{1})]);
        Coolinga(e,m)=csvread(allfiles(m).name,str2num(Row_heating_cooling{2}),str2num(Column_heating_cooling{2}),[str2num(Row_heating_cooling{2}),str2num(Column_heating_cooling{2}),str2num(Row_heating_cooling{2}),str2num(Column_heating_cooling{2})]);
        Cooling(e,m)=Coolinga(e,m)/Areacondit(1);
        Heating(e,m)=Heatinga(e,m)/Areacondit(1);
    end
    cd ..
end
%% This part of the code extracts the weather file name of each simulation output.
% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 2);
% Specify range and delimiter
opts.DataLines = [str2num(Line_EPW{1}) str2num(Line_EPW{2})];
opts.Delimiter = ",";
% Specify column names and types
opts.VariableNames = ["Var1", "EnergyPlus"];
opts.SelectedVariableNames = "EnergyPlus";
opts.VariableTypes = ["string", "string"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
opts = setvaropts(opts, ["Var1", "EnergyPlus"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "EnergyPlus"], "EmptyFieldRule", "auto");
fprintf('Extracting weather files used for each model \n');
for e=1:numel(subFolders)
    cd (subFolders(e).name)
    for m=1
        NameofEPW{e,:} = readtable(allfiles(m).name,opts);
    end
    fclose('all');
    cd ..
end
clear opts
ListofEPW=cellfun(@(x) table2cell(x),NameofEPW);
%% Lat, long and alt obtention from each output file.
% loop of climates
for e=1:numel(subFolders)
    cd (subFolders(e).name)
    % Loop of models
    for m=1:mmax
        fin=fopen(allfiles(m).name);
        clear line;
        counter1=0;
        while ~feof(fin)
            s = fgetl(fin);
            if counter1==0
                line=regexp(s,'Program Version and Build'); %eFInd the line contaning the expression "Program Version and Build"
                if isempty(line)==0
                    linef=s;
                    counter1=1;
                    while counter1<7
                        s = fgetl(fin);
                        counter1=counter1+1;
                        if counter1==4
                            line_latitude=s;
                            Templat=line_latitude(16:end);
                            v=strsplit(line_latitude,',');
                            Lat(e,m)=str2double(v{3});
                        end
                        if counter1==5
                            line_longitude=s;
                            v2=strsplit(line_longitude,',');
                            Long(e,m)=str2double(v2{3});
                        end
                        if counter1==6
                            line_altitude=s;
                            v2=strsplit(line_altitude,',');
                            Alt(e,m)=str2double(v2{3});
                        end
                    end
                end
            end

        end
        %% Overheating, Cold discomfort and MGR calculation
        % Reading .csv files contaning hourly data required to calculate Mould Growth Risk for occupied hours and Thermal comfort for occupied hours.
        filename=char(strcat(allfiles(m).name(1:end-9),'.csv'));
        % Only calculted for natural ventilated models
        if NVModelIndex(m)==1
            opts=detectImportOptions( filename );
            % Import the data
            RU=readtable(filename, opts);
            % clean data
            RU=rmmissing(RU);
            % avoid warning messages
            id='MATLAB:table:ModifiedAndSavedVarnames';
            warning('off',id);
            % Finding columns containing Relative Humidity outputs
            RU_Index=~cellfun(@isempty, regexp(RU.Properties.VariableNames,'RelativeHumidity','ignorecase'));
            RU_SelectedZones=RU(:,RU_Index);
            % Relative humidity of each selected zone (defined by the user in the RVI file/input data file) used to calculate MGR
            ru_m=table2array(RU_SelectedZones);
            % Finding columns containing Operative temperature
            Optemp_Index=~cellfun(@isempty, regexp(RU.Properties.VariableNames,'OperativeTemp','ignorecase'));
            %Matrix containing Operative temperature for each selected zone
            %(defined by the user in the RVI file/input data file) used to
            %Operative temperature for each building Zone
            Optemp_SelectedZones=RU(:,Optemp_Index);
            % Finding the column of Comfort temperature
            ConfortTemp_Index=~cellfun(@isempty, regexp(RU.Properties.VariableNames,'AdaptiveModelTemperature','ignorecase'));
            Comforttemp=RU(:, ConfortTemp_Index);

            for p=1:numel(BuildingZones_considered_for_PerformanceIndex_calculation)
                % it match the schedule of each zone with the corresponding
                % Operative temperature and Relative Humidity
                pattern = Building_Zones_occupation{p};
                Occupation_Index_rooms=~cellfun(@isempty, regexp(RU.Properties.VariableNames,pattern,'ignorecase'));
                RoomIndex=logical(table2array(RU(:,Occupation_Index_rooms)));%occupied hours in rooms
                % Operative temperature
                Top=table2array(Optemp_SelectedZones);
                ru=(ru_m(RoomIndex,p));
                t=Top(RoomIndex,p);
                OccupiedHours=length(t)/100;
                % Range of thermal comfort considering 80% acceptability limits
                % (ASHRAE55 Adaptive comfort model)
                if sum(ConfortTemp_Index)>0
                    Tmax_Conf = table2array(Comforttemp(RoomIndex,1))+3.5;
                    Tmin_Conf=table2array(Comforttemp( RoomIndex,1))-3.5;
                    % Discomfort hours for occuppied hours
                    Overheating(:,p)=(sum(t>Tmax_Conf))/OccupiedHours;
                    ColdDiscom(:,p)=(sum(t<Tmin_Conf))/OccupiedHours;
                end
                %  Mould Growth Risk calculation for each zone
                if  ~isempty(ru_m)
                    rulimit=arrayfun(@(t) 0.0001*t^3+0.0219*t^2-1.2649*t+94.871, t); % %Clarke, J. A., Johnstone, C. M., Kelly, N. J., Mclean, R. C., & Nakhi, A. E. (1997). Development of a Simulation Tool for Mould Growth Prediction in Buildings. Proceedings of the Fifth International IBPSA Conference, August, 343–349.
                    MGR(:,p)=sum(ru>rulimit)/numel(t);
                end
                MouldRisk(e,m)=mean(MGR,'omitnan');
                % Meand values of discomfort hours for each model "m" and
                % climate "e"
                if sum(ConfortTemp_Index)>0
                    ColdDiscom_M(e,m)=mean(ColdDiscom,'omitnan');
                    Overheating_M(e,m)=mean(Overheating,'omitnan');
                end

                %%
            end
        end
        fclose('all');
    end
    close all force
    cd ..
    clear fin
    fclose('all');
end

%% Performance indicators matrix
Cooling_Matrix=Cooling(:,HVACModelIndex);
Heating_Matrix=Heating(:,HVACModelIndex);
PerformanceMatr{1}=Cooling(:,HVACModelIndex);
PerformanceMatr{2}=Heating(:,HVACModelIndex);
if  exist('MGR', 'var')
    MouldRisk=MouldRisk*100;
    MGR_Matrix=MouldRisk(:,NVModelIndex);
    PerformanceMatr{3}=MouldRisk(:,NVModelIndex);
    fprintf('Mould growth risk hours successfully calculated \n');
end
if exist('ConfortTemp_Index', 'var') && sum(ConfortTemp_Index)>0
    Colddiscomf_Matrix=ColdDiscom_M(:,NVModelIndex);
    Overheating_Matrix=Overheating_M(:,NVModelIndex);
    PerformanceMatr{4}=Overheating_Matrix;
    PerformanceMatr{5}=Colddiscomf_Matrix;
    fprintf('Discomfort hours successfully calculated \n');
end

% Defining the folder to store results
destination=Aggregated_Simesults_Path;
ID=(1:numel(subFolders))';
ID=table(ID);
cd(mainProjectFolder)
%% Writting matrix with aggregated results in csv format and .mat format for each individual model and for all models simultaneously.
for j=1:sum(HVACModelIndex)
    % Name of the csv file for each model
    Matrix_modelsName=char(strcat('Perf_',num2str(j),'.csv'));
    for p=1:numel(PerformanceIndicator)
        Perfm(:,p)=PerformanceMatr{p}(:,j);
    end
    % Matrix for each model
    mat=[Lat(:,j),Long(:,j),Alt(:,j),Perfm];
    matx=array2table(mat,'VariableNames',[{'LAT'},{'LON'},{'ALT'},PerformanceIndicator(:)']);
    % Name of weather files
    ListofEPW1=cell2table(ListofEPW);
    matx=[ID,ListofEPW1(:,1),matx];
    % Name of the columns
    VarNamep=strcat(PerformanceIndicator(:)','_',models_Name(j));
    % Saving individual models outputs in a cell array
    perf{j}=Perfm;
    if j==1
        Tbl=array2table(perf{1},'VariableNames',{VarNamep{:}});
    else
        Tbl2=array2table(perf{j},'VariableNames',{VarNamep{:}});
        % Building a matrix with all models results
        Tbl= [ Tbl,Tbl2];
    end
    %  Data stored in .csv format: Lat, lon, alt and performance (a matrix per model for MPMA calculation using the Bin method)
    writetable(matx,Matrix_modelsName)
    movefile (Matrix_modelsName, destination,'f')
    expresion=char(strcat('Aggregated Simulation results per model saved:',num2str(j),' \n'));
    fprintf(expresion)
end


%  Data stored in a .mat format: Alt, lat, lon and performance of all models (For clustering and interpolation using the Alt lat lon method)
latlongalt=[Alt(:,1), Lat(:,1), Long(:,1)];
LatlongAlt=array2table(latlongalt,'VariableNames',{'ALT','LAT','LON'});
Table4cluster=[ListofEPW1(:,1),LatlongAlt,Tbl];
% Data stored in .csv format: Lat, lon, alt and performance for ANN interpolation
latlongalt2=[ Lat(:,1), Long(:,1),Alt(:,1)];
LatlongAlt2=array2table(latlongalt2,'VariableNames',{'LAT','LON','ALT'});
Table4cluster2=[ListofEPW1(:,1),LatlongAlt2,Tbl];
cd (mainProjectFolder)
cd simresults\
Aggregatesimmresults=char(strcat('PIs',WeatherSource,'.mat'));
save(Aggregatesimmresults,'Table4cluster',"models_Name");
cd (mainProjectFolder)
writetable(Table4cluster2,'Simresults.csv');
% Writting table with weather files(For report)
format shortg
% Data is rounded
matx.(3)=round(matx.(3),1);
matx.(4)=round(matx.(4),1);
weatherfilestable=matx(:,1:4);
weatherfilestable.ID=categorical(weatherfilestable.ID);
save ('weatherfilestable','weatherfilestable')

%%  Performance map of a random model for quality control

cd (AreaofStudypath)
% Reads the shape file
S=shaperead(ShapeFileName_AreaofStudy);
% Shape file coordinates
polygon1_long = S(1).X;     % it finds all the X-Coordinates of points in polygon number one
polygon1_lat= S(1).Y;   % it finds all the Y-Coordinates of points in polygon number one

for j=1:numel(PerformanceIndicator)
    f1 = figure('visible','off');
    geoplot(polygon1_lat,polygon1_long,'k:','LineWidth',1.5,'DisplayName','Boundaries of the area of study')
    hold on
    geoscatter(matx.LAT,matx.LON,sizeofpoints,matx.(PerformanceIndicator{j}),'filled','DisplayName','Simulation results for selected locations')
    hold on
    colorbar
    legend1 = legend;
    set(legend1,'Interpreter','none','FontSize',LabelFontSize);
    Ylabel=char(strcat(PerformanceIndicator{j},PerformanceIndicator_Units{j}));
    ylabel(colorbar,Ylabel,'FontSize',LabelFontSize);
    geobasemap('topographic');
    set(gcf, 'Position', get(0, 'Screensize'));
    NameofFig=char(strcat(PerformanceIndicator{j}, {' '},'Performance map of a ramdom model'));
    title(NameofFig,FontSize=TitlefontSize)
    cd (mainProjectFolder)
    cd (OutputFolderFigures_QualityControl)
    print(NameofFig, '-dpng', '-r0')
    close all force
end
fprintf('Performance maps for quality control saved \n');
cd (mainProjectFolder)



%%
%%   % % % % % % % % % % third_party local function
%% NatsortFunction
function [Y,ndx,dbg] = natsortfiles(X,rgx,varargin)
% Natural-order / alphanumeric sort of filenames or foldernames.

% See also SORT NATSORT NATSORTROWS DIR FILEPARTS FULLFILE NEXTNAME CELLSTR REGEXP IREGEXP SSCANF

%% Input Wrangling %%
%
fun = @(c)cellfun('isclass',c,'char') & cellfun('size',c,1)<2 & cellfun('ndims',c)<3;
%
if isstruct(X)
    assert(isfield(X,'name'),...
        'SC:natsortfiles:X:StructMissingNameField',...
        'If first input <X> is a struct then it must have field <name>.')
    nmx = {X.name};
    assert(all(fun(nmx)),...
        'SC:natsortfiles:X:NameFieldInvalidType',...
        'First input <X> field <name> must contain only character row vectors.')
    [fpt,fnm,fxt] = cellfun(@fileparts, nmx, 'UniformOutput',false);
    if isfield(X,'folder')
        fpt = {X.folder};
        assert(all(fun(fpt)),...
            'SC:natsortfiles:X:FolderFieldInvalidType',...
            'First input <X> field <folder> must contain only character row vectors.')
    end
elseif iscell(X)
    assert(all(fun(X(:))),...
        'SC:natsortfiles:X:CellContentInvalidType',...
        'First input <X> cell array must contain only character row vectors.')
    [fpt,fnm,fxt] = cellfun(@fileparts, X(:), 'UniformOutput',false);
    nmx = strcat(fnm,fxt);
elseif ischar(X)
    [fpt,fnm,fxt] = cellfun(@fileparts, cellstr(X), 'UniformOutput',false);
    nmx = strcat(fnm,fxt);
else
    assert(isa(X,'string'),...
        'SC:natsortfiles:X:InvalidType',...
        'First input <X> must be a structure, a cell array, or a string array.');
    [fpt,fnm,fxt] = cellfun(@fileparts, cellstr(X(:)), 'UniformOutput',false);
    nmx = strcat(fnm,fxt);
end
%
varargin = cellfun(@nsf1s2c, varargin, 'UniformOutput',false);
%
assert(all(fun(varargin)),...
    'SC:natsortfiles:option:InvalidType',...
    'All optional arguments must be character row vectors or string scalars.')
%
idd = strcmpi(varargin,'rmdot');
assert(nnz(idd)<2,...
    'SC:natsortfiles:rmdot:Overspecified',...
    'The "." and ".." folder handling is overspecified.')
varargin(idd) = [];
%
ide = strcmpi(varargin,'noext');
assert(nnz(ide)<2,...
    'SC:natsortfiles:noext:Overspecified',...
    'The file-extension handling is overspecified.')
varargin(ide) = [];
%
idp = strcmpi(varargin,'xpath');
assert(nnz(idp)<2,...
    'SC:natsortfiles:xpath:Overspecified',...
    'The file-path handling is overspecified.')
varargin(idp) = [];
%
if nargin>1
    varargin = [{rgx},varargin];
end
%
%% Path and Extension %%
%
% Path separator regular expression:
if ispc()
    psr = '[^/\\]+';
else % Mac & Linux
    psr = '[^/]+';
end
%
if any(idd) % Remove "." and ".." folder names
    ddx = strcmp(nmx,'.')|strcmp(nmx,'..');
    fxt(ddx) = [];
    fnm(ddx) = [];
    fpt(ddx) = [];
    nmx(ddx) = [];
end
%
if any(ide) % No file-extension
    fnm = nmx;
    fxt = [];
end
%
if any(idp) % No file-path
    mat = reshape(fnm,1,[]);
else
    % Split path into {dir,subdir,subsubdir,...}:
    spl = regexp(fpt(:),psr,'match');
    nmn = 1+cellfun('length',spl(:));
    mxn = max(nmn);
    vec = 1:mxn;
    mat = cell(mxn,numel(nmn));
    mat(:) = {''};
    %mat(mxn,:) = fnm(:); % old behavior
    mat(logical(bsxfun(@eq,vec,nmn).')) =  fnm(:);  % TRANSPOSE bug loses type (R2013b)
    mat(logical(bsxfun(@lt,vec,nmn).')) = [spl{:}]; % TRANSPOSE bug loses type (R2013b)
end
%
if numel(fxt) % File-extension
    mat(end+1,:) = fxt(:);
end
%
%% Sort File Extensions, Names, and Paths %%
%
nmr = size(mat,1)*all(size(mat));
dbg = cell(1,nmr);
ndx = 1:numel(fnm);
%
for k = nmr:-1:1
    if nargout<3 % faster:
        [~,ids] = natsort(mat(k,ndx),varargin{:});
    else % for debugging:
        [~,ids,tmp] = natsort(mat(k,ndx),varargin{:});
        [~,idb] = sort(ndx);
        dbg{k} = tmp(idb,:);
    end
    ndx = ndx(ids);
end
%
% Return the sorted input array and corresponding indices:
%
if any(idd)
    tmp = find(~ddx);
    ndx = tmp(ndx);
end
%
ndx = ndx(:);
%
if ischar(X)
    Y = X(ndx,:);
elseif any(idd)
    xsz = size(X);
    nsd = xsz~=1;
    if nnz(nsd)==1 % vector
        xsz(nsd) = numel(ndx);
        ndx = reshape(ndx,xsz);
    end
    Y = X(ndx);
else
    ndx = reshape(ndx,size(X));
    Y = X(ndx);
end
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%natsortfiles
function arr = nsf1s2c(arr)
% If scalar string then extract the character vector, otherwise data is unchanged.
if isa(arr,'string') && isscalar(arr)
    arr = arr{1};
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%nsf1s2c
function [Y,ndx,dbg] = natsort(X,rgx,varargin)


%% Input Wrangling %%
%
fun = @(c)cellfun('isclass',c,'char') & cellfun('size',c,1)<2 & cellfun('ndims',c)<3;
%
if iscell(X)
    assert(all(fun(X(:))),...
        'SC:natsort:X:CellInvalidContent',...
        'First input <X> cell array must contain only character row vectors.')
    Y = X(:);
elseif ischar(X) % Convert char matrix:
    Y = cellstr(X);
else % Convert string, categorical, datetime, etc.:
    Y = cellstr(X(:));
end
%
if nargin<2 || isnumeric(rgx)&&isequal(rgx,[])
    rgx = '\d+';
elseif ischar(rgx)
    assert(ndims(rgx)<3 && size(rgx,1)==1,...
        'SC:natsort:rgx:NotCharVector',...
        'Second input <rgx> character row vector must have size 1xN.') %#ok<ISMAT>
    nsChkRgx(rgx)
else
    rgx = ns1s2c(rgx);
    assert(ischar(rgx),...
        'SC:natsort:rgx:InvalidType',...
        'Second input <rgx> must be a character row vector or a string scalar.')
    nsChkRgx(rgx)
end
%
varargin = cellfun(@ns1s2c, varargin, 'UniformOutput',false);
%
assert(all(fun(varargin)),...
    'SC:natsort:option:InvalidType',...
    'All optional arguments must be character row vectors or string scalars.')
%
% Character case:
ccm = strcmpi(varargin,'matchcase');
ccx = strcmpi(varargin,'ignorecase')|ccm;
% Sort direction:
sdd = strcmpi(varargin,'descend');
sdx = strcmpi(varargin,'ascend')|sdd;
% Char/num order:
orb = strcmpi(varargin,'char<num');
orx = strcmpi(varargin,'num<char')|orb;
% NaN/num order:
nab = strcmpi(varargin,'NaN<num');
nax = strcmpi(varargin,'num<NaN')|nab;
% SSCANF format:
sfx = ~cellfun('isempty',regexp(varargin,'^%([bdiuoxfeg]|l[diuox])$'));
%
nsAssert(varargin, ~(ccx|orx|nax|sdx|sfx))
nsAssert(varargin, ccx,  'CaseMatching', 'case sensitivity')
nsAssert(varargin, orx,  'CharNumOrder', 'char<->num')
nsAssert(varargin, nax,   'NanNumOrder',  'NaN<->num')
nsAssert(varargin, sdx, 'SortDirection', 'sort direction')
nsAssert(varargin, sfx,  'sscanfFormat', 'SSCANF format')
%
% SSCANF format:
if nnz(sfx)
    fmt = varargin{sfx};
else
    fmt = '%f';
end
%
%% Identify and Convert Numbers %%
%
[nbr,spl] = regexpi(Y(:),rgx, 'match','split', varargin{ccx});
%
if numel(nbr)
    tmp = [nbr{:}];
    if strcmp(fmt,'%b')
        tmp = regexprep(tmp,'^0[Bb]','');
        vec = cellfun(@(s)pow2(numel(s)-1:-1:0)*sscanf(s,'%1d'),tmp);
    else
        vec = sscanf(sprintf(' %s',tmp{:}),fmt);
    end
    assert(numel(vec)==numel(tmp),...
        'SC:natsort:sscanf:TooManyValues',...
        'The %s format must return one value for each input number.',fmt)
else
    vec = [];
end
%
%% Allocate Data %%
%
% Determine lengths:
nmx = numel(Y);
lnn = cellfun('length',nbr);
lns = cellfun('length',spl);
mxs = max(lns);
%
% Allocate data:
idn = logical(bsxfun(@le,1:mxs,lnn).'); % TRANSPOSE bug loses type (R2013b)
ids = logical(bsxfun(@le,1:mxs,lns).'); % TRANSPOSE bug loses type (R2013b)
arn = zeros(mxs,nmx,class(vec));
ars =  cell(mxs,nmx);
ars(:) = {''};
ars(ids) = [spl{:}];
arn(idn) = vec;
%
%% Debugging Array %%
%
if nargout>2
    mxw = 0;
    for k = 1:nmx
        mxw = max(mxw,numel(nbr{k})+nnz(~cellfun('isempty',spl{k})));
    end
    dbg = cell(nmx,mxw);
    for k = 1:nmx
        tmp = spl{k};
        tmp(2,1:end-1) = num2cell(arn(idn(:,k),k));
        tmp(cellfun('isempty',tmp)) = [];
        dbg(k,1:numel(tmp)) = tmp;
    end
end
%
%% Sort Columns %%
%
if ~any(ccm) % ignorecase
    ars = lower(ars);
end
%
if any(orb) % char<num
    % Determine max character code:
    mxc = 'X';
    tmp = warning('off','all');
    mxc(1) = Inf;
    warning(tmp)
    mxc(mxc==0) = 255; % Octave
    % Append max character code to the split text:
    for k = reshape(find(idn),1,[])
        ars{k}(1,end+1) = mxc;
    end
end
%
idn(isnan(arn)) = ~any(nab); % NaN<num
%
if any(sdd)
    [~,ndx] = sort(nsGroup(ars(mxs,:)),'descend');
    for k = mxs-1:-1:1
        [~,idx] = sort(arn(k,ndx),'descend');
        ndx = ndx(idx);
        [~,idx] = sort(idn(k,ndx),'descend');
        ndx = ndx(idx);
        [~,idx] = sort(nsGroup(ars(k,ndx)),'descend');
        ndx = ndx(idx);
    end
else
    [~,ndx] = sort(ars(mxs,:)); % ascend
    for k = mxs-1:-1:1
        [~,idx] = sort(arn(k,ndx),'ascend');
        ndx = ndx(idx);
        [~,idx] = sort(idn(k,ndx),'ascend');
        ndx = ndx(idx);
        [~,idx] = sort(ars(k,ndx)); % ascend
        ndx = ndx(idx);
    end
end
%
%% Outputs %%
%
if ischar(X)
    ndx = ndx(:);
    Y = X(ndx,:);
else
    ndx = reshape(ndx,size(X));
    Y = X(ndx);
end
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%natsort
function nsChkRgx(rgx)
tmp = '^((match|ignore)case|(de|a)scend|(char|nan|num)[<>](char|nan|num)|%[a-z]+)$';
assert(isempty(regexpi(rgx,tmp,'once')),'SC:natsort:rgx:OptionMixUp',...
    ['Second input <rgx> must be a regular expression that matches numbers.',...
    '\nThe provided input "%s" is one of the optional arguments (inputs 3+).'],rgx)
if isempty(regexpi('0',rgx,'once'))
    warning('SC:natsort:rgx:SanityCheck',...
        ['Second input <rgx> must be a regular expression that matches numbers.',...
        '\nThe provided regular expression does not match the digit "0", which\n',...
        'may be acceptable (e.g. if literals, quantifiers, or lookarounds are used).'...
        '\nThe provided regular expression: "%s"'],rgx)
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%nsChkRgx
function arr = ns1s2c(arr)
% If scalar string then extract the character vector, otherwise data is unchanged.
if isa(arr,'string') && isscalar(arr)
    arr = arr{1};
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ns1s2c
function nsAssert(vin,vix,ids,txt)
% Throw an error if an option is overspecified or unsupported.
tmp = sprintf('The provided inputs:%s',sprintf(' "%s"',vin{vix}));
if nargin>2
    assert(nnz(vix)<2,...
        sprintf('SC:natsort:option:%sOverspecified',ids),...
        'The %s option may only be specified once.\n%s',txt,tmp)
else
    assert(~any(vix),...
        'SC:natsort:option:InvalidOptions',...
        'Invalid options provided.\n%s',tmp)
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%nsAssert
function grp = nsGroup(vec)
% Groups in a cell array of char vectors, equivalent to [,,grp]=unique(vec);
[vec,idx] = sort(vec);
grp = cumsum([true,~strcmp(vec(1:end-1),vec(2:end))]);
grp(idx) = grp;
end