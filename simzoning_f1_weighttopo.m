
%% interpolate performance data based on 4 surrounding points
%inputs: long, lat, alt, performance as simulated

% REQUIRES
% excel file perf.xls                   PERFORMNCE DATA
% or datafile PIsTMYx20072021.mat       PERFORMNCE DATA   Produced by 'simzoning_e_ExtractSimResults'

% excel file muni.xlsx                  DATA of municipios to be used in predictions
% or data file gridforInterp_muni.mat   DATA of municipios to be used
% in predictions  Produced by 'simzoning_f_GRIDwithinShapefile'

%import data in perf matlab table
% file={'perff4.csv','Matrix0509.csv'}
% perf = readtable(file{2},'Range','a1:fh300');
% perf=perf(perf.idx==0,:)
%% remove folder with previous interpolated result
dos ('rmdir gridresults /s /q');
mkdir gridresults;
perf=Table4cluster(:,2:end);
perf.Properties.VariableNames([1 2 3]) = {'alt' 'lat' 'long'};
perfa = table2array(perf);

% % extract a vector for each variable for easier manupulation
y=perfa(:,2); % lat
x=perfa(:,3); % long
z=perfa(:,1); % alt
%import names of EPW files
% nameepw = readtable(file{2},'Range','fi1:fi300');
nameepw=Table4cluster(:,1);
% nameepw=nameepw(perf.idx==0,:)
nameepw.Properties.VariableNames([1]) = {'municipio'};
data=rmmissing(data);
listagrid=data; %LAT, LON, ALT
municipiosa = table2array(listagrid);
x1=municipiosa(:,2); %lat   %% LON
y1=municipiosa(:,1); %long   %% LAT
z1=municipiosa(:,3); %alt     %% ALT
%number of performance points and unicipios
[numeromuni,var]=size(x1);
[numeroepw,var]=size(x);

%% testing
%for testing, use the number of the line of the municpio in the excel file
%minus one, so you can see one municipio at a time.
%     countmuni=3;
%convert table to array for easier manipulation
% for

%% loop all municipios
%if you want to run one municpio only, comment the next line and the
%corresponting end of the loop, keep all the rest inside the loop
%uncommented

