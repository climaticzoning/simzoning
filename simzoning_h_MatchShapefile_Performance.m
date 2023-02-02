% This script match interpolated performance data with climatic zones of
% alternative methods for comparison
% REQUIRES
% A shape file with the climatic zone classification containing a feature
% named 'zone' using numerical data

% Import performance data
cd simresults\
load ('C:\simzoning\simresults\Table4clusters_Interp_Regular_Grid.mat')
cd ..
cd GISfiles\CZ_Methods_Comparison\
e=1;
% Interpolated data
m= Table4clusters_Interpolated;
% %extract variables from the matrix
lat_0 = m.LAT;
lon_0 = m.LON;

for m=1:numel(Name_of_AlternativeMethod_for_comparison)
    shpfile=char(strcat(Name_of_AlternativeMethod_for_comparison(m),'.shp'));
    % Read the first shape file from the list
    S=shaperead(shpfile);
    % convert shape file data to structure
    ShapeData=struct2table(S);
    % converting zones to categorical
    ShapeData.zone=categorical(ShapeData.zone);

    %% Finding performance data falling in each zone
    numberOfZones=size(S);
    for z=1: numberOfZones(1)
        % identifying each zone and its polygons
        index=ShapeData.zone==num2str(z);

        polygon2_y = S(index).X;
        polygon2_x = S(index).Y;
        polygon2_x = polygon2_x.';
        polygon2_y = polygon2_y.';

        [in,on] = inpolygon(lat_0 ,lon_0,polygon2_x,polygon2_y);        % Logical Matrix
        inon = in | on;                                             % Combine ‘in’ And ‘on’
        idx = find(inon(:));                                        % Linear Indices Of ‘inon’ Points
        latcoordA{e,z} = lat_0(idx);                                        % X-Coordinates Of ‘inon’ Points
        loncoordA{e,z} = lon_0(idx);
        % creating a matrix with performance data en each zone
        Matrix_Z{z}=Table4clusters_Interpolated(idx,:);
        Matrix_Z{z}.Zone(:)=z;

    end
    % Merging all matrix
    ZP=vertcat(Matrix_Z{:});
    % cleanning data
    ZP=rmmissing(ZP);
    cd ..
    cd ..
    % creating a matrix with LAT, LON, ALT AND ZONE to calculate the MPMA
    % using the bins method
    TableMPMA=table(ZP.LAT,ZP.LON,ZP.ALT,ZP.Zone, 'VariableNames',{'LAT','LON','ALT','Zone'});
    Nameofcsv2=char(strcat('Zoning_based_on',{' '},Name_of_AlternativeMethod_for_comparison{m},'_MPMA.csv'));%Interpoalted
    writetable(TableMPMA,Nameofcsv2)

    % Creating a matrix with LAT, LON, ALT, PERFORMANCE DATA AND ZONE to calculate the MPMA
    % using the centroid method.
    Nameofcsv=char(strcat('Zoning_based_on',{' '},Name_of_AlternativeMethod_for_comparison{m},'.csv'));
    writetable(ZP,Nameofcsv)
    f1=figure('Visible','off');
    % Figure
    Nameofzones=categorical(ZP.Zone);
    Zones=categories(Nameofzones);
    colors=jet(numel(Zones));
    % Ploting maps
    for zon=1:numel(Zones)
        idx=ZP.Zone==str2num(Zones{zon});
        F=ZP(idx,:);
        geoscatter(F.LAT,F.LON, sizeofpoints,colors(zon,:),'filled', 'MarkerEdgeColor','k','DisplayName',Zones{zon});
        hold on
        legend1 = legend;
        set(legend1,'Interpreter','none','FontSize',LabelFontSize);
        title(legend1,'Zones');
    end
    set(gcf, 'Position', get(0, 'Screensize'))
    geobasemap('topographic')
    title(Name_of_AlternativeMethod_for_comparison{m},'FontSize',TitlefontSize,'Interpreter', 'none')
    geobasemap('topographic')
    subtitle(CaseStudy,'FontSize',SubtitleFontSize,'Interpreter', 'none')
    set(gcf, 'Position', get(0, 'Screensize'))
    cd Figures\CZ_Methods_Comparison\
    % saving fifure
    print(Name_of_AlternativeMethod_for_comparison{m}, '-dpng')
    fclose all
    % Plotting boxplots
    f = figure('visible','off');
    tile = tiledlayout(3,length(PerformanceIndicator));
    % It creates the layout based on the number of Performance indicators to be displayed in the same Figure
    colors2=flip(jet(numel(Zones)));
    l=0;
    % Setting warning off
    warning('off','stats:boxplot:BadObjectType');
    for PI=1:length(PerformanceIndicator)
        nexttile([3 1])
        h=boxplot(ZP.((4+l)),ZP.Zone,"ColorGroup",ZP.Zone,'colors','k');
        l=l+1;
        title_f=char(strcat(PerformanceIndicator{PI}));
        perf_units=char(strcat(PerformanceIndicator{PI}, PerformanceIndicator_Units{PI}));
        ylabel(perf_units,"FontSize",LabelFontSize)
        xlabel('Zones(-)',"FontSize",LabelFontSize)
        title(title_f,FontSize=TitlefontSize)
        h = findobj(gca,'Tag','Box');
        for j=1:length(h)
            patch(get(h(j),'XData'),get(h(j),'YData'),colors2(j,:),'FaceAlpha',.5);
        end
        set(gcf, 'Position', get(0, 'Screensize'))
    end
    sgtitle('Performance Variation per zone')
    NameofFig=char(strcat(Name_of_AlternativeMethod_for_comparison{m},{' '},'zoning boxplot'));

    print(NameofFig, '-dpng')
    fclose all

    cd (mainProjectFolder)
    cd GISfiles\CZ_Methods_Comparison\

end




