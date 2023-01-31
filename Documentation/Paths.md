# List of input/output folders

### Input
Folders containing files provided by the user.

<table>
<colgroup>
<col style="width: 29%" />
<col style="width: 46%" />
<col style="width: 24%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Input data</strong></th>
<th>Folder</th>
<th>format</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><ol type="1">
<li><p>Weather files</p></li>
</ol></td>
<td>Simzoning\Weatherfiles</td>
<td>.EPW</td>
</tr>
<tr class="even">
<td><ol start="2" type="1">
<li><p>IDFs</p></li>
</ol></td>
<td>Simzoning\IDFS\ “name of the case study”</td>
<td>.IDF</td>
</tr>
<tr class="odd">
<td rowspan="3"><ol start="3" type="1">
<li><p>GIS files (Shape files and tiff files)</p></li>
</ol></td>
<td>simzoning\GISfiles\AreaOfStudy</td>
<td>.SHP</td>
</tr>
<tr class="even">
<td>simzoning\GISfiles\CZ_Methods_Comparison</td>
<td>.SHP this file must contain a feature named “zone”, with numerical
values indicating the zone number. </td>
</tr>
<tr class="odd">
<td>simzoning\GISfiles\Elevation</td>
<td>.TIFF files with elevation data. TIFF files with projection data: WGS_1984_World_Mercator have been tested.</td>
</tr>
<tr class="even">
<td><ol start="4" type="1">
<li><p>Irregular grid</p></li>
</ol></td>
<td>simzoning\</td>
<td>.csv</td>
</tr>
</tbody>
</table>
</br>

### Output

SimZoning outputs are placed in the folder:

```
simzoning\Outputs\”name of the case study”	
```

Output includes:
  - Figures .png format
  - Reports in pdf
  - Matrix with Zoning results .csv