for countmuni=1:numeromuni
    countmuni;
    %get long, lat and alt of the municipio x,y,z locais
    xlocal=x1(countmuni);
    ylocal=y1(countmuni);
    zlocal=z1(countmuni);
    % set a temporary distance between the point under analysis, it is kust
    % initialization, it needs to be a large values
    thrsdist=10;
    q1dist=thrsdist;
    q2dist=thrsdist;
    q3dist=thrsdist;
    q4dist=thrsdist;
    %iterate through all locations with performance data, looking for the
    %closest point in each quadrant. 4 points will be selected at the end, one
    %in each quadrant. the municipio is on 0,0
    %                    |
    %                    |
    %        Q2          |             Q1
    %                    |
    %                    |
    %------------------------------------------------
    %                    |
    %                    |
    %                    |
    %        Q3          |             Q4
    %                    |
    %                    |
    for countepw=1:numeroepw % for each location with performance data
        %calculate the horizontal distance between the municipio and the
        %location with performance data
        dist(countmuni,countepw)=sqrt(((x(countepw)-xlocal)^2)+(y(countepw)-ylocal)^2);
        if dist(countmuni,countepw)<10.1 % avoid using points too far away in the interpolation

            %check in which quadrant this location with performance is placed, in relation to the municipio
            if x(countepw)>xlocal
                if y(countepw)>ylocal
                    %if it belongs to this quadrant, check is this location is
                    %closest than the closest location in this quadrant so far
                    if dist(countmuni,countepw)<q1dist
                        % if it is the closest, store (overwrite) the distance, the
                        % performance and the altitude difference between the
                        % municipio and the location with performance data
                        q1dist=dist(countmuni,countepw); %distance
                        quadrante1=perfa(countepw,:); %performance
                        q1id=countepw; %id of the performance point, equal to the line in the excel file -1
                        q1z=zlocal-z(countepw); %difference in altitude
                        %                    quadrante1(1)=zlocal;
                        %                    quadrante1(2)=ylocal;
                        %                    quadrante1(3)=xlocal;
                    end
                else %the process is similar to other quadrants
                    if dist(countmuni,countepw)<q4dist
                        q4dist=dist(countmuni,countepw);
                        quadrante4=perfa(countepw,:);
                        q4id=countepw;
                        q4z=zlocal-z(countepw);
                        %                    quadrante2(1)=zlocal;
                        %                    quadrante2(2)=ylocal;
                        %                    quadrante2(3)=xlocal;
                    end
                end
            else
                if y(countepw)>ylocal
                    if dist(countmuni,countepw)<q2dist
                        q2dist=dist(countmuni,countepw);
                        quadrante2=perfa(countepw,:);
                        q2id=countepw;
                        q2z=zlocal-z(countepw);
                        %                    quadrante3(1)=zlocal;
                        %                    quadrante3(2)=ylocal;
                        %                    quadrante3(3)=xlocal;
                    end
                else
                    if dist(countmuni,countepw)<q3dist
                        q3dist=dist(countmuni,countepw);
                        quadrante3=perfa(countepw,:);
                        q3id=countepw;
                        q3z=zlocal-z(countepw);
                        %                    quadrante4(1)=zlocal;
                        %                    quadrante4(2)=ylocal;
                        %                    quadrante4(3)=xlocal;
                    end
                end
            end
        end
    end

    %check if a point is close to the limit of the country and do not have
    %points in all quadrants.
    %find the closest point
    tmp1=[q1dist,q2dist,q3dist,q4dist];
    [minxy,idxy]=min(tmp1); %   idxy identifies the quadrant with closest point
    closestquadrant = strcat('quadrante',num2str(idxy));
    closestquadrantz = strcat('q',num2str(idxy),'z');
    closestquadrantid = strcat('q',num2str(idxy),'id');
    %check if the distance between points in any quadrant is still identical
    %to the initialization value. if yes, assign values of the closest point
    if q1dist==thrsdist
        q1dist=minxy;
        quadrante1=eval(closestquadrant);
        q1id=eval(closestquadrantid);
        q1z=eval(closestquadrantz);
    end
    if q2dist==thrsdist
        q2dist=minxy;
        quadrante2=eval(closestquadrant);
        q2id=eval(closestquadrantid);
        q2z=eval(closestquadrantz);
    end
    if q3dist==thrsdist
        q3dist=minxy;
        quadrante3=eval(closestquadrant);
        q3id=eval(closestquadrantid);
        q3z=eval(closestquadrantz);
    end
    if q4dist==thrsdist
        q4dist=minxy;
        quadrante4=eval(closestquadrant);
        q4id=eval(closestquadrantid);
        q4z=eval(closestquadrantz);
    end

    % interpolate
    %find difference in altitude min and max
    tmp=[q1z,q2z,q3z,q4z];
    %sumz=sum(tmp);
    maxz=max(tmp);
    minz=min(tmp);
    %calculate the max absolute altitude difference, to be used to normalize
    %altitude differences
    dz=max(maxz,abs(minz));
    %dz=sumz; %testing another definition of the weight factor
    % %
    % %    %recalculate hight difference
    % %         q1z=q1z-minz;
    % %         q2z=q2z-minz;
    % %         q3z=q3z-minz;
    % %         q4z=q4z-minz;

    %calculate weight factors related to distance
    % this compare the sum of the distances of all points combined (under
    % the fraction) and the distance excluding the point in the quadrant.
    % if the municipio and the point are close, the upper and lower part of
    % the fraction will be almost identical, and the weight factor will be
    % close to one.  If they are far away, the weight factor will become
    % smaller.
    factordist=4; %extraweight for closer points
    wq1d=((q2dist+q3dist+q4dist)/(q1dist+q2dist+q3dist+q4dist))^factordist;
    wq2d=((q1dist+q3dist+q4dist)/(q1dist+q2dist+q3dist+q4dist))^factordist;
    wq3d=((q1dist+q2dist+q4dist)/(q1dist+q2dist+q3dist+q4dist))^factordist;
    wq4d=((q1dist+q2dist+q3dist)/(q1dist+q2dist+q3dist+q4dist))^factordist;
    %weight height. it compares the difference in altitude between the
    %municpio and the point in the quadrant, in relation to the largest
    %difference in height. if the point in the quadrant are in the same
    %altitude, this weight factor is closer to one, otherwise it gets
    %smaller.
    wq1h=1-(abs(q1z)/dz);
    wq2h=1-(abs(q2z)/dz);
    wq3h=1-(abs(q3z)/dz);
    wq4h=1-(abs(q4z)/dz);

    %combined weights. multiply the two weight factors to get a single factor
    %for each quadrant.
    %as the altitude tends to have a higher importance in our analysis, it is
    %possible to increase the role of the weight factor related to
    %altitude-height in the combined one.
    %This increase needs to be tunned (at the moment manutally, but this can be
    %automated later)
    waltitu=3; %extra weight to altitude value. manipulate if needed.
    pesoq1=wq1d*wq1h^waltitu;
    pesoq2=wq2d*wq2h^waltitu;
    pesoq3=wq3d*wq3h^waltitu;
    pesoq4=wq4d*wq4h^waltitu;
    %sum of all weight factors
    sumpeso=pesoq1+pesoq2+pesoq3+pesoq4;

    %rearrenge weights so they add up to 1
    pesoq1=pesoq1/sumpeso;
    pesoq2=pesoq2/sumpeso;
    pesoq3=pesoq3/sumpeso;
    pesoq4=pesoq4/sumpeso;
    sumpeso=pesoq1+pesoq2+pesoq3+pesoq4;

    % calculate the interpolated data multiplying the performance data for each quadrant by
    % the corresponding weighting factor, and dividing by the sum of weighting
    % factors.
    localdata(countmuni,:)=(quadrante1*pesoq1+quadrante2*pesoq2+...
        quadrante3*pesoq3+quadrante4*pesoq4)/sumpeso;
    localdata(countmuni,3)=xlocal;
    localdata(countmuni,2)=ylocal;
    localdata(countmuni,1)=zlocal;

