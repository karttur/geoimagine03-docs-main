---
layout: post
title: GDAL Terrain analysis I
categories: blog
datasource: dem
biophysical: geomorphology
excerpt: "Deriving slope, aspect and hillshade with GDAL"
tags:
  - DEM
  - slope
  - aspect
  - hillshape
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2021-07-06 T18:17:25.000Z'
modified: '2021-07-06 T18:17:25.000Z'
comments: true
share: true
fig1: dem_detail_h18v02
fig2: hillshade_detail_h18v02
fig3: slope_detail_h18v02
fig4: aspect_detail_h18v02
---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>

# Introduction

From a [Digital Elevation Model (DEM)](../blog-global-dems), a range of terrain metrics can be extracted. Perhaps the most common metrics are slope and aspect where slope is the steepness and aspect the horizontal direction of the slope. To illustrate the 3D character of a DEM, the hillshade can be computed and set as an opacity-transparency mask. Karttur's GeoImagine Framework can use either GDAL, GRASS or python scripting to derive different terrain indices. GDAL is the most convenient and well documented alternative, but also the least flexible/powerful. This post introduces the Framework interface to [gdaldem](https://www.gdal.org/gdaldem.html).

# Overview

The processes _GdalDemTiles_ and _GdalDemRegion_ can calculate the following terrain indexes (as defined in [gdaldem](https://www.gdal.org/gdaldem.html):

- slope
- aspect
- hillshade
- Topographic Position Index (TPI)
- Topographic Ruggedness Index (TRI)
- roughness
- color-relief

This post deals with the processing of hillshade, slope and aspect. It covers how to use Karttur's GeoImagine Framework for calling the standard DEM derivates that can be calculated with [GDAL DEM utility (gdaldem)](https://www.gdal.org/gdaldem.html). The [next](../blog.ArcticDemTPI/) post introduces GDAL derived metrics that can be used for capturing elevation variations and positions.

All GDAL related DEM processing can be done from either original tiles, virtual tiles with mosaicked (expanded) coverage, or regions. The construction and use of virtual tiles is recommended and outlined in the [previous](../blog-DemTileMosaics) post. You must prepare the mosaiced tiles beforehand  (with the process _MosaicAdjacentTiles_), then just set the parameter _mosaic_ to _true_ when calling the process _GdalDemTiles_.

By default _GdalDemTiles_ (and _GdalDemRegions_) applies a 3x3 kernel for calculating DEM derivates. You can change that for all derived indexes with the parameter _radiuscsv_, and a comma separated value list in the form of a text string: The default value "_1_" applies a (1+1+1 = 3 cells square kernel) 3x3 kernel for calculating the DEM index for the central pixel. A value of "_2_" aggregates (by averaging) all 2x2 pixels to a single cell and then calculates the index on the average of 3x3 cells originally derived from 6x6 cells; a value of "_3_" calculates the index on the average of 3x3 cells, originally derived from 9x9 cells; etc. The process _NumpyDemTiles_ and _Grass1to1Tiles_ (or _GrassOnetoManyTiles_) can be set to a more fine tuned spatial aggregation. GRASS also offers much more resourceful alternatives for deriving DEM indexes.

All destination layers have default names that builds on the input DEM and the spatial aggregation. You can override some parts, but it is strongly recommended to let the Framework set the names automatically and use the parameterizations as illustrated in the following examples.

## Hillshade

The [<span class='package'>hillshade</span>](../../subprocess/subproc-hillshademodis/) outputs an 8-bit raster with a shaded relief effect useful for visualizing the terrain. You can optionally specify the azimuth and altitude of the light source, as well as a vertical exaggeration factor and a scaling factor to account for differences between vertical and horizontal units.

### json

The json parameters relate to the parameters in the [GDAL DEM utility (gdaldem)](https://www.gdal.org/gdaldem.html).

<button id= "togglehillshade" onclick="hiddencode('hillshadediv')">Hide/Show hillshape.json</button>
<div id="hillshadediv" style="display:none">
{% capture text-capture %}
{% raw %}

```
{
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
        "mode": "hillshade",
        "mosaic": true
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

## Slope

With _mode_ set to _slope_ [GdalDemTilees](#) outputs an 32-bit Float raster with a  slope in degrees unless the _-p_ (_percent_) parameter is set.

### json

<button id= "toggleslope" onclick="hiddencode('slopediv')">Hide/Show ArcticDEM_Slope.json</button>

<div id="slopediv" style="display:none">
{% capture text-capture %}
{% raw %}
```
{
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
        "mode": "slope",
        "mosaic": true
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

## Aspect

With _mode_ set to _aspect_ [GdalDemTilees](#) outputs an 32-bit Float raster with azimuth in degrees; if the parameter _-trigonometry_ is given, the output is in angle degrees with zero set to the East (rather than North).

### json

The json parameters that can be given are related  to the parameters in the [GDAL DEM utility (gdaldem)](https://www.gdal.org/gdaldem.html).

<button id= "toggleaspect" onclick="hiddencode('aspectdiv')">Hide/Show ArcticDEM_Slope.json</button>
<div id="aspectdiv" style="display:none">
{% capture text-capture %}
{% raw %}

```
{
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
        "mode": "slope",
        "mosaic": true
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

## Illustrations

The figure below illustrates the DEM and its derivates as described in this post.

<figure class="half">

  <a href="{{ site.commonurl }}/images/{{ site.data.images[page.fig1].file }}"><img src="{{ site.commonurl }}/images/{{ site.data.images[page.fig1].file }}" alt="image"></a>

  <a href="{{ site.commonurl }}/images/{{ site.data.images[page.fig2].file }}">
  <img src="{{ site.commonurl }}/images/{{ site.data.images[page.fig2].file }}" alt="image"></a>

	<a href="{{ site.commonurl }}/images/{{ site.data.images[page.fig3].file }}">
  <img src="{{ site.commonurl }}/images/{{ site.data.images[page.fig3].file }}" alt="image"></a>

	<a href="{{ site.commonurl }}/images/{{ site.data.images[page.fig4].file }}">
  <img src="{{ site.commonurl }}/images/{{ site.data.images[page.fig4].file }}" alt="image"></a>

	<figcaption>Digital Elevation Model and dereived terrain metrics (clockwise, starting upper left): DEM, hillshade, slope and aspect.</figcaption>
</figure>
