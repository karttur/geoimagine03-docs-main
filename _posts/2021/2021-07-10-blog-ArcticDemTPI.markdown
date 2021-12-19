---
layout: post
title: GDAL Terrain analysis II
categories: blog
datasource: dem
excerpt: "Deriving terrain indexes with GDAL."
tags:
  - DEM
  - TPI
  - TRI
  - roughness
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2021-07-10 T18:17:25.000Z'
modified: '2021-07-10 T18:17:25.000Z'
comments: true
share: true
fig1: dem_detail_h18v02
fig3: slope_detail_h18v02
fig1a: tpi500detail
fig1b: tpi1000detail
fig1c: tpi1500detail
fig1d: tpi2000detail

---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>

# Introduction

The relative variations in topography is highly scale sensitive, and also the key for categorising different geomorphological elements (plains valleys, peaks etc), as well as for determining landscape hydrological properties (recharge and discharge areas, channels etc). From a Digital Elevation Model (DEM), the relative variation can be calculated by comparing a single cells with its neighbours. [gdaldem](https://gdal.org/programs/gdaldem.html) includes three different measures on the relative topographic variations that can be accessed via the Framework:

- Topographic Position Index (TPI),
- Terrain Ruggedness index (TRI), and
- Roughness index (RI)

If you are looking for deriving slope, aspect or hillshade or from DEM, this is covered in the [previous](../blog-ArcticDemSlopeAspect/) post.

# Overview

This post covers the processing of TPI from DEM data tiled to the modis system. The processing of Terrain Ruggedness index (TRI) and Roughness (RN), are identical. All the indexes (TPI, TRI, RN) utilize the [GDAL DEM utility (gdaldem)](https://www.gdal.org/gdaldem.html). In Karttur's GeoImagine Framework you can set the TPI (TRI or RN) processing to produce destination layers at different spatial resolutions. This is convenient if you are intending to the TPI (TRI, RN) data for e.g. [landform classification](../blog-ArcticDEMLandform/).

# Terrain Position Index (TPI)

The Topographic Position Index (TPI) is defined as the difference between a cell's elevation value and the average elevation of the neighbouring cells.
Positive values mean the cell is higher than its surroundings while negative values means that it is lower. The degree to which it is higher or lower, plus the slope of the cell, can be used to classify the cell
into slope position. If it is significantly higher
than the surrounding neighbours, then it is likely
to be at or near the top of a hill or ridge.  Significantly lower values suggest the cell is at or near the bottom of a valley.  TPI values near zero could
mean either a flat or mid-slope area; the
cell slope can be used to distinguish the two.

## json

All destination layers have default names that builds on the input DEM and the spatial aggregation. Any number of spatial aggregations can be produced with a single command through the _radisucsv_ parameter. The parameter shoud be given as a comma separated value list in the form of a text string: The default value "_1_" applies a (1+1+1 = 3 cells square kernel) 3x3 kernel for calculating the DEM index (TPI) for the central pixel. A value of "_2_" aggregates averages all 2x2 pixels to a single cell and then calculates the index on the average of 3x3 cells originally derived from 6x6 cells. While the analysis is done using reduced resolutions, the produced layers will be in the original resolution to allow direct overlay and analysis.

<button id= "toggleaspect" onclick="hiddencode('codediv')">Hide/Show Framework command for derining GDAL terrain indexes (json)</button>
<div id="codediv" style="display:none">
{% capture text-capture %}
{% raw %}
```
"userproject": {
	"userid": "karttur",
	"projectid": "karttur-arcticdemext",
	"tractid": "karttur-arcticdemext",
	"siteid": "*",
	"plotid": "*",
	"system": "modis"
},
"period": {
	"timestep": "static"
},
"process": [
	{
		"processid": "GdalDemTiles",
		"version": "1.3",
		"overwrite": false,
		"parameters": {
			"mode": "TPI",
			"mosaic": true,
			"radiuscsv" : "1,3"
		},
		"srcpath": {
			"volume": "Ancillary",
			"hdr": "tif"
		},
		"dstpath": {
			"volume": "Ancillary",
			"hdr": "tif"
		},
		"srccomp": [
		"dem500": {
			"source": "NGA-NSF",
			"product": "arcticdem",
			"content": "dem",
			"layerid": "dem500",
			"prefix": "dem500",
			"suffix": "v30"
			}
		],
		"dstcopy": [
			{
				"dem500": {
					"layerid": "auto",
					"prefix": "auto",
					"suffix": "auto",
					"dataunit": "auto"
				}
			}
		]
	}
]
}
```
{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html  toggle-text=text-capture  %}
</div>

The json object above produces two (2) TPI compositions, using a 3x3 cells and 9x9 cells (with the latter reduced to 3x3 prior to the analysis). The json will produce TPI layers for all modis tiles covered by the user tract _karttur-arcticdemext_ (corresponding default region = _arcticdemext_) that was created in one of the [previous](../blog-ArcticDem/) posts.

The figure below illustrates the TPI for a detailed scene at the two aggregation levels (bottom row).

<figure class="half">

<a href="{{ site.commonurl }}/images/{{ site.data.images[page.fig1].file }}"><img src="{{ site.commonurl }}/images/{{ site.data.images[page.fig1].file }}" alt="image"></a>

<a href="{{ site.commonurl }}/images/{{ site.data.images[page.fig3].file }}">
<img src="{{ site.commonurl }}/images/{{ site.data.images[page.fig3].file }}" alt="image"></a>

  <a href="../../images/{{ site.data.images[page.fig1a].file }}"><img src="{{ site.commonurl }}/images/{{ site.data.images[page.fig1a].file }}" alt="image"></a>

	<a href="{{ site.commonurl }}/images/{{ site.data.images[page.fig1c].file }}">
  <img src="{{ site.commonurl }}/images/{{ site.data.images[page.fig1c].file }}" alt="image"></a>

	<figcaption>Comparison of Terrain Position index (TPI) at  500 m and 1500 m (bottom row); the top row shows the DEM and the slope for the same region.</figcaption>
</figure>
