function [MPMA_frequencyvalue]=MPMA_frequency(gridfile,save_pi_interpolated,...
    bin_number,number_of_simulationmodels,interpolation_method,save_pi_interpolatedmap)
%% this routine calculates MPMA for multiple performance indicators using
% the frequency of occurance in each region of the performance space


%% remove folder with previous interpolated result
dos ('rmdir gridresults /s /q');
mkdir gridresults;


%% load grid and classification file

% the file should have the first line with headers
%     LAT, 	LON, 	ALT, 	Zona_desempenho_GT
grid_mpma = readtable(gridfile,'ReadVariableNames',1);
grid_mpma_a = table2array(grid_mpma);
grid_mpma_a_coord=grid_mpma_a(:,1:3);
number_zones=max(grid_mpma_a(:,4));

%% calculate PMA
% this is not an elegant implementation, but it does work and shows
% how MPMA can be calculated using frequency of occurance in n-dimentions

%iterate through all models simulated
for PMA_calc = 1:number_of_simulationmodels
    messmodel=strcat('calculating PMA for simulation model: ',num2str(PMA_calc));
    fprintf(messmodel)
    %% load performance data for this model
    % the file should have the first line with headers
    % ID	EPW	lat	long	Altitude	performance1 performance 2 ...
    %     (such as Cooling	Heating	ColdDiscomfort	Overheating	MGR)
    % you need fo provide at least one performance indicador,
    %         and as many as you want
    PMA_calcstr=num2str(PMA_calc);
    performance_file=strcat('./simresults/perf_',PMA_calcstr,'.csv'); %L: strcat concatenates strings horizontally

    %% interpolate results from simulations to the whole grid

    if interpolation_method==1
        performance_grid=simzoning_f1_net_train(performance_file,grid_mpma_a_coord,save_pi_interpolatedmap);
    elseif interpolation_method==2
        performance_grid=simzoning_weighttopo1(performance_file,grid_mpma_a_coord,save_pi_interpolatedmap);
    end
    %% save interpolated data (if user defined variable indicates saving)
    if save_pi_interpolated==1
        csvwrite(strcat('./gridresults/perf_fullgrid_',PMA_calcstr,'.csv'),performance_grid);
    end

    % simzoning_h_Clustering

    %% problem size
    % calculate grid size and number of performance indicators
    [gridsize,number_of_pi]=size(performance_grid);

    %% initialize performance space
    % this is done by writting a string with the commands
    % and them executing the string.
    % this allows a variable number of performnace indicator
    % which requires a variable number of nested loops
    spacebinstr='spaceperformance (';
    for space_pi = 1:number_of_pi
        spacebinstr=strcat(spacebinstr,'1:bin_number,');
    end
    spacebinstr=strcat(spacebinstr,'1:number_zones)=0;');
    eval(spacebinstr);

    % calculate bin size for each performance indicator
    for bin_pi = 1:number_of_pi
        max_pi(bin_pi)= max(performance_grid(:,bin_pi));
        min_pi(bin_pi)= min(performance_grid(:,bin_pi));
        delta_pi=(max_pi(bin_pi)-min_pi(bin_pi));
        binsize(bin_pi)=delta_pi/bin_number;
    end

    %% position in the performnace space
    % calculate the position of each point in the performance space
    % scan each point, and each pi defining in which bin they belong
    % write string with the command and execute the string
    expression_string_1='spaceperformance(';
    for allocation_point = 1:gridsize %each point in the grid
        %check if the interpolation delivered a value at least for  pi=1
        if isnan(performance_grid(allocation_point,1))==0
            for allocation_pi = 1:number_of_pi % each pi for this point
                %subtract the min from the pi, divide by the bin size and
                %        get the rounded value closest to zero
                nbinreal=(performance_grid(allocation_point,allocation_pi)-...
                    min_pi(allocation_pi))/binsize(allocation_pi);
                if nbinreal~=bin_number % round of to smaller integer
                    bin_idpi=fix(nbinreal)+1; %get the integer
                end
                bin_idpistr=num2str(bin_idpi); % bin number for this pi
                % build the executable string
                expression_string_1=strcat(expression_string_1,bin_idpistr,',');
            end
            % once all pi are done for a point in the grid, finish the string
            expression_string_1=strcat(expression_string_1,...
                num2str(grid_mpma_a(allocation_point,4)),')');
            % execute the string, adding one to the performance space where
            % that point belongs.
            expression_string_2=strcat(expression_string_1,'=',expression_string_1,'+1;');
            eval(expression_string_2)
            % clear the string for the next loop
            expression_string_1='spaceperformance(';
        end
    end


    %% identify the dominant zone (max occurance in each bin range)

    %write several loops to go through each point in the performance space
    % as the number of perfomrnace indicators may change from case to case
    %the number of nested loops would change, so they are written as strings
    % and them the string is execute using eval
    loopstr=' ';
    endloopstr=' ';
    totpoints=' ';
    actionloopstr='spaceperformance(';
    for coverspace_pi = 1:number_of_pi %
        % add a loop for each pi in the string
        % loop start
        loopstr=strcat(loopstr,' for a',num2str(coverspace_pi),'=1:bin_number ');
        % loop middle part
        actionloopstr=strcat(actionloopstr,'a',num2str(coverspace_pi),',');
        % loop end
        endloopstr=strcat(endloopstr,' end; ');
    end
    %combine all loops
    actionloopstr=strcat(actionloopstr,'1:number_zones)');
    %used the combined loops to calculate PMA
    actionmaxstr=strcat(' pmaabs=pmaabs+sum(',actionloopstr,...
        ')-max(',actionloopstr,'); totpoints=totpoints+sum(',actionloopstr,');');
    % finish building string
    loopgo=strcat(loopstr,actionmaxstr,endloopstr);

    % execute string
    pmaabs=0;
    totpoints=0;
    eval(loopgo);

    %% calculate PMA
    pma(PMA_calc)=pmaabs/totpoints;

    %% calculate PMA check ignoring NaN
    totpoints1=0;
    for allocation_point = 1:gridsize %each point in the grid
        %check if the interpolation delivered a value at least for  pi=1
        if isnan(performance_grid(allocation_point,1))==0
            totpoints1=totpoints1+1;
        end
    end
    pma1(PMA_calc)=pmaabs/totpoints1;


    % end of the calculaiton for this simulation model, proceed to next one
