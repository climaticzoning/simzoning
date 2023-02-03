clearvars
%% USER DEFINED variables
% user option to save each interpolated performance data in a file (1=yes)
save_pi_interpolated=1;
% user option to save each interpolated map in a file
save_pi_interpolatedmap=1;
% number of bins per pi
bin_number=20;
%%HARDCODED: replace by variable  (it should scan folder with results
% number of result files, one per simulaiton model

dos('rmdir gridresults /s/q');
mkdir gridresults;
%%
load ImputVariables.mat

if AlternativeMethod_for_comparison==1;
    ZoningAlternative_bins_name=horzcat( 'Regular_Grid',  Name_of_AlternativeMethod_for_comparison' ) ;
else
    ZoningAlternative_bins_name={'Regular_Grid'};
end

for z=1:numel(ZoningAlternative_bins_name)
    % Performance interpolated Matrix
    Nameofcsv{z}=char(strcat('Zoning_based_on',{' '},ZoningAlternative_bins_name{z},'.csv'));
    F=readtable(Nameofcsv{z});
    if  ismember(F.Properties.VariableNames,'Zone')
        F.Zone=[];
    end
    grid_mpma_file=char(strcat('Zoning_based_on',{' '},ZoningAlternative_bins_name{z},'_MPMA.csv'));% Coordinates and Zone

    %%
    number_of_simulationmodels=(size(F,2)-4)/numel(PerformanceIndicator);% Number of simulation models

    G=readtable(grid_mpma_file);
    grid_mpma_a=table2array(G);
    number_zones=max(grid_mpma_a(:,end));
    grid_mpma_a_coord=grid_mpma_a(:,1:3);

    for PMA_calc = 1:number_of_simulationmodels
        messmodel=strcat('calculating PMA for simulation model: ',num2str(PMA_calc));
        fprintf(messmodel)
        %% load performance data for this model
        % the file should have the first line with headers
        % ID	EPW	lat	long	Altitude	performance1 performance 2 ...
        %     (such as Cooling	Heating	ColdDiscomfort	Overheating	MGR)
        % you need fo provide at least one performance indicador,
        %         and as many as you want

        number_of_pi=numel(PerformanceIndicator);
        PMA_calcstr=num2str(PMA_calc);
        performance_Matrix=table2array(F(:,4:end-1));
        PInd=1:numel(PerformanceIndicator):size(performance_Matrix,2);
        performance_grid=performance_Matrix(:,PInd(PMA_calc):(PInd(PMA_calc)+numel(PerformanceIndicator)-1));% Performance grid for each model
        gridsize=length(performance_grid);

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
        pma2{z}=  pma

        %% calculate PMA check ignoring NaN
        totpoints1=0;
        for allocation_point = 1:gridsize %each point in the grid
            %check if the interpolation delivered a value at least for  pi=1
            if isnan(performance_grid(allocation_point,1))==0
                totpoints1=totpoints1+1;
            end
        end
        pma1(PMA_calc)=pmaabs/totpoints1;


        % end of the calculation for this simulation model, proceed to next one
        % end

        %% calculate MPMA
        MPMA_frequencyvalue{z}=sum(pma)/number_of_simulationmodels;

        %% write output
        fileID = fopen(strcat('./gridresults/MPMA.txt'),'wt');
        fprintf(fileID,'%4.2f',MPMA_frequencyvalue{z});

        fclose(fileID);

        save(strcat('./gridresults/MPMA_frequency_data.mat')); %L: cria arquivo com variáveis do workspace
        pma1=transpose(pma1);

        csvwrite(strcat('./gridresults/PMA.csv'),pma1);
    end
end

load imputvariables
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
% Figures
cd Figures\MPMA\
f1 = figure('visible','off');
bar(cell2mat(MPMA_frequencyvalue)*100)
set(gca,'xticklabel',ZoningAlternative_bins_name,'TickLabelInterpreter','none')% ylim([0 max(MPMA)+1 ])
ylabel('MPMA using bin method (%)')
title('MPMA for each clustering alternative (Bin method)',Interpreter="none")
subtitle(ZoningAlternatives_name_label,Interpreter="none")
print('MPMA for each clustering alternative Bin method', '-dpng');
close all force;


