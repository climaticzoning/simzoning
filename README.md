# SimZoning
Toolbox for climatic zoning for building energy purposes.

### Scope
SimZoning provides a set of routines for the development and validation of performance-based climatic zoning.

### Pre-compiled release
The easiest way to use SimZoning is to download the pre-compiled Release available on this GitHub page. See instructions there on how to set the program.

### Source code ependancies
If you want to run SimZoning directly from the sourcecode, it requires the following applications.
  - MATLABR2022b, and the tolboxes: Deep Learning, Mapping, Matlab Report Generator, Statistic and Machine Learning, 
  
### Dependancies
SimZoning relies on energy simulation data to understand how climatic variables affect buildinsg, allowing the combined assessment of all climatic variables and providing means to understand the weight of each variable in the zoning process. The source code can be modified to use any building nergy simulation program. The curent version provides support to EnergyPlus, so this program must be available in the computer runing SimZoning.
  - EnergyPlus is required (use a version compatible with the .idf files adopted by the user).

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

### Running SimZoning from the pre-comliped executable release
**From Windows command line:**
Go to the root folder of simzoning and start a new zoning analysis using:

```
simzoning inputfilename.zon
```

**From sourcecode:**
On Matlab, go to the root folder of simzoning and start a new zoning analysis using the same command described above. Matlab will run SimZoning as a matlab function. 

### Documentation
The structure of the input file and available options are described on Documentation/Inputfile_simzoning.md

Folders where necessary input data should be placed (idf files, epw files, shape files) are listed on Documentation/Paths.md

### Examples
Three examples of input files (and respective auxiliary folders and files) are provided with the source code:
* BRA_RGS.zon
* BRA_Brazil.zon
* USA.zon

These examples are described in the Documentation folder. Note that different examples require different EnergyPlus versions.
Samples of output reports for each example are available in the Outputs folder.

All weather files, simulation models and GIS shape files required to run these exemples are provided with this source code.

**Disclaimer:**

USA IDFs and all weather files provided just for demonstration purposes.
Please refer to DOE Commercial prototype building models (2016) and OneBuilding.Org for the original files.

### Theory 
Further information about the core methods adopted by SimZoning can be found at:
Angélica Walsh, Daniel Cóstola, Lucila C.Labaki, ʺPerformance-based climatic zoning method for building energy efficiency applications using cluster analysisʺ, Energy (255) 2022. https://doi.org/10.1016/j.energy.2022.124477

A description of updated procedures for the calculation of MPMA and features shown in the BRA_Brazil example is current under review and will be provided in due time. 
