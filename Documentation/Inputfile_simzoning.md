# Instructions to setup SimZoning input files

Input parameters for the zoning processes and location of necessary files are defined in a file extention .zon

The file adopts the JSON format syntax.

The following fields should be included in the file:

### Main parameters
* CaseStudy
  - String
  - Usage: String defining the name of this analysis. This text is used when naming result files and also in automatically generated reports.
  - Example: "CaseStudy":"Brazilian case study",

* RunSimulations
  - Boolean: 1 (=yes) or 0 (=no)
  - Usage: This option allows the user to run (1) or to skip (0) simulations. This is useful when the user is developing further zoning alternatives based on the same simulation results available from a previous analysis. As simulations are time-consuming, skipping simulations allows saving time in new analysis. If the user selects skipping simulations, but such results are not found in the expected folder, simzoning will return an error.
  - Example: "RunSimulations": 1,

* GridSize_IDW
  - Integer
  - Usage: Define the number of the grid elements used in the whole zoning area to perform interpolation. 
  - Example: "GridSize_IDW":150, 

* Interpolation_Method
   - Integer: 1(=ANN), 2(=Elevation and coordinates)
   - Usage: This option indicates the choosen interpolation method. Two methods are available, 1) Based on Artificial Neural Networks(ANN) and 2) based on the an weighted interpolation based on values, coordinates and elevations of the nearby points. Method 2 is reccomended as it results in lower interpolation erros for most cases, but users can try both methods and assess which one performs better for their particular case. 
  - Example: "Interpolation_Method":2,
  
* Report_generation
   - Boolean: 1 (=yes) or 0 (=no)
   - Usage: User option to generate a .PDF report for each case study. Available only when running simzoning from Matlab command line ( MATLABR2022b, and the toolboxes: Deep Learning, Mapping, Matlab Report Generator, Statistic and Machine Learning). If the user adopts the compiled version simzoning.exe, Report_generation should be set to 0.
   - Example: "Report_generation":1,

### Paths
* mainProjectFolder
  - String
  - Usage: Set the folder where simzoning routines, .zon file and sub folder are located.
  - Example: "mainProjectFolder": "C:/simzoning/",

* BuildingIDFPath
  - String
  - Usage: Set the folder where EnergyPlus models (.idf) are located.
  - Example: "BuildingIDFPath": "C:/simzoning/IDFS/BRAZIL_IDFS/",

* SimresultsOUTPUTpath
  - String
  - Usage: Set the folder containing raw simulation results (time series) in .csv and .txt formats. These files are only needed if the option RunSimulations is set to 0.
  - Example: "SimresultsOUTPUTpath": "C:/simzoning/Simulations_SZ/",

* Aggregated_Simesults_Path
  - String
  - Usage: Folder containing aggregated simulation results
  - Example: "Aggregated_Simesults_Path":"./simresults/", 

* EPlusPath
  - String 
  - Usage: Folder with the EnergyPlus executable.
  - Example: "EPlusPath": "C:/EnergyPlusV8-7-0/",

* WeatherPath
  - String 
  - Usage: Weather folder of the simulation program. Simzoning will copy to these location the required files to perform simulations placed by the user in the project subfolder "Weatherfiles".
  - Example: "WeatherPath": "C:/EnergyPlusV8-7-0/WeatherData/",

### Simulation settings
* Predifined_listofweatherfiles
  - Boolean: 1 (=yes) or 0 (=no)
  - Usage: User option to predefine a list of weather files to run simulations. This list can be defined using prefix. In case there is not a predefined list of weather files, simzoning can identify which weather files fall inside the area of study and near the boundaries.
  - Example: "Predifined_listofweatherfiles": 1,

* Weatherfiles_searching_prefix
  - String
  - Usage: This option is useful when the user has many files in the "Weatherfiles" subfolder and only wants to use some of them which are related to the location under evaluation. This string will be used if the parameter Predifined_listofweatherfiles is set to 1. 
  - Example: "Weatherfiles_searching_prefix":["*BRA_*.epw"],

* WeatherSource
  - String
  - Usage: This option indicates the weather files type used in the study. This option is useful when different sets of weather types are adopted.
  - Example:  "WeatherSource":"TMYx20072021",
  
