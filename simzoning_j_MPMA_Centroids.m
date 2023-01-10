
% Requires
% Matrix containing LAT, LON, Performance data, Zone
load('ImputVariables.mat')
% Index of selected climatic zoning resolution options defined by the user
% a) Clusters based on points, b) clusters based on custom grid (e.g.
% Municipalities), c) Regular grid, and d) Alternative methods for
% comparison

ZoningAlternative_idx=logical(ZoningAlternatives');
Zoning_grid_type=Zoning_grid_type(ZoningAlternative_idx);
if AlternativeMethod_for_comparison==1
    Zoning_grid_type=[Zoning_grid_type;Name_of_AlternativeMethod_for_comparison];
end

for z=1:numel(Zoning_grid_type)
    % reading the matrix with the format ALT LAT LON PERFORMANCE
    Nameofcsv=char(strcat('Zoning_based_on',{' '},Zoning_grid_type{z},'.csv'));
    F=readtable(Nameofcsv);
    % Number of simulation models
    number_of_simulationmodels=(size(F,2)-4)/numel(PerformanceIndicator);
    F = removevars(F, 'ALT');
    % CENTROIDS CALCULATION
    St=grpstats( F(:,3:end) ,'Zone','mean' );
    Cluster_Centroid=table2array(St(:,3:end));
    data=table2array(F(:,3:end-1));
    % Zone
    Zona=double(F.Zone);
    % Latitude and longitude
    LAT=F.LAT;
    LON=F.LON;

    matrix=1;
    if number_of_simulationmodels==1
        c=1;
        % Matrix of centroids
        C=Cluster_Centroid(:,[c:c+numel(PerformanceIndicator)-1]);
        % Matrix of performance data
        X=data(:,[c:c+numel(PerformanceIndicator)-1]);
        % function idx = findNearestCentroid(C,X) %#codegen
        [~,idx1] = pdist2(C,X,'euclidean','Smallest',1); % Find the nearest centroid
        a(:,matrix)=Zona==idx1';% comparering the orginal zoning and the nearest Neighbor of each Centroid
        % Percentage of misclassified points
        MPMA_Centroides(z,matrix)=(1-(sum(a(:,matrix))/size(data,1)))*100;
        fclose all
        matrix=matrix+1;
    else
        % When there are multiple models
        for c=1:numel(PerformanceIndicator):length(Cluster_Centroid)-1
            % Matrix of centroids
            C=Cluster_Centroid(:,[c:c+numel(PerformanceIndicator)-1]);
            % Matrix of performance data
            X=data(:,[c:c+numel(PerformanceIndicator)-1]);
            % function idx = findNearestCentroid(C,X) %#codegen
            [~,idx1] = pdist2(C,X,'euclidean','Smallest',1); % Find the nearest centroid
            a(:,matrix)=Zona==idx1';%  comparering the orginal zoning and the nearest Neighbor of each Centroid
            % Percentage of misclassified points
            MPMA_Centroides(z,matrix)=(1-(sum(a(:,matrix))/size(data,1)))*100;
            fclose all
            matrix=matrix+1;
        end
    end
    clear a
    % Calculating the Mean Percentage of misclassified points
    MPMA_centroides(1,z)=mean(MPMA_Centroides(z,:));
    % Naming the outputs
    if  Macrozones_divisions==1
        %% Number of zones of each Macrozone
        nm=str2double(Number_of_subzones{1}); % number of zones in mixed zone
        nc=str2double(Number_of_subzones{2}); % number of Zones in cooling dominated area
        ZoningAlternatives_name_label=char(strcat('Macrozones with',{' '},num2str(nm),{' '}, 'and',{' '},num2str(nc),{' '},'Zones'));
    elseif  Macrozones_divisions==0
        nc=Number_of_Zones;
        nm=0;
        ZoningAlternatives_name_label=char(strcat('with',{' '},num2str(nc),{' '},'Zones'));
    end
end
% Plotting results
if sum(MPMA_centroides)>0
    f1 = figure('visible','off');
    cd Figures\MPMA\
    bar( MPMA_centroides,'BarWidth', 0.5);
    ylim([0 max(MPMA_centroides)+1 ])
    ylabel('MPMA_centroides using centroids (%)', Interpreter='none')
    set(gca,'xticklabel',Zoning_grid_type,'TickLabelInterpreter','none')
    title('MPMA for each clustering alternative (Centroid method)')
    subtitle(ZoningAlternatives_name_label,Interpreter="none")
    print('MPMA_centroides for each clustering alternative', '-dpng')
end
close all force;
cd(mainProjectFolder)
