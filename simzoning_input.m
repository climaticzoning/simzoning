function [run_simulations,carryout_zoning,calculate_MPMA,generate_reports]...
    =simzoning_input(input_file_name)

% Open input file
jsonData = jsondecode(fileread(input_file_name)) %L: jsondecode: decode JSON-formatted text

% assign data structures from json file to variables in Matlab
run_simulations=jsonData.run_simulations;
carryout_zoning=jsonData.carryout_zoning;
calculate_MPMA=jsonData.calculate_MPMA;
generate_reports=jsonData.generate_reports;
end