* run_simulations_with_all_climates
  - Boolean: 1 (=yes) or 0 (=no)
  - Usage: User option to run simulations with all-weather files, or just a defined number. This option is usefull for testing.
  - Example: "run_simulations_with_all_climates": 1,
   
 *  jmin
    - Integer
    - Usage: User option to run simulations with specific weather files from a list. jmin is a number indicating the first weather file used for simulation from all selected weather files, and Maxi_Num_of_climates_for_simulation is a number indicating the last one. This option  will be used if the parameter run_simulations_with_all_climates is set to 0. It is usefull to complete time-consuming simulations and to perform tests.
    - Example: "jmin": 1,
  
  *  Maxi_Num_of_climates_for_simulation
     - Integer
     - Usage: User option to run simulations with specific weather files from a list. Maxi_Num_of_climates_for_simulation is a number indicating the last weather file from a list used for simulation. This option  will be used if the parameter run_simulations_with_all_climates is set to 0. It is usefull to complete time-consuming simulations and to perform tests.
     - Example: "Maxi_Num_of_climates_for_simulation": 5,
     
  * Num_of_cores
    - Integer
    - Usage: If your computer have multiple CPUs, simzoning can run multiple simulations in parallel to reduce computation time. Num_of_cores is the number of dedicated processors for simulation chosen by the user.
    - Example: "Num_of_cores":2,
    
### Extraction of simulation results 
         
  * Num_of_cores
      - Integer
      - Usage: If your computer have multiple CPUs, simzoning can run multiple simulations in parallel to reduce computation time. Num_of_cores is the number of dedicated processors for simulation chosen by the user.
       - Example: "Num_of_cores":2,
       
  * PerformanceIndicator
      - String
      - Usage: Performance indicators used as input for clustering. 
      - Example:"PerformanceIndicator": ["Cooling", "Heating", "MGR" "Overheating", "Cold discomfort"],

  * PerformanceIndicator_Zones_order
       - String
       - Usage: Performance indicator used to define the number of each zone in increasing order. 
       - Example: "PerformanceIndicator_Zones_order": ["Cooling"],
       
  * PerformanceIndicator_Units
       - String
       - Usage: Performance indicators units used in figures and reports, these units must follow the same order of Performance indicators.
       - Example: "PerformanceIndicator_Units": ["(kWh/m<sup>2</sup>.a)", "(kWh/m<sup>2</sup>.a)", "(%)", "(%)", "(%)"],
       
   * Building_Zones_considered_for_ PerformanceIndex_calculation
       - String
       - Usage: The name of the building’s zones used to calculate performance requiring hourly values(e.g. Thermal comfort, MGR). (These
names should match the variables described in the EnergyPlus output reports)
       - Example: "Building_Zones_considered_for_ PerformanceIndex_calculation": ["R1","R2","LIVINGKITCH"],
       
   * Building_Zones_occupation_Schedule
       - String
       - Usage: The name of the schedule of each room used to calculate performance requiring hourly values(e.g. Thermal comfort, MGR). They should follow the same order of building zones considered for performance calculation.
       - Example: "Building_Zones_occupation_Schedule": [SCH_OCUP_DORM, SCH_OCUP_DORM, SCH_OCUP_SALA],

  * Conditioning_type_tag
    - String
    - Tags of the .idf name used to identify models with natural ventilation and HVAC systems. This information is required to calculate the appropriate Performance indicator for each model.
    - Example: "Conditioning_type_tag": ["HVAC","NV"],
      
  * Row_heating_cooling
    - String
    - Usage: Row of the EnergyPlus output report  (*Table.csv)  containing heating and cooling annual load.
    - Example:" Row_heating_cooling": ["49","50"],
  
  * Column_heating_cooling
    - Integers
    - Usage: Column of the EnergyPlus output report  (*Table.csv) containing heating and cooling annual load.
    - Example:" Row_heating_cooling": ["3","2"],
      
  * Line_EPW
    - Integer
    - Usage: Line containing the EPW file name in the Energyplus output report (*Table.csv).
    - Example: "Line_EPW":["5","5"],

