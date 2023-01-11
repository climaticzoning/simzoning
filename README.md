# SimZoning
Toolbox for climatic zoning for building energy purposes.

On Matlab, go to the root folder of simzoning and start a new zoning analysis using:
```
simzoning inputfilename.zon
```

The structure of the input file and available options are described on Documentation/Inputfile_simzoning.md
The folder where necessary input data should be placed (idf files, epw files, shape files) is listed on Documentation/Paths.md

Three examples of input files (and respective auxiliary folders and files) are provided with the source code:
* BRA_RGS.zon
* BRA_Brazil.zon
* USA.zon

These examples are described in the Documentation folder.

Please cite as:
Angélica Walsh, Daniel Cóstola, Lucila C.Labaki, ʺPerformance-based climatic zoning method for building energy efficiency applications using cluster analysisʺ, Energy (255) 2022. https://doi.org/10.1016/j.energy.2022.124477

Disclaimer:
USA IDFs and all weather files provided just for demonstration purposes.
Please refer to DOE Commercial prototype building models (2016) and OneBuilding.Org for the original files.
