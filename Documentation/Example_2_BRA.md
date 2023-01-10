To run these example, MATLABR2022b, Deep Learning Toolbox, Mapping
Toolbox, Matlab Report Generator, Statistic and Machine Learning
Toolbox, and the EnergyPlus Version 8.3 are required.

1.  **Example 2 Brazil**

> Zoning of Brazil.
>
> All settings are included in the file BRA_Brazil.zon.
>
> **Files required:**

+------------------+------------------+-------------------------------+
|                  | **File**         | **Location**                  |
+==================+==================+===============================+
| 1.  Input file   | BRA_Brazil.zon   | simzoning\\                   |
+------------------+------------------+-------------------------------+
| 2.  Shape file   | BRAlimits.shp    | simzo                         |
|     > of the     |                  | ning\\GISfiles\\AreaOfStudy\\ |
|     > States of  |                  |                               |
|     > Florida,   |                  |                               |
|     > Georgia,   |                  |                               |
|     > and        |                  |                               |
|     > Tennessee  |                  |                               |
+------------------+------------------+-------------------------------+
| 3.  Weather      | 279 .EPW files   | simzoning\\Weatherfiles\\     |
|     > files of   |                  |                               |
|     > the area   |                  |                               |
|     > of study   |                  |                               |
+------------------+------------------+-------------------------------+
| 4.  Idf files    | ModelHVAC.idf    | simzoning\\IDFs\\BRAZIL_IDFS  |
|                  |                  |                               |
|                  | ModelNV.idf      |                               |
+------------------+------------------+-------------------------------+
| 5.  EnergyPlus   | 8-7-0            |                               |
|     > Version    |                  |                               |
+------------------+------------------+-------------------------------+
| 6.  Alternative  | Degre            | simzoning\\GISf               |
|     > method for | eDays_Brazil.shp | iles\\CZ_Methods_Comparison\\ |
|     > comparison |                  |                               |
|                  | GT_Brazil.shp    |                               |
+------------------+------------------+-------------------------------+
| 7.  File         | Muni             | simzoning\\                   |
|     > containing | cipiosBrasil.csv |                               |
|                  |                  |                               |
|    > coordinates |                  |                               |
|     > of         |                  |                               |
|     > Brazilian  |                  |                               |
|                  |                  |                               |
| > municipalities |                  |                               |
+------------------+------------------+-------------------------------+

2.  **Steps**

```{=html}
<!-- -->
```
1.  Create a folder C:/simzoning to unzip simzoning files.

2.  Confirm the path of EnergyPlus Version 8.7 installed in the
    computer. If necessary, rewrite the path in the BRA_Brazil.zon file
    used as input data to run this example.
    ![](./imagesBRA2/media/image1.png){width="4.679391951006124in"
    height="1.3304352580927383in"}

> Figure 1 Input data file BRA_Brazil.zon

3.  Call simzoning from MATLAB with the BRA_Brazil.zon file as input
    data.

+-----------------------------------------+----------------------------+
| Case study summary                      |                            |
+=========================================+============================+
| ![Mapa Descrição gerada                 | 279 Epws                   |
| automaticamente](./imagesBRA2/media/    |                            |
| image2.png){width="1.854861111111111in" |                            |
| height="1.5759995625546808in"}          |                            |
+-----------------------------------------+----------------------------+
|                                         | 2 models                   |
|                                         |                            |
|                                         | 5 Performance indicators   |
|                                         |                            |
|                                         | Macrozones                 |
|                                         |                            |
|                                         | 2 Cold Zones + 8 Hot zones |
|                                         |                            |
|                                         | Time estimation 5 hours    |
+-----------------------------------------+----------------------------+

3.  **Expected results**

> A Region with 10 Zones considering 3 Zoning resolution. A) Clustering
> based on points, b) clustering based on municipalities and c)
> clustering based on interpolated data.

![](./imagesBRA2/media/image3.png){width="5.6527723097112865in"
height="3.3in"}

> Figure 2 Clustering considering isolated locations
>
> ![](./imagesBRA2/media/image4.png){width="6.078436132983377in"
> height="3.3in"}
>
> Figure 3 Performance variation of zoning based on isolated locations
>
> ![](./imagesBRA2/media/image5.png){width="5.497458442694663in"
> height="3.3in"}
>
> Figure 4 Clustering based on municipalities

![](./imagesBRA2/media/image6.png){width="6.042489063867016in"
height="3.3in"}

> Figure 5 Performance variation of zoning based on municipalities

![](./imagesBRA2/media/image7.png){width="5.67115157480315in"
height="3.3519991251093613in"}

> Figure 6 Clustering based on a regular grid of interpolated data
> (Altitude, latitude, and longitude method)

![](./imagesBRA2/media/image8.png){width="6.015999562554681in"
height="3.303439413823272in"}

> Figure 7 Regular grid zoning boxplot

![](./imagesBRA2/media/image9.png){width="4.532370953630796in"
height="3.3979833770778654in"}

> Figure 8 MPMA of clustering results compared to Degree-days and
> GT-zoning for that region.

See the Brazilian case study_AltLatLon_MacrZ_Report.pdf in the
C:\\simzoning\\Outputs\\Brazilian case study_CaseStudy folder for
further details of expected results.
