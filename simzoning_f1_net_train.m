function [performance_grid]=simzoning_f1_net_train(performance_file,grid_mpma_a_coord,save_pi_interpolatedmap)

%% remove folder with previous interpolated result

save_pi_interpolatedmap=0;
% grid_mpma_a_coord=table2array(data);
%convert lines in collumns
grid_mpma_a_coord=transpose(grid_mpma_a_coord);
% improved to calculate best number of nodes



%% ANN to interpolate (and extrapolate in some cases) performance data
%inputs: long, lat, alt, performance as simulated

% REQUIRES
% excel file perf.xls        PERFORMNCE DATA
% excel file muni.xlsx       DATA of municipios to be used in predictions

%import data in perf matlab table
% only one performance at a time.

perf = readtable(performance_file,'ReadVariableNames',1);
% performance_file='testttt';
% perf=Table4cluster;

number_of_pi=5; % to discart the collumns of id, epw name, lat, long, alt
pi5(:,:)=perf(:,5:end); % %%%%%%%%%%%%hardcoded
coord(:,1:3)=perf(:,2:4);
%rename collumns of the table
%perf.Properties.VariableNames([1 2 3]) = { 'lat' 'long' 'alt'};
% make a copy of the table as an array, to facilitate some operations
coorda = table2array(coord);
pi5a = table2array(pi5);

% it is not possible to use all performance indicators in the same ann,
% but it could be possible to use data from all models regarding one
%performance indicator to build a single ANN.
% in this case, data needs to be scaled between 0 and 1,
% enable the following line and add extra lines in other parts of the code
%where results are calculated using the ann.

%perf.cool=perf.cool/max(perf.cool)


% extract a vector for each variable
% y=perfa(:,2); % lat
% x=perfa(:,3); % long
% z=perfa(:,1); % alt


% % plot the performance
% f1 = figure('Name','performance Data as simulated');
% scatter(x,y,15,p,'filled')
% colorbar
% movegui(f1,[0 400]);
%
% f12 = figure('Name','simulated performance');
% plot(p)
% movegui(f12,[0 0]);



% identify minimum and maximum for long, lat and alt, as the ann cannot be
% used later to get data out of this range
maxlat=max(coorda(:,1));
minlat=min(coorda(:,1));
maxlong=max(coorda(:,2));
minlong=min(coorda(:,2));
maxalt=max(coorda(:,3));
minalt=min(coorda(:,3));

% %set collumns to be used as input in the ann
% inputs(:,1)=x %long
% inputs(:,2)=y %lat
% inputs(:,3)=z %alt

%set collumn to be used as the predicted value once the ann is trained
targets = transpose(pi5a);
inputs=transpose(coorda);
% make several anns changing the number of nodes.
meanRMSE(1:10,1:5)=0; %for each number of nodes and pi
for nodenumber = 1:10

    %for each number of nodes, make the ann several times (attempts)
    for attempt = 1:3

        %create the ann with nodenumber hidden nodes
        %net = feedforwardnet([nodenumber*5 nodenumber*5]); %chnge the number of nodes in steps of 5 nodes
        net = feedforwardnet(nodenumber*5);
        %avoid ann windows pop-up
        net.trainParam.showWindow = 0;   % <== This does it

        % train the ann (time consuming part)
        % 70% dos dados para treinamento, 15% dos dados são para validação, e 15%
        [net,tr] = train(net,inputs,targets);
        %calculate output for this ann
        outputexisting = net(inputs);
        %calculate RMSE for this attempt and number of nodes and store


        for picount = 1:5


            RMSEfinal(picount) = sqrt(mean((targets(picount,:) - outputexisting(picount,:)).^2));
            meanRMSE(nodenumber,picount)=RMSEfinal(picount)+meanRMSE(nodenumber,picount);

        end


    end
    %calculate the final mean RMSE for this number of nodes considering all
    %atempts
    for picount = 1:5

        meanRMSE(nodenumber,picount)=meanRMSE(nodenumber,picount)/attempt;

    end
end

%decide which number of nodes gives the smallest meanRMSE
[bestRMSE, bestnode] = min(meanRMSE(:,1));

% Setup Division of Data for Training, Validation, Testing
% For a list of all data division functions type: help nndivision
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 80/100;
net.divideParam.valRatio = 10/100;
net.divideParam.testRatio = 10/100;

%bestnode=2;

% train one ann using the best number of nodes and proceed
%net = feedforwardnet([bestnode*10 bestnode*10 bestnode*10]);

% use this line to have two hidden layers with 10*bestnode each
% net = feedforwardnet([bestnode*10 bestnode*10 bestnode*10]);

performance_grid1=0;
for attempt = 1:10

    %create the ann with nodenumber hidden nodes
    net = feedforwardnet(bestnode*5); %chnge the number of nodes in steps of 10 nodes
    %avoid ann windows pop-up
    net.trainParam.showWindow = 0;   % <== This does it
    % train one ann using the best number of nodes and proceed
    %net = feedforwardnet([bestnode*5 bestnode*5]);


    % train the ann (time consuming part)
    % 70% dos dados para treinamento, 15% dos dados são para validação, e 15%
    [net,tr] = train(net,inputs,targets);
    %calculate output for this ann
    performance_grid = net(grid_mpma_a_coord);
    performance_grid1 = performance_grid1+performance_grid;
    %calculate RMSE for this attempt and number of nodes and store
end
performance_grid=performance_grid1/10;


%restore default ann windows pop-up
net.trainParam.showWindow = 1;   % <== This does it

performance_grid=transpose(performance_grid);

%% plot maps
if save_pi_interpolatedmap==1

    %convert lines in collumns
    grid_mpma_a_coord=transpose(grid_mpma_a_coord);

    for piplot=1:number_of_pi
        f6 = figure('visible','off');
        geoscatter(grid_mpma_a_coord(:,1),grid_mpma_a_coord(:,2),11,performance_grid(:,piplot),'filled');
        % colormap(map)
        colorbar
        simfile=performance_file(14:strlength(performance_file)-4);
        title(strcat('interpolated ann - file: ',simfile,' performance indicator: ',' ',num2str(piplot)));
        saveas(gcf,strcat('./Figures/Interpolation/interp_ann_',simfile(),'_perfindicator_',num2str(piplot),'.jpg'),'jpg');
        close(f6);
    end

    for piplot=1:number_of_pi
        % plot the performance
        f1 = figure('visible','off');
        geoscatter(coorda(:,1),coorda(:,2),15,pi5a(:,piplot),'filled');
        colorbar
        simfile=performance_file(14:strlength(performance_file)-4);
        title(strcat('simdata - file: ',simfile,' performance indicator: ',' ',num2str(piplot)));
        saveas(gcf,strcat('./Figures/Interpolation/simdata_',simfile(),'_perfindicator_',num2str(piplot),'.jpg'),'jpg');
        close(f1);

    end

end

end
