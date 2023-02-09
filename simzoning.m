function rc = simzoning(input_file_name)
tic
% for debugging, keep the first and the last lines of this file commented
%
% and use the line below to specify input_file_name (this file should be in
% the same folder of the source code.
% input_file_name='brazil1.zon';
% json_input=strcat(input_file_name);
% jsonData = jsondecode(fileread(json_input));

% to compile uncomment the first and last lines
% and comment the line above.
% use the Matlab ApplicationCompiler to create the .exe file
% after compilation, create a folder C:\SimZoning
% place the executable in this folder
% add the folder to the PATH

% to run the program, use the WIndows Power Shell or command prompt
% go to the folder with the input file parameters
% the necessary simulation, climate and shape files must be in subfolder,
% see readme
% type:
%           simzoning <name of the file.zon>



clearvars -except  input_file_name  % erase all variables
% tic % starts a stopwatch timer

version='1.0'

% create a log file
DiaryName = strcat('simzoning_',input_file_name,'.log'); %L: strcat concatenate strings horizontally
if exist(DiaryName, 'file')
    delete(DiaryName); %L: delete existing log
end
diary(DiaryName) %L: creates a log of keyboard input and the resulting text output (an ASCII file)


%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% SimZoning
% versão 0.1
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

fprintf('Removing folders of previous analysis \n');

delete('*.mat');
if exist('Figures', 'dir')
    dos('rmdir Figures /s/q');
end
if exist('simresults','dir')
    dos('rmdir simresults /s/q');
end
if exist('Interpolated_data', 'dir')
    dos ('rmdir Interpolated_data /s /q');
end



fprintf('Making new directories \n');

mkdir Figures\BoundaryConditions\;
mkdir Figures\Clusters\;
mkdir Figures\MPMA\;
mkdir Figures\QualityControl\;
mkdir Figures\Interpolation\;
mkdir Figures\CZ_Methods_Comparison\;

mkdir Outputs;
mkdir Simulations_SZ;
mkdir Interpolated_data;


fprintf('Reading input file\n');
jsonData = jsondecode(fileread(input_file_name));
%Main root of the toolbox
mainProjectFolder=jsonData.mainProjectFolder;
% Name of the case study
CaseStudy=jsonData.CaseStudy;
%Constant variables
simzoning_constantes;
% User option to run simulations
RunSimulations=jsonData.RunSimulations;
% User option to generate a report (1=yes), (0=no), only available with
% Matlab Report Generator
Report_generation=jsonData.Report_generation;
% User option to interpolate data(1=yes), (0=no)
Interpolation=1;
% Interpolation method 1) ANN and 2) Lat, long and Alt.
interpolation_method=jsonData.Interpolation_Method;

%% Simulation settings
% Number of cores used to run parallel simulations
Num_of_cores=jsonData.Num_of_cores;
% Main folder of Energy Plus program
EPlusPath=jsonData.EPlusPath;
% Root of IDF files used for simulation
BuildingIDFPath=jsonData.BuildingIDFPath;
% Root of EPW files in the EnergyPlus folder
WeatherPath=jsonData.WeatherPath;
%List of weather files provided by the user yes(1) no(0)
Predifined_listofweatherfiles=jsonData.Predifined_listofweatherfiles;
% Expression used to identify weather files in a directory
Weatherfiles_searching_prefix=jsonData.Weatherfiles_searching_prefix;
% Wather source
WeatherSource=jsonData.WeatherSource;

%%  GIS files, intepolation
% Shape file of the area under study
ShapeFileName_AreaofStudy=jsonData.ShapeFileName_AreaofStudy; AreaofStudypath=jsonData.AreaofStudyShapefile_Path;
% User option to select filter data inside the area of study, when
% irregular grid exceeds its boundaries of the area of Study. For instance a grid of Municipalities of the whole
% are used for a specific state
IrregularGrid_exceeds_areaofstudy=jsonData.IrregularGrid_exceeds_areaofstudy;
% size of the grid (is the number of bins considering the limits of the
% shapefile).
grid_of_points_exceeds_areaofstudy=jsonData.grid_of_points_exceeds_areaofstudy;
GridSize_IDW=jsonData.GridSize_IDW;
% Tiff file containing elevation data for the area under study
Elevation_file=jsonData.Elevation_file;
% Irregular_grid_input_data in mat format
Irregular_grid_input_data=jsonData.Irregular_grid_input_data;

%% Size of text and strokes of figures
sizeofpoints=jsonData.sizeofpoints; %
TitlefontSize=jsonData.TitlefontSize;
TextFontSize=jsonData.TextFontSize;
SubtitleFontSize=jsonData.SubtitleFontSize;
LabelFontSize=jsonData.LabelFontSize;
sizeofpointsHDM=jsonData.sizeofpointsHDM;
%%  Weather files used for Simulation
cd(mainProjectFolder)
cd Weatherfiles
% Option to select specific weather files from a folder using prefix names
% defined by the user
jmin=jsonData.jmin; % the number of the first weather file from the list used to run simulations

