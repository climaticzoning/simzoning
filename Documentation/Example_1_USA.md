**EnergyPlus Version 8.3 is required.**


1.  **Example 1 USA**

> Zoning the states of Florida, Georgia, and Tennessee.
>
> All settings are included in the file **USA.zon**.

2.  **Files required:**

<table>
<colgroup>
<col style="width: 27%" />
<col style="width: 26%" />
<col style="width: 46%" />
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
<td>USA.zon</td>
<td>simzoning\</td>
</tr>
<tr class="even">
<td><ol start="2" type="1">
<li><blockquote>
<p>Shape file of the States of Florida, Georgia, and Tennessee</p>
</blockquote></li>
</ol></td>
<td>USA_States.shp</td>
<td>simzoning\GISfiles\AreaOfStudy\</td>
</tr>
<tr class="odd">
<td><ol start="3" type="1">
<li><blockquote>
<p>Weather files of the area of study and surroundings</p>
</blockquote></li>
</ol></td>
<td>87 .EPW files</td>
<td>simzoning\Weatherfiles\</td>
</tr>
<tr class="even">
<td><ol start="4" type="1">
<li><blockquote>
<p>Idf. files</p>
</blockquote></li>
</ol></td>
<td><p>AptMidRise1A.idf</p>
<p>AptMidRise2A.idf</p>
<p>AptMidRise3A.idf</p>
<p>AptMidRise4A.idf</p></td>
<td>simzoning\IDFs\USA_IDFS</td>
</tr>
<tr class="odd">
<td><ol start="5" type="1">
<li><blockquote>
<p>EnergyPlus Version</p>
</blockquote></li>
</ol></td>
<td>8-3-0</td>
<td></td>
</tr>
<tr class="even">
<td><ol start="6" type="1">
<li><blockquote>
<p>Alternative method for comparison</p>
</blockquote></li>
</ol></td>
<td>DegreeDays_USA.SHP</td>
<td>simzoning\GISfiles\CZ_Methods_Comparison\</td>
</tr>
</tbody>
</table>

3.  **Steps**

- Create a folder C:/simzoning to unzip simzoning files.

- Confirm the path of EnergyPlus Version 8.3 installed in the computer.
  If necessary, rewrite the path in the USA.zon file used as input data
  to run this example.

- Call simzoning with the USA.zon file as input data from MATLAB.

<table>
<colgroup>
<col style="width: 60%" />
<col style="width: 39%" />
</colgroup>
<thead>
<tr class="header">
<th colspan="2"><blockquote>
<p>Case study summary</p>
</blockquote></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td rowspan="2"><blockquote>
<p><img src="./imagesUSA1/media/image1.png"
style="width:2.34201in;height:2.62863in" /></p>
</blockquote></td>
<td><blockquote>
<p>87 Epws</p>
</blockquote></td>
</tr>
<tr class="even">
<td><blockquote>
<p>4 models</p>
<p>2 Performance indicators</p>
<p>(Annual energy demand for cooling and heating.)</p>
<p>4 Zones</p>
<p>Number of processors: 4</p>
<p>Time estimation 6 hours</p>
</blockquote></td>
</tr>
</tbody>
</table>

4.  **Expected results**

> A Region with 4 Zones considering 2 Zoning resolution. A) Clustering
> based on points, b) clustering based on interpolated data.
>
> <img src="./imagesUSA1/media/image2.png"
> style="width:6.17222in;height:3.77391in" />
>
> Figure 1 Clustering considering points and interpolated data.
>
> <img src="./imagesUSA1/media/image3.png"
> style="width:6.53913in;height:3.67361in"
> alt="Gráfico Descrição gerada automaticamente" />
>
> Figure 2 Cooling and heating variation per zone of a random model
>
> <img src="./imagesUSA1/media/image4.png"
> style="width:6.21623in;height:3.7in" />
>
> Figure 3 Clustering based on a regular grid of interpolated data
> (Altitude, latitude, and longitude interpolation method)
>
> <img src="./imagesUSA1/media/image5.png"
> style="width:6.78442in;height:3.65993in"
> alt="Gráfico, Gráfico de caixa estreita Descrição gerada automaticamente" />
>
> Figure 4 Cooling and heating variation per zone of a random model
>
> <img src="./imagesUSA1/media/image6.png"
> style="width:4.20636in;height:3.34966in" />
>
> Figure 5 MPMA of clustering results compared to the degree days zoning
> for the region under analysis.
>
> See PDF file Florida Georgia and Tennessee_AltLatLon_Report.pdf in the
> output folder.
>
> simzoning/Outputs/Florida Georgia and Tennessee_CaseStudy/ for further
> details about expected results.
