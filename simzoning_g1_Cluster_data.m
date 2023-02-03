% This script groups data based on the kmeans clustering
% It requires
% 1. An option for clustering a) With macrozones or b) without macrozones
% 2. Number of zones/subzones
% 3. Performance indicators to be considered in the zoning process
% 4. A dominant performance indicator to number zones
% All settings are included in the .Zon file


if Macrozones_divisions==1
    %% Number of zones of each Macrozone
    nm=str2double(Number_of_subzones{1}); % number of zones in mixed zone
    nc=str2double(Number_of_subzones{2}); % number of Zones in cooling dominated area
    % Name of the main output figure
    fig_subtitle=char(strcat('Macrozones divisions with',{' '},num2str(nm),{' '}, 'and',{' '},num2str(nc),{' '},'Zones'));
else
    % Number of zones based on the zoning alternative: without macrozones
    nc=Number_of_Zones;
    nm=0;
    % Name of the main output figure
    fig_subtitle=char(strcat('Zoning with',{' '},num2str(nc),{' '},'Zones'));
end

if Macrozones_divisions==1
    % If required, a macrozone division can be defined based on the relationship between heating and cooling of a particular model
    hc=(Table4cluster.(5)./Table4cluster.(4))*100;
    idx=hc>=0.5;% This index identifies macrozones based on the relationship between heating and cooling for a given model
    % Cold Zone definition
    if sum(hc)>0% condition
        ColdRegionLtlon=Table4cluster(idx,1:3);% Alt Lat and Long data
        % clustering data using nm zones
        [ColdRegionClusters,centroids1]=kmeans(PerfMatrix(idx,:),nm,'Replicates',100);
        ColRegionID=(1:numel(ColdRegionClusters))';% ID
        % A Matrix containing performance data, cluster results and ID
        m=[PerfMatrix(idx,:), ColdRegionClusters];
        % converting array to table
        m=array2table(m);
        m.Properties.VariableNames={Table4cluster.Properties.VariableNames{4:end},'clusters'};
        % A sorting index used to rename the Zones
        PerformSortingINdex = ~cellfun(@isempty, regexp(m.Properties.VariableNames,PerformanceIndicator_Zones_order,'ignorecase'));% This index is used to identify models with Natural ventilation.
        Pos=find(PerformSortingINdex);
        % Summary Statistics of each zone to rename zones based on a
        % Performance indicator defined by the user (Dominant performance indicator, e.g. Cooling load)
        St=grpstats(m ,'clusters',"mean" );
        SortingIndex=char(strcat('mean_',m.Properties.VariableNames{Pos(1)}));% It takes the first model with the dominant performance indicator defined by the user
        c=sortrows(St,SortingIndex);
        c.idx=(1:nm)';
        m.Zone=(1:size(m,1))';% New name of zones
        m.clusters=double(m.clusters);
        c.clusters=double(c.clusters);
        for h=1:nm
            NewZone=c.idx(c.clusters==h);
            NewZoneName=double(NewZone);
            m.Zone(m.clusters==h)=NewZoneName;
        end
        ColdRegionMatrix=m;
        clear m
        E2=[ColdRegionLtlon,ColdRegionMatrix];
    end

    %% Definition of cooling dominated region
    if sum(~idx)>0
        Cooling_dominated=PerfMatrix(~idx,:);
        Cooling_dominatedLatlong=Table4cluster(~idx,1:3);% Alt Lat and long data
        % clustering data using nc zones
        [Cooling_dominatedRclusters,centroids2]=kmeans(Cooling_dominated(:,:),nc,'Replicates',100);
         % matrix containing performance data, clusters and id
        m=[Cooling_dominated,Cooling_dominatedRclusters];
        % converting array to table
        m=array2table(m);
        % naming columns
        m.Properties.VariableNames={Table4cluster.Properties.VariableNames{4:end},'clusters'};
        % identifying sorting column
        PerformSortingINdex = ~cellfun(@isempty, regexp(m.Properties.VariableNames,PerformanceIndicator_Zones_order,'ignorecase'));% This index is used to identify models with Natural ventilation.
        Pos=find(PerformSortingINdex);
        % Getting matrix stats
        St=grpstats(m ,'clusters',"mean" );
        % Sorting matrix to rename zones in ascending order based o a
        % Performance indicator defined by the user
        SortingIndex=char(strcat('mean_',m.Properties.VariableNames{Pos(1)}));
        c=sortrows(St,SortingIndex);
        % New nomenclature of zones considering both macrozones
        c.idx=((nm+1):(nm+nc))';
        % preallocating zones
        m.Zone=(1:size(m,1))';
        % original cluser name
        m.clusters=double(m.clusters);
        c.clusters=double(c.clusters);
        % loop to rename zones
        for h=1:nc
            NewZone=c.idx(c.clusters==h);
            NewZoneName=double(NewZone);
            m.Zone(m.clusters==h)=NewZoneName;
        end
        CdrLlong=Cooling_dominatedLatlong;
        % final matrix with ALT LAT LON performance clusters and zones
        E1=[CdrLlong,m];
    end

    %% Matching macrozones
    if exist('E2','var') && exist('E1','var')
        %Adding lat and long to Performance data of Macrozone 1
        E=[E1;E2];% Matrix containing all Macrozones
        %         E=rmmissing(E);%  removes missing entries from the table
    end
    if exist('E1','var') && ~exist('E2','var')
        E=E1;% Matrix containing all Macrozones
        %         E=rmmissing(E);%  removes missing entries from the table
    end
    if exist('E2','var') && ~exist('E1','var')
        E=E2;
        %         E=rmmissing(E);%  removes missing entries from the table
    end