if jsonData.run_simulations_with_all_climates==1
    filesepw_Number=dir(fullfile('*.epw'));
    % run simulations for all weather contained in the list
    jmax=length(filesepw_Number);
else
    % run simulations for a portion of weather files contained in the list
    %from jmin to jmax(x)(defined by the user)
    jmax=jsonData.Maxi_Num_of_climates_for_simulation;
end
% If there is a predefined list of weather files, prefix provided by the user are used to
% select those files
if Predifined_listofweatherfiles==1
    for j=1:length(Weatherfiles_searching_prefix)
        filesepw{j}=dir(Weatherfiles_searching_prefix{j});
    end
    %
    filesepw=vertcat(filesepw{:});
    filesepwl=struct2table(filesepw);
    cd (mainProjectFolder)
    Epws_torunSIm=filesepwl.name;
    % list of selected weather files for simulation
    save('Epws_torunSIm.mat','Epws_torunSIm')
    simzoning_b_EPWwithinShapefile
else
    % Option to select all weather files contained in the folder
    filesepw=dir(fullfile('*.epw'));
    filesepwl=struct2table(filesepw);
    Epws_torunSIm=filesepwl.name;
    cd ..
    % If the list of weather files is not provided by the user, this script
    % identifies the weather files contained in a region using a shape
    % file of the area os
    simzoning_b_EPWwithinShapefile
end

%% Performance indicators for clustering
% The name of performance indicators used for clustering defined by the user
PerformanceIndicator=reshape(jsonData.PerformanceIndicator,1,[]);
% Units of performance indicators defined by the user following the same
% order as PerformanceIndicator. This information is usefull in figures and
% reports
PerformanceIndicator_Units=reshape(jsonData.PerformanceIndicator_Units,1,[]);
% Building zones used to calculate performance indicators. Based on the
% assumtion that the same geometry is used for all simulations.
BuildingZones_considered_for_PerformanceIndex_calculation=jsonData.Building_Zones_considered_for_PerformanceIndex_calculation;
%To calculate performance, occupation schedules are required. These
%schedules should be included in simulation outputs reports from EnergyPlus
Building_Zones_occupation=jsonData.Building_Zones_occupation_Schedule;
% Tag to differentiate Models with HVAC and NV (Required to calculate specific performance indicators for each case study)
Conditioning_type_tag=jsonData.Conditioning_type_tag;
% Climatic zones pruduced by clustering would be numbered based on a performance indicator defined by the
% user, for instance, in the Brazilian case study, the dominant performance indicator was
% cooling load and it was used to number Zones from colder to hotter
PerformanceIndicator_Zones_order=reshape(jsonData.PerformanceIndicator_Zones_order,1,[]);
%% Output paths
% Path of the folder where simulations for each climate take place
SimresultsOUTPUTpath=jsonData.SimresultsOUTPUTpath;
% to extract simulation outputs
% number of columns and rows to extract cooling and heating load from the
% Energy Plus simulation results (*Table.csv)
Row_heating_cooling=jsonData.Row_heating_cooling;
Column_heating_cooling=jsonData.Column_heating_cooling;
% Lines contaning EPW name in the simulation output file(*table.csv)
Line_EPW=jsonData.Line_EPW;
% Path of the folder with agreggated simulation results
Aggregated_Simesults_Path=jsonData.Aggregated_Simesults_Path;
% File contaning aggregated simulation results
Aggregatesimmresults=char(strcat('PIs',WeatherSource,'.mat'));
% % Temporary Output folders for figures %
% OutputFolderFigures_BoundaryConditions=jsonData.OutputFolderFigures_BoundaryConditions;
% OutputFolderFigures_ClusterResults=jsonData.OutputFolderFigures_ClusterResults;
% OutputFolderFigures_Interpolation=jsonData.OutputFolderFigures_Interpolation;
% OutputFolderFigures_QualityControl=jsonData.OutputFolderFigures_QualityControl;


%%  Clustering
% User option to perform clustering based on 1)isolated locations, 2)Custom
% grid provided by the user(e.g. Municipalities), and 3)Interpolated data
% using a regular grid
Zoning_isolated_locations=jsonData.Zoning_isolated_locations;% a)
Zoning_interpolated_PerfData_IrregularGrid=jsonData.Zoning_interpolated_PerfData_IrregularGrid; % b)
Zoning_interpolated_PerfData_RegularGrid=jsonData.Zoning_interpolated_PerfData_RegularGrid;% c)
ZoningAlternatives=[Zoning_isolated_locations;Zoning_interpolated_PerfData_IrregularGrid;Zoning_interpolated_PerfData_RegularGrid];

% grid is generated in case clustering with interpolated data is required

if Zoning_interpolated_PerfData_IrregularGrid==1 || Zoning_interpolated_PerfData_RegularGrid==1
    Grid_generation=1;
