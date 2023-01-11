# SimZoning
Toolbox for climatic zoning for building energy purposes.

### Scope
SimZoning provides a set of routines for the development and validation of performance-based climatic zoning.

### Dependancies
SimZoning requires the following applications.
  - MATLABR2022b, and the tolboxes: Deep Learning, Mapping, Matlab Report Generator, Statistic and Machine Learning, 
  - EnergyPlus Version 8.7

### Input data required
Users must provide the following data to this application:
  - Energy simulation models in the EnergyPlus format .idf
  - Weather data in the format .epw
  - Shape file of the area subject to zoning in the format .shp
  
### Optional input data
Simzoning can compare the performance of its zoning with other predefined alternative(s) available to the user. SimZoning calculates the MPMA validation metrics for all zoning options and produce reports comparing the results. The user should provide shape files of the alternative zoning options.

SimZoning can intermpolate sparse simulation results to predefined locations (e.g. to cities with no weather data). The user must provide a list of locations to be used in the interpolation.

### Features
  - capability to handle an arbitrary number of energy simulations models and weather files. 
  - multiple performance-indicators can be used in the definition of climatic zones.
  - three options of zoning resolution (from isolated points to regular grids).
  - two options of performance data interpolation (ANN and weighted interpolation of nearby points).
  - calculation of the mean percentage of likely misplaced areas/points (MPMA) to provide quantitative validation metrics for climatic zoning.
  - MPMA calculated using an arbitrary number of performance indicators, taken into account simultaneously. 
  - extensive automatic reports providing extensive documentation to stakeholder and facilitate quality assurance of every step of the process.
  - support to comparison with other zoning proposals by calculating MPMA based on shape files of other zoning proposals.

### Running SimZoning
On Matlab, go to the root folder of simzoning and start a new zoning analysis using:
```
simzoning inputfilename.zon
```

### Documentation
The structure of the input file and available options are described on Documentation/Inputfile_simzoning.md

Folders where necessary input data should be placed (idf files, epw files, shape files) are listed on Documentation/Paths.md

### Examples
Three examples of input files (and respective auxiliary folders and files) are provided with the source code:
* BRA_RGS.zon
* BRA_Brazil.zon
* USA.zon

These examples are described in the Documentation folder.

**Disclaimer: **
USA IDFs and all weather files provided just for demonstration purposes.
Please refer to DOE Commercial prototype building models (2016) and OneBuilding.Org for the original files.

### Theory 
Further information about the core methods adopted by SimZoning can be found at:
Angélica Walsh, Daniel Cóstola, Lucila C.Labaki, ʺPerformance-based climatic zoning method for building energy efficiency applications using cluster analysisʺ, Energy (255) 2022. https://doi.org/10.1016/j.energy.2022.124477

