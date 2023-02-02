
% This script 
% 1. Reads latitude, longitude and altitude of epws files.
% 2. It plots weather files on a map 
% If required, 
% 3. It identifies the epw files inside the area of study and near the limits of a shapefile

% REQUIRES
% A shape file of the area under study
% Epws files for the area of study

% Open the weather file folder
cd Weatherfiles\
%extracting latitude and longitude from Weather files
for j=jmin:numel(Epws_torunSIm)
    fullnameepw=Epws_torunSIm(j);
    filename=char(strcat(fullnameepw));
    %% Initialize variables.
    delimiter = ',';
    endRow = 1;
    %% Format string for each line of text:
    %   column7: double (%f)
    %	column8: double (%f)
    % For more information, see the TEXTSCAN documentation.
    formatSpec = '%*s%*s%*s%*s%*s%*s%f%f%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%[^\n\r]';

    %% Open the text file.
    fileID = fopen(filename,'r');
    %% Read columns of data according to format string.
    % This call is based on the structure of the file used to generate this
    % code. If an error occurs for a different file, try regenerating the code
    % from the Import Tool.
    dataArray = textscan(fileID, formatSpec, endRow, 'Delimiter', delimiter, 'ReturnOnError', false);clc
    %% Close the text file.j
    fclose(fileID);

    %% Create output variable
    LatLong(:,j)= dataArray; % This line save Latitude and Longitude data for each EPW file.

    %% Clear temporary variables
    clearvars filename delimiter endRow formatSpec fileID dataArray ans;
end
% Transpose data
LatLongitude=(LatLong)';
% Latitude and longitude of weather files array
LatLongitude=cell2mat(LatLongitude(:,1:2));
%% Importing and reading the shapefile
cd (mainProjectFolder)
% This folder contais a shapefile with the limits of the area under study
cd (AreaofStudypath)
% Reads the shape file
S=shaperead(ShapeFileName_AreaofStudy);
% Setting warning off
warning('off','map:shapefile:missingDBF');
warning('off','map:shapefile:buildingIndexFromSHP');
% Shape file coordinates
polygon1_long = S(1).X;     % it finds all the X-Coordinates of points in the polygon
polygon1_lat= S(1).Y;   % it finds all the Y-Coordinates of points in the polygon

%If required the shapefile is used to identify the matching weather files
if Predifined_listofweatherfiles==0
   fprintf('Identifying EPW files located in the area of study \n');
    %Offset polygon in degrees
    bufwith=1; % Width offset
    [latburf,longburf] = bufferm(polygon1_lat,polygon1_long,bufwith);
    %coordinates of Epws
    lat=LatLongitude(:,1);
    lon=LatLongitude(:,2);
    % Name of the weather files
    filesepwl=struct2table(filesepw);
    Epws=filesepwl.name;
    % Calculation of the points that fall inside the area of study
    [in,on] = inpolygon(lat,lon,polygon1_lat,polygon1_long);        % Logical Matrix
    inon = in | on;                                             % Combine ‘in’ And ‘on’
    idx1 = find(inon(:));                                        % Linear Indices Of 1inon’ Points
    latcoord = lat(idx1);                                        % Coordinates Of 1inon’ Points
    loncoord = lon(idx1);
    % Calculation of the points that fall near the boundaries (Offset area)
    [in,on] = inpolygon(lat,lon,latburf,longburf);        % Logical Matrix
    inon = in | on;                                             % Combine ‘in’ And ‘on’
    idx2 = find(inon(:));                                        % Linear Indices Of 1inon’ Points
    latcoord = lat(idx2);                                        % Coordinates Of 1inon’ Points
    loncoord = lon(idx2);
    % List of EPWs that falls inside and near the boundaries of the polygon
    Epws_torunSIm=[Epws(idx1);Epws(idx2)];
    % Coordinates of selected EPWs
    lat_selectedEPWs=[lat(idx1);lat(idx2)];
    lon_selectedEPWs=[lon(idx1);lon(idx2)];
    cd(mainProjectFolder)
    %Saving results
    save('Epws_torunSIm.mat','Epws_torunSIm');
    fprintf('List of EPW files successfully saved \n');
    
    % Plotting data for quality assurance
    f1 = figure('visible','off');
    % Polygon of the area of study
    geoplot(polygon1_lat,polygon1_long,'b:','LineWidth',1.5,'DisplayName','Area of study')
    hold on
    % Selected locations
    geoscatter(lat_selectedEPWs, lon_selectedEPWs,'filled','MarkerFaceAlpha',0.7,'DisplayName','Location of weather files used in this study')
    % Setting legend properties
    legend1 = legend;
    set(legend1,'Interpreter','none','FontSize',LabelFontSize);
    % Setting base map
    geobasemap('topographic')
    %Size of the figure
    set(gcf, 'Position', get(0, 'Screensize'));
    % Saving the figure in .PNG format
    cd Figures/BoundaryConditions
    NameofFig=char(strcat(CaseStudy, {' '},'Selected weather files for simulation'));
    title(NameofFig,FontSize=TitlefontSize, Interpreter="none")
    print(NameofFig, '-dpng', '-r0')
    close all force
    %%  Figure for the Report Front Page
    f1 = figure('visible','off');
    geoplot(polygon1_lat,polygon1_long,'k:','LineWidth',1)
    geobasemap('streets')
    set(gcf, 'Position', get(0, 'Screensize'));
    print('portada', '-dpng', '-r0')
    close all force;
    fprintf('Map containing EPWs generated \n');
% If the weather files are preselected by the user, this scrip plots the
    % data
elseif Predifined_listofweatherfiles==1
    cd(mainProjectFolder)
    % Plotting data for quality assurance
    f1 = figure('visible','off');
    % Polygon of the area of study
    geoplot(polygon1_lat,polygon1_long,'b:','LineWidth',1.5,'DisplayName','Area of study')
    hold on
    % Selected locations
    geoscatter(LatLongitude(:,1),LatLongitude(:,2),28,'filled','MarkerFaceAlpha',0.7,'DisplayName','Location of weather files used in this study')
   % Setting legend properties
    legend1 = legend;
    set(legend1,'Interpreter','none','FontSize',LabelFontSize);
    % Setting base map
    geobasemap('topographic')
    %Size of the figure
    set(gcf, 'Position', get(0, 'Screensize'));
    % Saving the figure in .PNG format
    cd Figures/BoundaryConditions
    NameofFig=char(strcat(CaseStudy, {' '},'Selected weather files for simulation'));
    title(NameofFig,FontSize=TitlefontSize, Interpreter="none")
    print(NameofFig, '-dpng', '-r0')
    close all force
    %%  Figure for the Report Front Page
    f1 = figure('visible','off');
    geoplot(polygon1_lat,polygon1_long,'k:','LineWidth',1)
    geobasemap('streets')
    set(gcf, 'Position', get(0, 'Screensize'));
    print('portada', '-dpng', '-r0')
    close all force;
    fprintf('Map containing EPWs generated \n');
end

