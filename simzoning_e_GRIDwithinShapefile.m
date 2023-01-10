
% This script generates a regular grid within the area under study
% containing 'LAT','LON','ALT'
% REQUIRES
% A shape file of the area under study *.SHP
% A grid size definition: E.G.  N=20, 50, 100
% A Tiff file with elevation data located in the GISfiles folder (This script was tested with a tiff file with a projected coordinate system: WGS_1984_World_Mercator)
% OUTPUTS
% RegularGrid.mat
%'lat-lon-alt-RegularGrid.csv' containing 'LAT','LON','ALT'

% Alternatively, this routine can calculate Elevation for given set of locations. In that case, users must provide the input data
% containing LAT and LON in a csv format. The name of the file should be
% specified in the input *.zon file "Irregular_grid_input_data" and the
% file should be placed in the main simzoning folder.

% OUTPUTS
%  a    matrix with 'LAT','LON','ALT'
%  gridforInterp_muni.mat'
% 'grid-alt_municipios.csv'

clearvars
load('ImputVariables.mat')

% if an irregular grid is used, e.g, municipalities
if Zoning_interpolated_PerfData_IrregularGrid==1
    % A  file containing LAT and LON (in that order) of municipalities provided by the user
    % in a csv format
    MunicipiosBrasil=readtable(Irregular_grid_input_data);% reading the file
    if IrregularGrid_exceeds_areaofstudy==1
        cd (mainProjectFolder)
        % This folder contains a shapefile with the limits of the area under study
        cd (AreaofStudypath)
        % Reads the shape file
        S=shaperead(ShapeFileName_AreaofStudy);
        %% Shape file coordinates
        polygon1_long = S(1).X;     % it finds all the X-Coordinates of points in polygon number one
        polygon1_lat= S(1).Y;   % it finds all the Y-Coordinates of points in polygon number one
        %% Irregular grid
        lat=MunicipiosBrasil.(1); % Latitude for each location
        lon=MunicipiosBrasil.(2); %
        [in,on] = inpolygon(lat,lon,polygon1_lat,polygon1_long);        % Logical Matrix
        inon = in | on;                                             % Combine ‘in’ And ‘on’
        idx = find(inon(:));                                        % Linear Indices Of ‘inon’ Points
        latcoord = lat(idx);                                        % X-Coordinates Of ‘inon’ Points
        loncoord = lon(idx);
    elseif IrregularGrid_exceeds_areaofstudy==0
        latcoord=(MunicipiosBrasil.LAT); % Latitude for each location
        loncoord=(MunicipiosBrasil.LON); % Longitude for each location
    end
    cd(mainProjectFolder)
    % folder that contains the TIFF file with elevation data
    cd GISfiles/Elevation/
    %Extraction of Altitude data from a Tiff file for each coordinates
    alt=geotiffinterp(Elevation_file,latcoord,loncoord);
    %% Figure for quality assurance
    % it loads performance data to compare the grid and the original
    % location of weather files for simulations
    cd(mainProjectFolder)
    cd simresults\
    load(Aggregatesimmresults);
    % Plot figure
    f1 = figure('visible','off');
    geoscatter(latcoord,loncoord,sizeofpointsHDM, alt,'filled','DisplayName','Grid Location')
    hold on
    geoscatter(Table4cluster.LAT,Table4cluster.LON,30,'*k','DisplayName','Original locations')
    legend1 = legend;
    set(legend1,'Interpreter','none','FontSize',LabelFontSize);
    set(gcf, 'Position', get(0, 'Screensize'))
    title('Municipalities with elevation data and original locations of weather files used for simulation','FontSize',TitlefontSize)
    ylabel(colorbar,'Elevation (masl)','FontSize',LabelFontSize)
    cd (mainProjectFolder)
    cd (OutputFolderFigures_Interpolation)
    % Save figure
    print('Irregular grid elevation', '-dpng')
    close all force;
    %% saving data into mat file and csv file
    cd(mainProjectFolder)
    cd grid_input
    data=table(latcoord,loncoord, alt,'VariableNames',{'LAT','LON','ALT'});
    save('gridforInterp_muni.mat','data')
    writetable(data,'grid-alt_municipios.csv')