end

%% calculate MPMA
MPMA_frequencyvalue=sum(pma)/number_of_simulationmodels;

%% write output
fileID = fopen(strcat('./gridresults/MPMA.txt'),'wt');
fprintf(fileID,'%4.2f',MPMA_frequencyvalue);
fclose(fileID);

save(strcat('./gridresults/MPMA_frequency_data.mat')); %L: cria arquivo com variáveis do workspace
pma1=transpose(pma1);
csvwrite(strcat('./gridresults/PMA.csv'),pma1);



end

% it would be possible to avoid some of the loops using one matrix per zone
% z1perf=spaceperformance(:,:,:,:,:,1);
% z2perf=spaceperformance(:,:,:,:,:,2);
%....
%and then getting the max from each matrix (the operation only works with
% two matrices at time...
% zmaxperf=max(z1perf,z2perf);
% zmaxperf=max(zmaxperf,z3perf);
% zmaxperf=max(zmaxperf,z4perf);
% zmaxperf=max(zmaxperf,z5perf);
%...
% then sum all zone matrces
%zsumperf=z1perf+z2perf+z3perf+z4perf+z5perf+z6perf+z7perf+z8perf+z9perf+z10perf;
% and subtract the max from the sum
%resid=zsumperf-zmaxperf;
% them sum all terms of the matrix
%pma_alt=sum(sum(sum(sum(sum(resid,1),2),3),4),5);


