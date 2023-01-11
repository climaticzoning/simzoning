Input parameters for the zoning processes and location of necessary files are defined in a file extention .zon

The following fields can be described in this file.

<table style="table-layout: fixed; width: 60%">
<colgroup>
<col style="width: 1%" />
<col style="width: 20%" />
<col style="width: 1%" />
<col style="width: 3%" />
<col style="width: 28%" />
<col style="width: 0%" />
<col style="width: 2%" />
<col style="width: 38%" />
<col style="width: 1%" />
<col style="width: 2%" />
</colgroup>
<thead>
<tr class="header">
<th colspan="2"><strong>Input data (Variable)</strong></th>
<th colspan="3"><strong>Example</strong></th>
<th colspan="3"><strong>Description</strong></th>
<th></th>
<th></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td colspan="2">"CaseStudy":</td>
<td colspan="3">"South Region of Brazil "</td>
<td colspan="3">Case study Name</td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td colspan="2">"RunSimulations":</td>
<td colspan="3">(1=yes), (0=no)</td>
<td colspan="3">This option allows to run or to skip simulations.</td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td colspan="2">"GridSize_IDW":</td>
<td colspan="3">Any number e.g 50</td>
<td colspan="3">Size of the grid to perform interpolation.</td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td colspan="2">"Interpolation":</td>
<td colspan="3">(1=yes), (0=no)</td>
<td colspan="3">User option to interpolate data. Interpolation is
required to perform clustering using zoning resolution b<strong><u>)
Interpolated data using irregular grid and c) Interpolated data using
regular grid</u></strong></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td colspan="2">"Interpolation_Method"</td>
<td colspan="3">(1=ANN), (2=Elevation and coordinates)</td>
<td colspan="3">This option allows to choose an interpolation method.
Two methods are available, 1) Based on ANN and 2) based on Coordinates
and elevation of each point.</td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td colspan="8"><strong>Paths</strong></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td colspan="2"><strong>Input data (Variable)</strong></td>
<td colspan="3"><strong>Example</strong></td>
<td colspan="3"><strong>Description</strong></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td colspan="2">"mainProjectFolder":</td>
<td colspan="3">"C:/simzoning/",</td>
<td colspan="3">Main folder of simzoning</td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td colspan="2">"BuildingIDFPath":</td>
<td colspan="3">"C:/simzoning/IDFS/",</td>
<td colspan="3">Folder of IDFs used for simulation</td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td colspan="2">"SimresultsOUTPUTpath":</td>
<td colspan="3">"C:/simzoning/Simulations_SZ/",</td>
<td colspan="3">Folder containing simulation results in .csv format and
.txt format</td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td colspan="2">"Aggregated_Simesults_Path":"</td>
<td colspan="3">"C:/simzoning/simresults/",</td>
<td colspan="3">Folder containing aggregated simulation results</td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td colspan="2">"EPlusPath":</td>
<td colspan="3">"C:/EnergyPlusV8-7-0/",</td>
<td colspan="3">EnergyPlus folder</td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td colspan="2">"WeatherPath"</td>
<td colspan="3">e.g. "C:/EnergyPlusV8-7-0/WeatherData/",</td>
<td colspan="3">Weather folder of the simulation program</td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td colspan="8"><strong>Simulation settings</strong></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td colspan="2">"Predifined_listofweatherfiles":</td>
<td colspan="3">(1=yes), (0=no)</td>
<td colspan="3">User option to predefine a list of weather files to run
simulations. This list can be defined using prefix. In case there is not
a predefined list of weather files, the program can identify which
weather files fall inside the area of study and near the
boundaries.</td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td colspan="2">"Weatherfiles_searching_prefix":</td>
<td colspan="3"><p>["*_ SC_*.epw","*_SP_*.epw",</p>
<p>"*_RS_*.epw","*_PR_*.epw"],</p></td>
<td colspan="3">This option is useful when the user knows the weather
files available for the area of study, and will be used if the
Predifined_listofweatherfiles=1</td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td colspan="2">"WeatherSource":</td>
<td colspan="3">e.g. "TMYx20072021",</td>
<td colspan="3">This option indicates the weather files type used in the
study</td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td colspan="2">"run_simulations_with_all_climates":</td>
<td colspan="3">(1=yes), (0=no)</td>
<td colspan="3">User option to run simulations with all-weather
files</td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td colspan="2">"jmin":</td>
<td colspan="3">1,</td>
<td colspan="3">First weather file for simulation(from a list)
adopted.</td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td colspan="2">"Maxi_Num_of_climates_for_simulation":</td>
<td colspan="3">10,</td>
<td colspan="3">Last weather file selected to run simulations(from a
list).</td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td colspan="2">"Num_of_cores":</td>
<td colspan="3">4,</td>
<td colspan="3">If your computer has multiple CPUs, simzoning will run
multiple simulations in parallel to reduce computation time.</td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td colspan="8"><strong>Extraction of simulation results</strong></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td colspan="2">"PerformanceIndicator":</td>
<td colspan="3">["Cooling", "Heating", "MGR" "Overheating",
"Cold discomfort"],</td>
<td colspan="3">Performance indicators used for clustering</td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td colspan="2">"PerformanceIndicator_Zones_order":</td>
<td colspan="3">["Cooling"],</td>
<td colspan="3">Performance indicator used to number zones.</td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td colspan="2">"PerformanceIndicator_Units":</td>
<td colspan="3">["(kWh/m<sup>2</sup>.a)", "(kWh/m<sup>2</sup>.a)",
"(%)", "(%)", "(%)"],</td>
<td colspan="3">Performance indicators units used in figures and
reports, these units must follow the same order of Performance
indicators</td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td colspan="2"></td>
<td colspan="3"></td>
<td colspan="3"></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td
colspan="2" style="word-wrap: break-word">"Building_Zones_considered_for_ PerformanceIndex_calculation":</td>
<td colspan="3">["R1","R2","LIVINGKITCH"],</td>
<td colspan="3">The name of the building’s zones used to calculate
performance requiring hourly values(e.g. Thermal comfort, MGR). (These
names should match the variables described in the EnergyPlus output
reports ).</td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td colspan="2">Building_Zones_occupation_Schedule</td>
<td colspan="3">[SCH_OCUP_DORM, SCH_OCUP_DORM, 
SCH_OCUP_SALA]</td>
<td colspan="3">The name of the schedule of each room used to calculate
performance. They should follow the same order of building zones
considered for performance calculation.</td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td colspan="2">Conditioning_type_tag</td>
<td colspan="3">["HVAC","NV"],</td>
<td colspan="3">Tags of the .idf name used to identify models with
natural ventilation and HVAC systems. This information is required to
calculate the appropriate Performance indicator for each model.</td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td colspan="2">"Row_heating_cooling":,</td>
<td colspan="3">["49","50"]</td>
<td colspan="3">Row of the EnergyPlus output (*Table.csv) report
containing heating and cooling annual load.</td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td colspan="2">"Column_heating_cooling":</td>
<td colspan="3">["6","5"],</td>
<td colspan="3">Column of the EnergyPlus output (*Table.csv) report
containing heating and cooling annual load</td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td colspan="2">"Line_EPW":</td>
<td colspan="3">["5","5"],</td>
<td colspan="3">Line containing the EPW file name in the Energyplus
output (*Table.csv) report</td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td colspan="8"><strong>Zoning settings</strong></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td colspan="2">“Macrozones_divisions”:</td>
<td colspan="3">(1=yes), (0=no)</td>
<td colspan="3">User option to divide the area of study in Macrozones
prior to the definition of Zones.</td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td colspan="2">“NumberofZones”:</td>
<td colspan="3">Any number e.g. 4,</td>
<td colspan="3">Number of climatic zones, used when Macrozones are not
required.</td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td colspan="2">“Number_of_subzones”:</td>
<td colspan="3">[“4”,”3”],</td>
<td colspan="3">In case the Macrozone option is selected, each macrozone
will be divided into specific number of zones. The first macrozone is
the coldest, where heating represents at least 5% of cooling load,
(considering ideal loads).</td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td colspan="2">“Zoning_grid_type”:</td>
<td
colspan="3">[“Isolated_Locations”,”Municipalities”,”Regular_Grid”],</td>
<td colspan="3">Name of grid types based on resolution</td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td colspan="2">“Zoning_isolated_locations”:</td>
<td colspan="3">(1=yes), (0=no)</td>
<td colspan="3" rowspan="5"><p>Zoning Resolution</p>
<ol type="a">
<li><p>Points</p></li>
<li><p>Irregular grid</p></li>
<li><p>Regular grid</p></li>
</ol></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td colspan="2">“Zoning_interpolated_PerfData_IrregularGrid”:</td>
<td colspan="3">(1=yes), (0=no)</td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td colspan="2">“Zoning_interpolated_PerfData_RegularGrid”:</td>
<td colspan="3">(1=yes), (0=no)</td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td colspan="2"></td>
<td colspan="3"></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td colspan="2"></td>
<td colspan="3"></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td colspan="2">"grid_of_points_exceeds_areaofstudy":</td>
<td colspan="3">(1=yes), (0=no)</td>
<td colspan="3">User option to indicate if the simulation points exceed
the area of study, if so, the shape file of the area of study will be
used to filter data.</td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td colspan="2">Irregular_grid_input_data</td>
<td colspan="3">"MunicipiosBrasil.csv"</td>
<td colspan="3">Input file containing coordinates (LAT and LON) of an
irregular grid. E.g Municipalities. It should be located in the main
folder of simzoning.</td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td colspan="2">"IrregularGrid_exceeds_areaofstudy</td>
<td colspan="3">(1=yes), (0=no)</td>
<td colspan="3">If the irregular grid adopted (e.g. Municipalities)
covers a region greater than the area of study, the program will filter
the data using the shapefile of the area of study.</td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td colspan="2">"AlternativeMethod_ for_comparison":</td>
<td colspan="3">(1=yes), (0=no)</td>
<td colspan="3">Option to use an alternative method to compare
clustering results using the MPMA index.</td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td colspan="2">"Name_of_AlternativeMethod_for_comparison":</td>
<td colspan="3">["DegreeDays_Brazil","GT_Brazil"],</td>
<td colspan="3"><p>The name must be the same of the Shapefile located in
the folder C:\simzoning\GISfiles\CZ_Methods_Comparison, without the
extension .shp</p>
<p>Such shape file must contain a feature named “zone” containing a
numeric value to identify climatic zones.</p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td colspan="8"><strong>Area of study</strong></td>
</tr>
<tr class="odd">
<td colspan="8"></td>
</tr>
<tr class="even">
<td colspan="2">"AreaofStudyShapefile_Path":</td>
<td colspan="3">"./GISfiles/AreaOfStudy/",</td>
<td colspan="3">Folder containing the Shape file of the area of
study</td>
</tr>
<tr class="odd">
<td colspan="2">"ShapeFileName_AreaofStudy":</td>
<td colspan="3">"RS_SC_PR_SP.SHP",</td>
<td colspan="3">Name of the shape file containing the limits of the area
of study.</td>
</tr>
<tr class="even">
<td colspan="2">"Elevation_file":</td>
<td colspan="3">"topografia1_ProjectRaster2.tif",</td>
<td colspan="3">Tiff file containing elevation data covering the area of
study. Tiff files with projection data: WGS_1984_World_Mercator have
been tested.</td>
</tr>
<tr class="odd">
<td colspan="8"><strong>Fonts, size of points (plotted in
maps)</strong></td>
</tr>
<tr class="even">
<td colspan="2"><p>"sizeofpoints":</p>
<p>"sizeofpointsHDM":</p>
<p>"TitlefontSize":</p>
<p>"TextFontSize":</p>
<p>"SubtitleFontSize":</p>
<p>"LabelFontSize"</p></td>
<td colspan="3"><p>Any number from 10 to 30 (FontSize)</p>
<p>And up to 60 (size of points)</p></td>
<td colspan="3">Size of fonts used in titles, subtitles, labels and
legends of figures. As well as the size of points in maps.</td>
</tr>
<tr class="odd">
<td colspan="2"></td>
<td colspan="3"></td>
<td colspan="3"></td>
</tr>
</tbody>
</table>