end
%% Editing and saving interpolated data
Perf_model_variables=Table4cluster.Properties.VariableNames(5:end);
d=localdata(:,2:end);
d(:,1)=table2array(data(:,1));
d(:,2)=table2array(data(:,2));
ALTITUDE_GRID=table2array(data(:,3));
d=[ALTITUDE_GRID,d];
Table4clusters_Interpolated=array2table(d,'VariableNames',{'ALT','LAT','LON',Perf_model_variables{:}});
cd(mainProjectFolder)
cd simresults
NameofMatrix{grid}=char(strcat('Table4clusters_Interp_',Zoning_grid_type{grid},'.mat'));
save(NameofMatrix{grid},'Table4clusters_Interpolated')
Interpolated_data=array2table(d,'VariableNames',{'ALT','LAT','LON',Perf_model_variables{:}});
Interpolated_data=rmmissing(Interpolated_data);
%% Plotting and saving Performance interpolated maps
cd ..
cd (OutputFolderFigures_Interpolation)
for j=1:numel(PerformanceIndicator)
    f1 = figure('visible','off');
    geoscatter(d(:,2),d(:,3),sizeofpoints,d(:,3+j),'filled','DisplayName','Interpolated data')
    hold on
    legend1 = legend;
    set(legend1,'Interpreter','none','FontSize',LabelFontSize);
    title('Performance interpolated and original locations', FontSize=TitlefontSize)
    colorbar
    Ylabel=char(strcat(PerformanceIndicator{j},PerformanceIndicator_Units{j}));
    ylabel(colorbar,Ylabel,'FontSize',LabelFontSize);
    Subti=char(strcat(PerformanceIndicator{j}, {' '}, 'interpolated data'));
    subtitle(Subti,FontSize=SubtitleFontSize)
    geoscatter(perf.lat,perf.long,70,'*k','DisplayName','Locations where simulations were performed');
    set(gcf, 'Position', get(0, 'Screensize'));
    Namefig=char(strcat(PerformanceIndicator{j},{' '},'Performance map',Zoning_grid_type{grid}));
    print(Namefig, '-dpng')
    close all force
end
cd (mainProjectFolder)
clear d
clear data
cd(mainProjectFolder)

