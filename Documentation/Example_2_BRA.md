1.  **Example 2 Brazil**

> Zoning of Brazil.
>
> All settings are included in the file BRA_Brazil.zon.
>
> **Files required:**

<table>
<colgroup>
<col style="width: 27%" />
<col style="width: 27%" />
<col style="width: 45%" />
</colgroup>
<thead>
<tr class="header">
<th></th>
<th><strong>File</strong></th>
<th><strong>Location</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><ol type="1">
<li><blockquote>
<p>Input file</p>
</blockquote></li>
</ol></td>
<td>BRA_Brazil.zon</td>
<td>simzoning\</td>
</tr>
<tr class="even">
<td><ol start="2" type="1">
<li><blockquote>
<p>Shape file of the States of Florida, Georgia, and Tennessee</p>
</blockquote></li>
</ol></td>
<td>BRAlimits.shp</td>
<td>simzoning\GISfiles\AreaOfStudy\</td>
</tr>
<tr class="odd">
<td><ol start="3" type="1">
<li><blockquote>
<p>Weather files of the area of study</p>
</blockquote></li>
</ol></td>
<td>279 .EPW files</td>
<td>simzoning\Weatherfiles\</td>
</tr>
<tr class="even">
<td><ol start="4" type="1">
<li><blockquote>
<p>Idf files</p>
</blockquote></li>
</ol></td>
<td><p>ModelHVAC.idf</p>
<p>ModelNV.idf</p></td>
<td>simzoning\IDFs\BRAZIL_IDFS</td>
</tr>
<tr class="odd">
<td><ol start="5" type="1">
<li><blockquote>
<p>EnergyPlus Version</p>
</blockquote></li>
</ol></td>
<td>8-7-0</td>
<td></td>
</tr>
<tr class="even">
<td><ol start="6" type="1">
<li><blockquote>
<p>Alternative method for comparison</p>
</blockquote></li>
</ol></td>
<td><p>DegreeDays_Brazil.shp</p>
<p>GT_Brazil.shp</p></td>
<td>simzoning\GISfiles\CZ_Methods_Comparison\</td>
</tr>
<tr class="odd">
<td><ol start="7" type="1">
<li><blockquote>
<p>File containing coordinates of Brazilian municipalities</p>
</blockquote></li>
</ol></td>
<td>MunicipiosBrasil.csv</td>
<td>simzoning\</td>
</tr>
</tbody>
</table>

2.  **Steps**

<!-- -->

1.  Create a folder C:/simzoning to unzip simzoning files.

2.  Confirm the path of EnergyPlus Version 8.7 installed in the
    computer. If necessary, rewrite the path in the BRA_Brazil.zon file
    used as input data to run this example.
    <img src="./imagesBRA2/media/image1.png"
    style="width:4.67939in;height:1.33044in" />

> Figure 1 Input data file BRA_Brazil.zon

3.  Call simzoning from MATLAB with the BRA_Brazil.zon file as input
    data.

<table>
<colgroup>
<col style="width: 58%" />
<col style="width: 41%" />
</colgroup>
<thead>
<tr class="header">
<th colspan="2">Case study summary</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td rowspan="2"><img src="./imagesBRA2/media/image2.png"
style="width:1.85486in;height:1.576in"
alt="Mapa Descrição gerada automaticamente" /></td>
<td>279 Epws</td>
</tr>
<tr class="even">
<td><p>2 models</p>
<p>5 Performance indicators</p>
<p>Macrozones</p>
<p>2 Cold Zones + 8 Hot zones</p>
<p>Time estimation 5 hours</p></td>
</tr>
</tbody>
</table>

3.  **Expected results**

> A Region with 10 Zones considering 3 Zoning resolution. A) Clustering
> based on points, b) clustering based on municipalities and c)
> clustering based on interpolated data.

<img src="./imagesBRA2/media/image3.png"
style="width:5.65277in;height:3.3in" />

> Figure 2 Clustering considering isolated locations
>
> <img src="./imagesBRA2/media/image4.png"
> style="width:6.07844in;height:3.3in" />
>
> Figure 3 Performance variation of zoning based on isolated locations
>
> <img src="./imagesBRA2/media/image5.png"
> style="width:5.49746in;height:3.3in" />
>
> Figure 4 Clustering based on municipalities

<img src="./imagesBRA2/media/image6.png"
style="width:6.04249in;height:3.3in" />

> Figure 5 Performance variation of zoning based on municipalities

<img src="./imagesBRA2/media/image7.png"
style="width:5.67115in;height:3.352in" />

> Figure 6 Clustering based on a regular grid of interpolated data
> (Altitude, latitude, and longitude method)

<img src="./imagesBRA2/media/image8.png"
style="width:6.016in;height:3.30344in" />

> Figure 7 Regular grid zoning boxplot

<img src="./imagesBRA2/media/image9.png"
style="width:4.53237in;height:3.39798in" />

> Figure 8 MPMA of clustering results compared to Degree-days and
> GT-zoning for that region.

See the Brazilian case study_AltLatLon_MacrZ_Report.pdf in the
C:\simzoning\Outputs\Brazilian case study_CaseStudy folder for further
details of expected results.