### Zoning settings
  * Macrozones_divisions
    - Boolean: 1 (=yes) or 0 (=no)
    - Usage: User option to divide the area of study in Macrozones prior to the definition of Zones, also called Subzones.
    - Example:"Macrozones_divisions": 1,
    
  * NumberofZones
    - Integer
    - Usage: Number of climatic zones, used when Macrozones are not required. This value will be used if Macrozones_divisions is set to 0.
    - Example:"NumberofZones":6,
    
  * Number_of_subzones
    - Integer
    - Usage: In case the Macrozone option is selected, each macrozone will be divided into a specific number of zones also called "subzones". In the Brazilian case study, the first macrozone is the coldest, where heating represents at least 5% of cooling load, (considering ideal loads). If the user adopts a different criteria to define macrozones, some adjustmenst are required in the script "simzoning_g1_Cluster_data" line 26.
    - Example:"Number_of_subzones":[“4”,”3”],
    
  * Zoning_isolated_locations
    - Boolean: 1 (=yes) or 0 (=no)
    - Usage: User option to perform clustering based on the locations where simulations were performed.
    - Example:"Zoning_isolated_locations":1,
    
  * Zoning_interpolated_PerfData_IrregularGrid
    - Boolean: 1 (=yes) or 0 (=no)
    - Usage: User option to perform clustering based on locations provided by the user. E.g. Municipalities. If the locations of weather files for simulation and the points provided by the user don't match, simzoning will interpolate performance data to generate the clusters.
    - Example:"Zoning_interpolated_PerfData_IrregularGrid":1,
    
  * IrregularGrid_exceeds_areaofstudy
    - Boolean: 1 (=yes) or 0 (=no)
    - Usage: User option to indicate if the points of the irregular grid provided by the user exceeds the area of study, if so, the shape file of the area of study will be used to filter data.
    - Example:"IrregularGrid_exceeds_areaofstudy":1,
     
  * Irregular_grid_input_dat
    - String
    - Usage: Name of the file contaning coordinates of points provided by the user to perform clustering. The file format should be .csv. The file should contain two columns named LAT and	LON as the example file named "MunicipiosBrasil.csv" and located in the /Simzoning/grid_input/ folder. 
    - Example:"Irregular_grid_input_dat":"MunicipiosBrasil.csv",
    
  * Zoning_interpolated_PerfData_RegularGrid
    - Boolean: 1 (=yes) or 0 (=no)
    - Usage: User option to perform clustering based on a regular grid. The resolution of the grid is defined by the user with the variable: GridSize_IDW.
    - Example:"Zoning_interpolated_PerfData_RegularGrid":1,
    
  * grid_of_points_exceeds_areaofstudy
    - Boolean: 1 (=yes) or 0 (=no)
    - Usage: User option to indicate if the simulation points exceed the area of study, if so, the shape file of the area of study will be used to filter data.
    - Example:"grid_of_points_exceeds_areaofstudy":1,    
      
 * AlternativeMethod_ for_comparison
    - Boolean: 1 (=yes) or 0 (=no)
    - Usage: Option to use an alternative method to compare clustering results using the MPMA index.
    - Example:"AlternativeMethod_ for_comparison":1,
    
  * Name_of_AlternativeMethod_for_comparison
    - String
    - Usage: User option to indicate the name of the Shape file of the alernative method used to comparison. The name must be the same of the Shapefile located in the folder C:\simzoning\GISfiles\CZ_Methods_Comparison\, without the extension .shp. Such shape file must contain a feature named “zone” containing a numeric value to identify climatic zones.
    - Example:"Name_of_AlternativeMethod_for_comparison":["DegreeDays_Brazil","GT_Brazil"],
    
  ### Area of study
  * ShapeFileName_AreaofStudy
    - String
    - Usage: Name of the shape file containing the limits of the area of study.
    - Example:"Area of study":"RS_SC_PR_SP.SHP",
      
  * AreaofStudyShapefile_Path
    - String
    - Usage: Folder containing the Shape file of the area of study
    - Example:"AreaofStudyShapefile_Path":"./GISfiles/AreaOfStudy/",
    
  * Elevation_file
    - String
    - Usage: Tiff file containing elevation data covering the area of study. Tiff files with projection data: WGS_1984_World_Mercator have been tested.
    - Example:"Elevation_file":"topografia1_ProjectRaster2.tif",
   
   
  ### Fonts, size of points (plotted in maps and figures)
  
  * sizeofpoints and sizeofpointsHDM
    - Integer
    - Usage: Size and strokes of figures may vary depending on the area of study, density of points and resolution of maps adopted by the user. If required, the user can adjust the size of points plotted in maps from the Json file. sizeofpoints and sizeofpointsHDM are integers ranging from 10 to 60 indicating the size of points plottet in maps. sizeofpoints is used in low resolution maps and sizeofpointsHDM is used in high resolution maps(Interpolated data).
    - Example:"sizeofpoints":30,
    
  * TitlefontSize, SubtitleFontSize, TextFontSize, LabelFontSize
    - Integer
    - Usage: Size fonts used for titles, subtitles, legends and labels of figures. These properties can be customized in case of need. Values can range from 10 to 30 
    - Example:"TitlefontSize": 25,
    
   
    
    