end

if Macrozones_divisions==0
    Latlong=Table4cluster(:,1:3);% Alt Lat and long data
    [Cooling_dominatedRclusters,centroids2]=kmeans(PerfMatrix(:,:),nc,'Replicates',100);% clustering for this region
    %     Cooling_dominatedRID=(1:numel(Cooling_dominatedRclusters))';% ID
    m=[PerfMatrix,Cooling_dominatedRclusters];
    m=array2table(m);
    m.Properties.VariableNames={Table4cluster.Properties.VariableNames{4:end},'clusters'};
    PerformSortingINdex = ~cellfun(@isempty, regexp(m.Properties.VariableNames,PerformanceIndicator_Zones_order,'ignorecase'));% This index is used to identify models with Natural ventilation.
    Pos=find(PerformSortingINdex);
    St=grpstats(m ,'clusters',"mean" );
    SortingIndex=char(strcat('mean_',m.Properties.VariableNames{Pos(1)}));
    c=sortrows(St,SortingIndex);
    c.idx=((nm+1):(nm+nc))'; % Nomenclature of zones considers the sequence of existing macrozones
    m.Zone=(1:size(m,1))';
    m.clusters=double(m.clusters);
    c.clusters=double(c.clusters);
    for h=1:nc
        NewZone=c.idx(c.clusters==h);
        NewZoneName=double(NewZone);
        m.Zone(m.clusters==h)=NewZoneName;
    end

    E=[Latlong,m];

end
color=jet(nm+nc);
%% Saving the matrix with Performance data for MPMA calculations (Centroids)
% E.ID=[];
E.clusters=[];
Nameofcsv=char(strcat('Zoning_based_on',{' '},Zoning_grid_type{z},'.csv'));
writetable(E,Nameofcsv)

%% Saving the matrix with the format used to calculate MPMA (Bins method)
NameofcsvMPMA=char(strcat('Zoning_based_on',{' '},Zoning_grid_type{z},'_MPMA.csv'));
matrixclusters=[E.LAT,E.LON,Table4cluster.ALT,E.Zone];
matrixclusters=rmmissing(matrixclusters);
matrixclusters=array2table(matrixclusters,'VariableNames',{'LAT','LON','ALT','Zona_desempenho_GT'});
writetable( matrixclusters,NameofcsvMPMA)

%% Map of clustering
f = figure('visible','off');
colors=jet(nm+nc);
for zon=1:(nm+nc)
    idx=E.Zone==zon;
    F=E(idx,:);
    geoscatter(F.LAT,F.LON, sizeofpoints,colors(zon,:),'filled', 'MarkerEdgeColor','k','DisplayName',num2str(zon))
    hold on
    legend1 = legend;
    set(legend1,'Interpreter','none','FontSize',LabelFontSize);
    title(legend1,'Zones');
end
set(gcf, 'Position', get(0, 'Screensize'))
geobasemap('topographic')

titlef=char(strcat('Performance based climatic zoning', {' '},Zoning_grid_type{z}));
title(titlef,'FontSize',TitlefontSize, Interpreter='none')
subtitle(fig_subtitle,'FontSize',SubtitleFontSize, Interpreter='none')
set(gcf, 'Position', get(0, 'Screensize'));
cd (OutputFolderFigures_ClusterResults)

if Macrozones_divisions==1
    NameofFig=char(strcat(Zoning_grid_type{z},{' '},'with Macrozones zoning'));
else
    NameofFig=char(strcat(Zoning_grid_type{z},{' '},'zoning'));
end
print(NameofFig, '-dpng')
close all force;
f = figure('visible','off');
tile = tiledlayout(3,length(PerformanceIndicator));
% It creates the layout based on the number of Performance indicators to be displayed in the same Figure
colors=flip(jet(nm+nc));
l=0;
for PI=1:length(PerformanceIndicator)
    nexttile([3 1])
    warning('off','stats:boxplot:BadObjectType')
    h=boxplot(E.((4+l)),E.Zone,"ColorGroup",E.Zone,'colors','k');
    l=l+1;
    title_f=char(strcat(PerformanceIndicator{PI}));
    perf_units=char(strcat(PerformanceIndicator{PI}, PerformanceIndicator_Units{PI}));
    ylabel(perf_units, 'FontSize',LabelFontSize)
    xlabel('Zones(-)', 'FontSize',LabelFontSize)
    title(title_f, 'FontSize',TitlefontSize)
    h = findobj(gca,'Tag','Box');
    for j=1:length(h)
        patch(get(h(j),'XData'),get(h(j),'YData'),colors(j,:),'FaceAlpha',.5);
    end
    set(gcf, 'Position', get(0, 'Screensize'))
    sgtitle('Performance variation per zone', 'FontSize',TitlefontSize)
end
% Name of figures
if Macrozones_divisions==1
    NameofFig=char(strcat(Zoning_grid_type{z},{' '},'with Macrozones zoning boxplot'));
else
    NameofFig=char(strcat(Zoning_grid_type{z},{' '},'zoning boxplot'));
end
cd (OutputFolderFigures_ClusterResults)
print(NameofFig, '-dpng')
close all force;
cd(mainProjectFolder)