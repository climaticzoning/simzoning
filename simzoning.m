% function rc = simzoning(input_file_name)

% for debugging, keep the first and the last lines of this file commented
% and use the line below to specify input_file_name (this file should be in
% the same folder of the source code.
input_file_name='brazil1.zon';

% to compile uncomment the first and last lines
% and comment the line above.
% use the Matlab ApplicationCompiler to create the .exe file
% after compilation, create a folder C:\Program Files\SimZoning
% place the executable in this folder
% add the folder to the PATH

% to run the program, use the WIndows Power Shell or command prompt
% go to the folder with the input file parameters
% the necessary simulation, climate and shape files must be in subfolder,
% see readme
% type: 
%           simzoning <name of the file.zon>



clearvars -except  input_file_name % erase all variables
tic % starts a stopwatch timer

version='1.0'


%create a log file 
DiaryName = strcat('simzoning_',input_file_name,'.log'); %L: strcat concatenate strings horizontally
if exist(DiaryName, 'file')
    delete(DiaryName); %L: delete existing log
end
diary(DiaryName) %L: creates a log of keyboard input and the resulting text output (an ASCII file)


%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% SimZoning
% versão 0.1
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

%% subrotine input
% load parameters from input file calling subroutine
[run_simulations,carryout_zoning,calculate_MPMA,generate_reports]...
    =simzoning_input(input_file_name); 

simzoning_constantes; % execute routine that create necessary constants

%% simulations

%% zoning

%% MPMA

%% reports 
 
%% finish program
diary off;
beep;
  rc=0;
% end
