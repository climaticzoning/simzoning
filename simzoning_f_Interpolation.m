
% This script interpolates data considering 2 grid resolutions.
% a) Irregular grid, e.g. Municipalities
% b) Regular grid
% It adopts two interpolation methods.
%1) Artificial Neural Network
%2) Method based on coordinates (Altitude, longitude and latitude)

clearvars
load ImputVariables

ZoningAlternatives=[Zoning_isolated_locations;Zoning_interpolated_PerfData_IrregularGrid;Zoning_interpolated_PerfData_RegularGrid];

%% Resolution a) Irregular grid provided by user. e.g. Municipalities
if ZoningAlternatives(2,1)>0
    grid=2;  z=2;
    cd grid_input\
    clear d data
    load gridforInterp_muni.mat % Grid with municipalities
    cd ..
    cd simresults
    %     load agreggated simulation results
    load  (Aggregatesimmresults)
    % input data for ANN Interpolation method
    performance_file='Simresults.csv';
    % converting table to array
    grid_mpma_a_coord=table2array(data);
    % option to save interpolated results in the grid output folder
    save_pi_interpolatedmap=1;
    cd(mainProjectFolder)
    % Interpolation method 1, based on Artificial Neural Network
    if interpolation_method==1
        performance_grid=simzoning_f1_net_train(performance_file,grid_mpma_a_coord,save_pi_interpolatedmap);
        % Outputs
        Perf_model_variables=Table4cluster.Properties.VariableNames(5:end);
        Interp_matrix_ANN=[grid_mpma_a_coord,performance_grid];
        Table4clusters_Interpolated=array2table( Interp_matrix_ANN,'VariableNames',{'LAT','LON','ALT',Perf_model_variables{:}});
        % Reorder matrix 
        Table4clusters_Interpolated = movevars(Table4clusters_Interpolated, "ALT", "Before", "LAT");
        % saving outputs in the simresults folder
        cd simresults\
        save('Table4clusters_Interp_Municipalities.mat',"Table4clusters_Interpolated")
        cd ..
        % Interpolation method 2, based on COORDINATES, ALT, LAT AND LON
    elseif interpolation_method==2
        cd (mainProjectFolder)
        % Script that interpolates data using altitude, latitude, longitude
        simzoning_f1_weighttopo
    end
end
%% Resolution b) Regular grid 
clearvars
load ImputVariables
% Zoning based on regular grid
if ZoningAlternatives(3,1)>0
    grid=3;
    cd simresults\
    z=3;
    clear d
    clear data
    load RegularGrid.mat % Regular grid
    %     load agreggated simulation results
    load  (Aggregatesimmresults)
    % input data for ANN Interpolation method
    performance_file='Simresults.csv';
    % converting table to array
    grid_mpma_a_coord=table2array(data);
    % option to save interpolated results in the grid output folder
    save_pi_interpolatedmap=1;
    cd (mainProjectFolder)
    % Interpolation method 1, based on Artificial Neural Network
    if interpolation_method==1
        % Interpolation
        performance_grid=simzoning_f1_net_train(performance_file,grid_mpma_a_coord,save_pi_interpolatedmap);
        % Outputs
        Perf_model_variables=Table4cluster.Properties.VariableNames(5:end);
        % Interpolated data  [LAT LON ALT PERFORMANCE]
        Interp_matrix_ANN=[grid_mpma_a_coord,performance_grid];
        % SAVING DATA AS A TABLE
        Table4clusters_Interpolated=array2table( Interp_matrix_ANN,'VariableNames',{'LAT','LON','ALT',Perf_model_variables{:}});
        Table4clusters_Interpolated = movevars(Table4clusters_Interpolated, "ALT", "Before", "LAT");
        cd simresults\
        % DATA STORED IN THE SIMRESULT FOLDER
        save('Table4clusters_Interp_Regular_Grid.mat',"Table4clusters_Interpolated")
        cd ..
        % Interpolated data to plot maps
        d=table2array(Table4clusters_Interpolated);
        % Simulation results for each climate
        perf=Table4cluster;
        % open Interpolation figure folder to save figures
        cd (OutputFolderFigures_Interpolation)
        % PLOTTING INTERPOLATED DATA FOR EACH PERFORMANCE INDICATOR FOR
        % QUALITY ASSURANCE
        for j=1:numel(PerformanceIndicator)
            f1 = figure('visible','off');
            geoscatter(d(:,2),d(:,3),50,d(:,3+j),'filled','DisplayName','Interpolated data')
            hold on
            legend1 = legend;
            set(legend1,'Interpreter','none','FontSize',LabelFontSize);
            title('Performance interpolated and original locations','FontSize',TitlefontSize)
            colorbar
            Ylabel=char(strcat(PerformanceIndicator{j},PerformanceIndicator_Units{j}));
            ylabel(colorbar,Ylabel,'FontSize',LabelFontSize);
            Subti=char(strcat(PerformanceIndicator{j}, {' '}, 'interpolated data'));
            subtitle(Subti,"FontSize",SubtitleFontSize)
            geoscatter(perf.LAT,perf.LON,60,'*k','DisplayName','Locations where simulations were performed');
            set(gcf, 'Position', get(0, 'Screensize'));
            Namefig=char(strcat(PerformanceIndicator{j},{' '},'Performance map',Zoning_grid_type{grid}));
            print(Namefig, '-dpng')
            close all force
        end
        cd ..
    elseif interpolation_method==2
        % Interpolation method based on coordinates Altitude, Latitude and
        % Longitude
        simzoning_f1_weighttopo
    end
end

cd (mainProjectFolder)