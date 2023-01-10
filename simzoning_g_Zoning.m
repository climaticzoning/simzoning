% This script cluster data based the k-means algorithm using three different resolutions
% a) Isolated locations
% b) Irregular grid, e.g. Municipalities
% c) Regular grid (high resolution)
% and 2 clustering options
% 1-Considering Macrozones and subzones
% 2-Considering a number of zones without macrozones
% % % When using macrozones divisions, it is advisable to use interpolation
% % method # 2
% It requires
% 1. A matrix with ALT LAT LON Performance data
% 2 Number of zones and/or subzones(if macrozones are adopted)
clearvars
load ImputVariables.mat

%% Resolution 1. Points
if ZoningAlternatives(1,1)>0
    z=1;
    cd simresults\
    % load aggregated simulation results
    load(Aggregatesimmresults);
    if grid_of_points_exceeds_areaofstudy==1
        cd (mainProjectFolder)
        % This folder contais a shapefile with the limits of the area under study
        cd (AreaofStudypath)
        % Reads the shape file
        S=shaperead(ShapeFileName_AreaofStudy);
        %% Shape file coordinates
        polygon1_long = S(1).X;     % it finds all the X-Coordinates of points in polygon number one
        polygon1_lat= S(1).Y;   % it finds all the Y-Coordinates of points in polygon number one
        %% Irregular grid
        lat=Table4cluster.LAT; % Latitude for each location
        lon=Table4cluster.LON; %
        [in,on] = inpolygon(lat,lon,polygon1_lat,polygon1_long);        % Logical Matrix
        inon = in | on;                                             % Combine ‘in’ And ‘on’
        idx = find(inon(:));                                        % Linear Indices Of ‘inon’ Points
        latcoord = lat(idx);                                        % X-Coordinates Of ‘inon’ Points
        loncoord = lon(idx);
        Table4cluster=Table4cluster(idx,:);
    end

    % Remove unneccesary variables
    Table4cluster = removevars(Table4cluster, "ListofEPW");
    Table4cluster=rmmissing(Table4cluster);
    % Selecting performance data to perform clustering
    PerfMatrix=table2array(Table4cluster(:,4:end));
    cd(mainProjectFolder)
    % Script that clusters data
    simzoning_g1_Cluster_data
    clear idx
end
clearvars
load ImputVariables.mat
%% Resolution 2 Irregular grid provided by user. e.g. Municipalities
if ZoningAlternatives(2,1)>0
    z=2;
    cd simresults\
    % it loads interpolated data using municipalities locations
    load Table4clusters_Interp_Municipalities
    % It clears NaN values
    Table4cluster=rmmissing(Table4clusters_Interpolated);
   % Performance data used for clustering
    PerfMatrix=table2array(Table4cluster(:,4:end));
    cd(mainProjectFolder)
    % Script that clusters data
    simzoning_g1_Cluster_data
    clear idx
end

%% Resolution 3. Regular Grid
clearvars
load ImputVariables.mat
if ZoningAlternatives(3,1)>0
    z=3;
    % open simresults to get interpolated data
    cd simresults\
    % Loading interpolated based on regular grid
    load Table4clusters_Interp_Regular_Grid
    % cleaning NaN values
    Table4cluster=rmmissing(Table4clusters_Interpolated);
    % Performance data used for clustering
    PerfMatrix=table2array(Table4cluster(:,4:end));
    cd(mainProjectFolder)
    % Script that cluster data
    simzoning_g1_Cluster_data
    clear idx
end


