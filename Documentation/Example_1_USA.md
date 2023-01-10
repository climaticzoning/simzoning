> **To run these example, MATLABR2022b, Deep Learning Toolbox, Mapping
> Toolbox, Matlab Report Generator, Statistic and Machine Learning
> Toolbox, and the EnergyPlus Version 8.3 are required.**

1.  **Example 1 USA**

> Zoning the states of Florida, Georgia, and Tennessee.
>
> All settings are included in the file **USA.zon**.

2.  **Files required:**

+------------------+-----------------+--------------------------------+
|                  | **File**        | **Location**                   |
+==================+=================+================================+
| 1.  Input file   | USA.zon         | simzoning\\                    |
+------------------+-----------------+--------------------------------+
| 2.  Shape file   | USA_States.shp  | simz                           |
|     > of the     |                 | oning\\GISfiles\\AreaOfStudy\\ |
|     > States of  |                 |                                |
|     > Florida,   |                 |                                |
|     > Georgia,   |                 |                                |
|     > and        |                 |                                |
|     > Tennessee  |                 |                                |
+------------------+-----------------+--------------------------------+
| 3.  Weather      | 87 .EPW files   | simzoning\\Weatherfiles\\      |
|     > files of   |                 |                                |
|     > the area   |                 |                                |
|     > of study   |                 |                                |
|     > and        |                 |                                |
|                  |                 |                                |
|   > surroundings |                 |                                |
+------------------+-----------------+--------------------------------+
| 4.  Idf. files   | A               | simzoning\\IDFs\\USA_IDFS      |
|                  | ptMidRise1A.idf |                                |
|                  |                 |                                |
|                  | A               |                                |
|                  | ptMidRise2A.idf |                                |
|                  |                 |                                |
|                  | A               |                                |
|                  | ptMidRise3A.idf |                                |
|                  |                 |                                |
|                  | A               |                                |
|                  | ptMidRise4A.idf |                                |
+------------------+-----------------+--------------------------------+
| 5.  EnergyPlus   | 8-3-0           |                                |
|     > Version    |                 |                                |
+------------------+-----------------+--------------------------------+
| 6.  Alternative  | Deg             | simzoning\\GIS                 |
|     > method for | reeDays_USA.SHP | files\\CZ_Methods_Comparison\\ |
|     > comparison |                 |                                |
+------------------+-----------------+--------------------------------+

3.  **Steps**

-   Create a folder C:/simzoning to unzip simzoning files.

-   Confirm the path of EnergyPlus Version 8.3 installed in the
    computer. If necessary, rewrite the path in the USA.zon file used as
    input data to run this example.

-   Call simzoning with the USA.zon file as input data from MATLAB.

+------------------------------------------+---------------------------+
| > Case study summary                     |                           |
+==========================================+===========================+
| > ![](./imagesUSA1/medi                  | > 87 Epws                 |
| a/image1.png){width="2.34200678040245in" |                           |
| > height="2.6286297025371828in"}         |                           |
+------------------------------------------+---------------------------+
|                                          | > 4 models                |
|                                          | >                         |
|                                          | > 2 Performance           |
|                                          | > indicators              |
|                                          | >                         |
|                                          | > (Annual energy demand   |
|                                          | > for cooling and         |
|                                          | > heating.)               |
|                                          | >                         |
|                                          | > 4 Zones                 |
|                                          | >                         |
|                                          | > Number of processors: 4 |
|                                          | >                         |
|                                          | > Time estimation 6 hours |
+------------------------------------------+---------------------------+

4.  **Expected results**

> A Region with 4 Zones considering 2 Zoning resolution. A) Clustering
> based on points, b) clustering based on interpolated data.
>
> ![](./imagesUSA1/media/image2.png){width="6.1722222222222225in"
> height="3.773912948381452in"}
>
> Figure 1 Clustering considering points and interpolated data.
>
> ![Gráfico Descrição gerada
> automaticamente](./imagesUSA1/media/image3.png){width="6.539130577427821in"
> height="3.673611111111111in"}
>
> Figure 2 Cooling and heating variation per zone of a random model
>
> ![](./imagesUSA1/media/image4.png){width="6.216232502187227in"
> height="3.7in"}
>
> Figure 3 Clustering based on a regular grid of interpolated data
> (Altitude, latitude, and longitude interpolation method)
>
> ![Gráfico, Gráfico de caixa estreita Descrição gerada
> automaticamente](./imagesUSA1/media/image5.png){width="6.7844160104986875in"
> height="3.659928915135608in"}
>
> Figure 4 Cooling and heating variation per zone of a random model
>
> ![](./imagesUSA1/media/image6.png){width="4.206364829396326in"
> height="3.349659886264217in"}
>
> Figure 5 MPMA of clustering results compared to the degree days zoning
> for the region under analysis.
>
> See PDF file Florida Georgia and Tennessee_AltLatLon_Report.pdf in the
> output folder.
>
> simzoning/Outputs/Florida Georgia and Tennessee_CaseStudy/ for further
> details about expected results.