end
if Zoning_interpolated_PerfData_RegularGrid==1
    cd (mainProjectFolder)
    % This folder contais a shapefile with the limits of the area under study
    cd (AreaofStudypath)
    % Reads the shape file
    S=shaperead(ShapeFileName_AreaofStudy);

    %% Shape file coordinates
    polygon1_long = S(1).X;     % it finds all the X-Coordinates of points in polygon number one
    polygon1_lat= S(1).Y;   % it finds all the Y-Coordinates of points in polygon number one
    %% Regular grid
    lon0 = min(polygon1_long) ; lon1 =  max((polygon1_long)) ; % definition of min and max longitude of the polygon
    lat0 = min(polygon1_lat) ; lat1 = max(polygon1_lat) ;% definition of min and max latitude of the polygon
    N = GridSize_IDW ; %size of the grid (the higher the resolution, the longer it takes to execute the routine)
    x = linspace(lon0,lon1,N) ; % vector of longitudes
    y = linspace(lat0,lat1,N) ; % vector of latitudes
    [X,Y] = meshgrid(x,y) ; % grid construction

    lat=Y(:);% data from the grid is extracted
    lon=X(:);
    % Data is filtred using the shape file limits
    [in,on] = inpolygon(lat,lon,polygon1_lat,polygon1_long);        % Logical Matrix
    inon = in | on;                                             % Combine ‘in’ And ‘on’
    idx = find(inon(:));                                        % Linear Indices Of ‘inon’ Points
    latcoord = lat(idx);                                        % X-Coordinates Of ‘inon’ Points
    loncoord = lon(idx);
    %%  Extract alt from a tiff file
    cd (mainProjectFolder)% Import the data
    cd GISfiles/Elevation/
    % this line of the code extract elevation data for each coordinate
    alt=geotiffinterp(Elevation_file,latcoord,loncoord);
    % geotiffinterp is a third-party function (Chad Greene (2022)).
    % geotiffinterp (https://www.mathworks.com/matlabcentral/fileexchange/47899-geotiffinterp), MATLAB Central File Exchange. Retrieved November 2, 2022.
    % This function interpolates values of a georeferenced tiff file, given lat/lon coordinates or map x/y locations corresponding to the map projection associated with the tiff file.
    %%  Figure for quality control
    cd(mainProjectFolder)
    cd simresults\
    % it loads performance data to compare the grid and the original
    % location os simulations
    load(Aggregatesimmresults);
    f1 = figure('visible','off');
    geoscatter(latcoord,loncoord,sizeofpointsHDM, alt,'filled','DisplayName','Grid Location')
    hold on
    geoscatter(Table4cluster.LAT,Table4cluster.LON,30,'*k','DisplayName','Original locations')
    set(gcf, 'Position', get(0, 'Screensize'))
    legend1 = legend;
    set(legend1,'Interpreter','none','FontSize',LabelFontSize);
    VariableName=char(strcat('Regular grid with altitude and original locations of weather files '));
    title(VariableName, FontSize=TitlefontSize)
    ylabel(colorbar,'Elevation (masl)', 'FontSize',LabelFontSize)
    cd (mainProjectFolder)
    cd (OutputFolderFigures_Interpolation)
    % Saving figure
    print('Regular grid_elevation', '-dpng')
    close all force;
    %%  Saving results
    cd(mainProjectFolder)
    cd simresults
    data=table(latcoord, loncoord,alt,'VariableNames',{'LAT','LON','ALT'});
    save('RegularGrid.mat','data')
    writetable(data,'lat-lon-alt-RegularGrid.csv')
end

%% Third_party local function
function [Ai] = geotiffinterp(filename,varargin)
% GEOTIFFINTERP interpolates values of a georeferenced tiff file, given lat/lon coordinates or map x/y
% locations corresponding to the map projection associated with the tiff file. This function is _fast_
% because even if the GeoTIFF file is quite large, only a region of the image large enough to perform
% interpolation is loaded.  This function was designed to easily probe GeoTIFF datasets such as digital
% elevation maps (DEMs) or other geospatial data arrays.
%
%
%% Syntax
%
%  Ai = geotiffinterp(filename,lati,loni)
%  Ai = geotiffinterp(filename,xi,yi)
%  Ai = geotiffinterp(...,InterpolationMethod)
%  Ai = geotiffinterp(...,'nanval',NanValue)
%  Ai = geotiffinterp(...,'frame',FrameNumber)
%  Ai = geotiffinterp(...,'show')
%
%
%% Description
%
% Ai = geotiffinterp(filename,lati,loni) returns interpolated values of a tiff image at georeferenced
% locations given by lati and loni.
%
% Ai = geotiffinterp(filename,xi,yi) returns interpolated values a tiff image where xi and yi are
% units of distance (usually feet or meters) in projected map coordinates described by the projection
% metadata in the tiff file.  The way xi and yi are interpreted: if no value in xi has an absolute
% value exceeding 90 _and_ no value in yi has an absolute value exceeding 360, then geographic coordinates
% of degrees are assumed.  Otherwise, the first two inputs after filename are assumed to be map x/y
% coordinates.
%
% Ai = geotiffinterp(...,InterpolationMethod) specifies an interpolation method as 'nearest', 'linear',
% 'spline', or 'cubic'.  Default interpolation method is linear.
%
% Ai = geotiffinterp(...,'nanval',NanValue) sets a specified value in the tiff to NaN before interpolation.
% In GeoTIFF format, undefined values are often set to 32767 because the tiff format only stores integers. By default,
% geotiffinterp sets replaces all values of 32767 to NaN before interpolation. To prevent geotiffinterp from
% doing this, declare 'nanval',NaN. To replace some other value, say 9999, to NaN before interpolation, use
% 'nanval',9999.
%
% Ai = geotiffinterp(...,'frame',FrameNumber) specifies a frame number to interpolate, if the GeoTIFF contains
% multiple frames. Currently, FrameNumber can only have a single scalar value, so you'll have to loop geotiffinterp
% to probe multiple frames.  If the tiff file contains multiple frames and you do not specify which one you're interested
% in, geotiffinterp will only interpolate the first frame.  As this applies to georeferenced image tiffs with three slices
% corresponding to red, green, and blue, if you want all three colors you will have to run geotiffinterp once
% for each color.
%
% Ai = geotiffinterp(...,'show') plots the subsection of the tiff that is loaded by geotiffinterp in grayscale
% and overlays markers showing interpolation locations.
%
%
%% Examples
%
% Examples of usage can be found in the included html example file.
%
%% Author Info:
% This function was written by Chad A. Greene of the University of Texas
% Institute for Geophysics in September 2014.  This function was inspired
% by and borrows some code from Aslak Grinsted's geotiffreadregion function
% found here: http://www.mathworks.com/matlabcentral/fileexchange/46904.
%
% See also GEOTIFFREAD, GEOTIFFINFO, PIXCENTERS, INTERP2, and PROJFWD.


%% Initial error checks:

assert(license('test','map_toolbox')==1,'geotiffinterp requires Matlab''s Mapping Toolbox.')
assert(nargin>2,'geotiffinterp requires a filename and interpolation coordinates.')
assert(nargin<10,'You''ve tried to enter too many inputs in geotiffinterp.')
assert(isnumeric(filename)==0,'Input filename must be a string.')
assert(isnumeric(varargin{1})==1,'geotiffinterp coordinates must be numeric.')
assert(isnumeric(varargin{2})==1,'geotiffinterp coordinates must be numeric.')


%% Parse inputs:

% Set defaults:
usegeocoordinates = false;
interpmethod = 'linear';
NaNVal = 32767; % Default value to set to NaN
showmap = false;
FrameNumber = 1;
framedeclared = false;

% Define interpolation coordinates:
x_or_lat = varargin{1};
y_or_lon = varargin{2};
assert(numel(x_or_lat)==numel(y_or_lon),'Interpolation coordinate dimensions must match.')

% Assume geo coordinates if no input limits exceed normal lat/lon values:
if max(abs(x_or_lat(:)))<=90 && max(abs(y_or_lon(:)))<=360
    usegeocoordinates = true;
end

% Optional inputs:
if nargin>3

    % Show a map?
    tmp = strncmpi(varargin,'show',4)|strcmpi(varargin,'map');
    if any(tmp)
        showmap = true;
    end

    % Set interpolation method:
    tmp = strncmpi(varargin,'near',4)|strncmpi(varargin,'lin',3)|...
        strncmpi(varargin,'spl',3)|strncmpi(varargin,'cub',3);
    if any(tmp)
        interpmethod = varargin{tmp};
    end

    % Replace a value with NaNs? Commonly, the value 32767 indicates undefined value.
    tmp = strncmpi(varargin,'nan',3);
    if any(tmp)
        NaNVal = varargin{find(tmp)+1};
    end

    % Choose frame number
    tmp = strcmpi(varargin,'frame')|strcmpi(varargin,'slice');
    if any(tmp)
        FrameNumber = varargin{find(tmp)+1};
        assert(sum(mod(FrameNumber,1))==0,'Frame number must an integer.')
        assert(any(FrameNumber<1)==0,'Frame number cannot be less than one.')
        assert(isscalar(FrameNumber)==1,'Frame number must be a scalar or vector.')
        framedeclared = true;
    end
end


% Check file type:
[~,~,ext] = fileparts(filename);
switch upper(ext)
    case {'.JP2' '.JPEG2000' '.GEOJP2'}
        I = jp2tiffinfo(filename);
    case {'.TIF' '.TIFF'}
        I = geotiffinfo(filename);
    otherwise
        error('Unrecognized image file type. Must be tif, tiff, jp2, jpeg2000, or geojp2.')
end

%% Begin work:

% Get pixel coordinates of full (non-subset) image:
try
    [x,y]=pixcenters(I);
catch err
    error(['The info structure for ',filename,' does not seem to have enough information to properly georeference pixels.'])
end

% Switch lat/lon to x/y if necessary:
if usegeocoordinates
    [x_or_lat,y_or_lon]=projfwd(I,x_or_lat,y_or_lon);
end

% Get image resolution:
resx = I.PixelScale(2);
resy = I.PixelScale(1);
bufferpix = 10; % loads 10 extra pixels on each side of data to allow for interpolation

% Set limits in meters or feet with 10 pixel buffer included:
xlim = [min(x_or_lat(:))-bufferpix*resx max(x_or_lat(:))+bufferpix*resx];
ylim = [min(y_or_lon(:))-bufferpix*resy max(y_or_lon(:))+bufferpix*resy];

% Rows and columns of pixels to read:
rows=find((y>=ylim(1))&(y<=ylim(2)));
cols=find((x>=xlim(1))&(x<=xlim(2)));


%% Display message if region of interest is partly or wholly outside the image region:

if isempty(rows)||isempty(cols)
    error('Interpolation coordinates are outside the bounds of the tiff.')
end

rows=sort(rows([1 end]));
cols=sort(cols([1 end]));

x=x(cols(1):cols(end));
y=y(rows(1):rows(end));


% Read image and ready for interpolation:
A = imread(filename,'PixelRegion',{rows cols});
if ~ismatrix(A)
    assert(FrameNumber<=size(A,3),['You have requested a frame number that exceeds the dimensions of ',filename])
    A = squeeze(A(:,:,FrameNumber));
    if ~framedeclared
        disp([filename,' has multiple frames. You have not told me which frame you want, so I am interpolating only the first slice.'])
    end
end
A = double(A); % Because interpolation doesn't work with some fancy integer formats.
A(A==NaNVal) = NaN;

% Interpolate:
Ai = interp2(x,y,A,x_or_lat,y_or_lon,interpmethod);


if showmap
    imagesc(A,'XData',x,'YData',y)
    colormap(gray(256))
    colorbar
    axis tight xy image
    try
        xlabel(['easting (',I.UOMLength,')'])
        ylabel(['northing (',I.UOMLength,')'])
    catch
        xlabel('easting')
        ylabel('northing')
    end
    hold on

    % Plot interpolation points:
    markersize = 6;
    if numel(x_or_lat)<12
        markersize = 10; % If there are only a few points, make them stand out.
    end
    plot(x_or_lat,y_or_lon,'b.','markersize',markersize)
end

    function I=jp2tiffinfo(fname)


        fid=fopen(fname,'r','ieee-be');
        %JPg2000 info: http://www.jpeg.org/public/15444-1annexi.pdf
        %geojp2 info: http://www.lizardtech.com/download/geo/geotiff_box.txt

        while ~feof(fid)
            lbox=fread(fid,1,'uint32');
            type=fread(fid,[1 4],'uint8=>char');
            lbox=lbox-8;
            if lbox==1
                lbox=fread(fid,1,'uint64');lbox=lbox-8;
            end
            if strcmp(type,'uuid')
                uuid=fread(fid,[1 16],'uint8=>char');
                lbox=lbox-16;
                geo=sprintf('\xb1\x4b\xf8\xbd\x08\x3d\x4b\x43\xa5\xae\x8c\xd7\xd5\xa6\xce\x03');
                if strcmp(uuid,geo)
                    fout=fopen('.temp.tif','w');
                    contents=fread(fid,lbox,'uint8');lbox=0;
                    fwrite(fout,contents);
                    fclose(fout);
                    fclose(fid);
                    I=geotiffinfo('.temp.tif');
                    m=imfinfo(fname); % a little silly to use imfinfo when i already have a tag reader
                    I.Height=m.Height;
                    I.Width=m.Width;
                    delete('.temp.tif');
                    return
                end
            end
            fseek(fid,lbox,0);
        end
        fclose(fid);
    end
end