end
% User option to select one or more Climatic zoning resolutions a) Isolated
% points, b) irregular grid(e.g. Municipalities) and c) Regular grid
Zoning_grid_type=jsonData.Zoning_grid_type;
AlternativeMethod_for_comparison=jsonData.AlternativeMethod_for_comparison;
% Name of alternative methods for comparison
Name_of_AlternativeMethod_for_comparison=jsonData.Name_of_AlternativeMethod_for_comparison;

% Number of zones
Number_of_Zones=jsonData.NumberofZones;
% Use a predefined division prior to clustering? (1=yes)(0=no)
Macrozones_divisions=jsonData.Macrozones_divisions;
% Name of macrozones
% Name_of_Macrozones=jsonData.Name_of_Macrozones;
% When using macrozones divisions, it is advisable to use interpolation
% method # 2
if Macrozones_divisions==1
    interpolation_method=2;
end

%Criteria
% In the Brazilian case study, Macrozones were defined based on the
% following criteria:
% Cold Macrozone, is a region where for a sample model (Defined by the user), heating represents at
% least 5% of the needs for air conditioning compared to cooling load.

% Each macrozone can have a different number of zones, called 'subzones'
Number_of_subzones=reshape(jsonData.Number_of_subzones,1,[]);


%% Simulation parameters
cd (mainProjectFolder)
save ImputVariables.mat
% Path for outputs
CaseStudy_output_folder=char(strcat('./Outputs/',CaseStudy,'_CaseStudy'));
if ~exist(CaseStudy_output_folder, 'dir')
    mkdir (CaseStudy_output_folder)
end


%%  SIMULATIONS
if RunSimulations==1
    cd (mainProjectFolder)
    simzoning_c_MultiCore_Simulation
end
%% Extraction of simulation results

if Extract_Simresults==1
    cd (mainProjectFolder)
    % Extract Simulation Results
    simzoning_d_ExtractSimResults
    fprintf('Simulation results extraction completed \n');
end

%% GRID Generation
if Grid_generation==1% depending on the resolution, it can take a lot of a can take a long time
    cd (mainProjectFolder)
    simzoning_e_GRIDwithinShapefile % produces a matrix containing LAT, LON and ALT considering different grid options
    % 1) Regular grid and 2) Custom GRID (e.g. Municipalities)
end
%% Interpolation
cd (mainProjectFolder)
%Interpolation using lat, long e alt.
if Interpolation==1 || Zoning_interpolated_PerfData_IrregularGrid==1 || Zoning_interpolated_PerfData_RegularGrid==1
    simzoning_f_Interpolation
    fprintf('Interpolation completed \n');
end
% Clustering based on the kmeans algorithm
if Cluster_data==1
    simzoning_g_Zoning
    fprintf('Clustering completed \n');
end
cd (mainProjectFolder)
%% Alternative Methods for comparison
if AlternativeMethod_for_comparison==1
    simzoning_h_MatchShapefile_Performance
end
%%  MPMA
cd (mainProjectFolder)
load ImputVariables.mat

if Zoning_interpolated_PerfData_RegularGrid==1 && Calculate_MPMA==1 && numel(filesepw)
    % MPMA using the bins method was designed to be calculated with regular
    % grids. In this case, is called by simzoning when CLusters based
    % on interpolated areas is required
    simzoning_i_MPMA_bins
    fprintf('MPMA calculation finished (bins method)\n');
end
if Calculate_MPMA==1
    % MPMA using the centroid method is used alternatively for different
    % clustering resolutions
    cd (mainProjectFolder)
    simzoning_j_MPMA_Centroids
    fprintf('MPMA calculation finished (Centroids method)\n');
end

% cd ..
cd (mainProjectFolder)

%%  Report generation
if Report_generation==1
    fprintf('Starting report generation \n');
    simzoning_k_Report
    fprintf('Report generation completed \n');
end
%%  Moving files to the output folder

if interpolation_method==1 && Macrozones_divisions==1
    CaseStudy_output_f=char(strcat('./Outputs/',CaseStudy,'_CaseStudy/'));
elseif interpolation_method==1 && Macrozones_divisions==0
    CaseStudy_output_f=char(strcat('./Outputs/',CaseStudy,'_CaseStudy/'));
elseif interpolation_method==2 && Macrozones_divisions==1
    CaseStudy_output_f=char(strcat('./Outputs/',CaseStudy,'_CaseStudy/'));
elseif interpolation_method==2 && Macrozones_divisions==0
    CaseStudy_output_f=char(strcat('./Outputs/',CaseStudy,'_CaseStudy/'));
end

fprintf('Moving all Figures and tables with simulation aggregated results to the output/CaseStudy folder \n');
delete('*MPMA*.csv')

if exist('MPMA_results', 'dir')
    dos('rmdir MPMA_results /s/q');
end
movefile('*Zon*.csv',  CaseStudy_output_f,'f')
movefile('Simresults.csv',  CaseStudy_output_f,'f')
if exist('Interpolated_data','file')
    movefile("Interpolated_data\",CaseStudy_output_f,'f')
end
movefile("simresults\",CaseStudy_output_f,'f')
movefile("Figures\",CaseStudy_output_f,'f')


%% finish program
diary off;
beep;
rc=0;
toc
end
