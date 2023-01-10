> **To run these example, MATLABR2022b, Deep Learning Toolbox, Mapping
> Toolbox, Matlab Report Generator, Statistic and Machine Learning
> Toolbox, and the EnergyPlus Version 8.7 are required.**

1.  **Example 1 Brazil**

> Zoning the state of Rio Grande do Sul, in Brazil.
>
> All settings are included in the file BRA_RGS.zon.

2.  **Files required**

+------------------------+-----------------+--------------------------+
|                        | **File**        | **Location**             |
+========================+=================+==========================+
| 1.  Input file         | BRA_RGS.zon     | simzoning\\              |
+------------------------+-----------------+--------------------------+
| 2.  Shape file of the  | BRA_RGS.shp     | simzoning\               |
|     > States of        |                 | \GISfiles\\AreaOfStudy\\ |
|     > Florida,         |                 |                          |
|     > Georgia, and     |                 |                          |
|     > Tennessee        |                 |                          |
+------------------------+-----------------+--------------------------+
| 3.  Weather files of   | 35 .EPW files   | s                        |
|     > the area of      |                 | imzoning\\Weatherfiles\\ |
|     > study and        |                 |                          |
|     > surroundings     |                 |                          |
+------------------------+-----------------+--------------------------+
| 4.  Idf files          | ModelHVAC.idf   | simzon                   |
|                        |                 | ing\\IDFs\\BRAZIL_IDFS\\ |
|                        | ModelNV.idf     |                          |
+------------------------+-----------------+--------------------------+
| 5.  EnergyPlus Version | 8-7-0           |                          |
+------------------------+-----------------+--------------------------+
| 6.  Alternative method | Degree          | simzoning\\GISfiles\     |
|     > for comparison   | Days_Brazil.shp | \CZ_Methods_Comparison\\ |
|                        |                 |                          |
|                        | GT_Brazil.shp   |                          |
+------------------------+-----------------+--------------------------+
| 7.  File containing    | Munic           | simzoning\\              |
|     > coordinates of   | ipiosBrasil.csv |                          |
|     > Brazilian        |                 |                          |
|     > municipalities   |                 |                          |
+------------------------+-----------------+--------------------------+

3.  **Steps**

```{=html}
<!-- -->
```
1.  Create a folder C:/simzoning to unzip simzoning files.

2.  Confirm the path of EnergyPlus Version 8.7 installed in the
    computer. If necessary, rewrite the path in the BRA_RGS.zon file
    used as input data to run this example.
    ![](./images/media/image1.png){width="4.5883716097987755in"
    height="0.8513451443569554in"}

Figure 1 Input data file BRA_RGS.zon

3.  Call simzoning from MATLAB with the BRA_RGS.zon file as input data.

+-----------------------------------------+----------------------------+
| > Case study summary                    |                            |
+=========================================+============================+
| ![](./ima                               | 35 Epws                    |
| ges/media/image2.png){width="2.28125in" |                            |
| height="2.073865923009624in"}           |                            |
+-----------------------------------------+----------------------------+
|                                         | 2 models                   |
|                                         |                            |
|                                         | 5 Performance indicators   |
|                                         |                            |
|                                         | No Macrozones              |
|                                         |                            |
|                                         | 4 Zones                    |
|                                         |                            |
|                                         | Time estimation 1 hour     |
+-----------------------------------------+----------------------------+

4.  **Expected results**

A Region with 4 Zones considering 3 Zoning resolution. A) Clustering
based on points, b) clustering based on municipalities and c) clustering
based on interpolated data.

![Gráfico, Mapa Descrição gerada
automaticamente](./images/media/image3.png){width="6.327723097112861in"
height="3.949838145231846in"}

Figure 2 Clustering based on isolated locations

![Gráfico, Gráfico de caixa estreita Descrição gerada
automaticamente](./images/media/image4.png){width="6.012345800524934in"
height="3.3403204286964128in"}

Figure 3 Isolated locations zoning boxplot

![Gráfico, Mapa Descrição gerada
automaticamente](./images/media/image5.png){width="6.330816929133858in"
height="3.6674912510936135in"}

Figure 4 Clustering based on municipalities

![Gráfico, Gráfico de caixa estreita Descrição gerada
automaticamente](./images/media/image6.png){width="5.923041338582677in"
height="3.2874464129483814in"}

Figure 5 Zoning based on municipalities boxplot

> ![Mapa Descrição gerada
> automaticamente](./images/media/image7.png){width="6.483009623797026in"
> height="3.706700568678915in"}

Figure 6 Clustering based on a regular grid of interpolated data (ANN
interpolation method)

![Gráfico, Gráfico de caixa estreita Descrição gerada
automaticamente](./images/media/image8.png){width="6.229981408573928in"
height="3.5145100612423446in"}

Figure 7 Zoning based on a regular grid boxplot

![Gráfico, Gráfico de barras Descrição gerada
automaticamente](./images/media/image9.png){width="5.033405511811024in"
height="3.949390857392826in"}

Figure 8 MPMA of clustering results compared to the Degreedays zoning
and the GT zoning for the area under study

See PDF file Rio Grande do Sul_ANN_Report.pdf in the output folder:
simzoning/Outputs/ Rio_Grande_do_Sul_CaseStudy /, for further details
about expected results.
