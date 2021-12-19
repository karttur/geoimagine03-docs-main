---
layout: post
title: DEM image layout
categories: blog
datasource: dem
excerpt: "Elevation symbolisation; color ramping, hill shading and legends for image maps"
tags:
  - DEM
  - map
  - layout
  - symbolization
  - hill shade
  - legend
  - export
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2021-10-02 T18:17:25.000Z'
modified: '2021-10-02 T18:17:25.000Z'
comments: true
share: true
---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>

## Introduction

Layout and symbolization is an integral part of mapping. This article demonstrate how to set color ramps, add hill shade and export raster layers as images with legends. The example used in the article is elevation data over the Norwegian coastline. The export does not include any graticule, scale or north arrow. How to add these geographic features and turn the image to a map is covered in another article. Not yet done.

## Prerequisites

You must have Karttur's complete GeoImagine Framework installed as described in the post [Install and setup spatial data IDE](https://karttur.github.io/setup-ide/). You must also have a Digital Elevation Model (DEM) imported to the Framework.

## Export procedure



Exports to layout in the Framework is always done to byte binary images with numerical cell values in the range 0-255. Value in the range 251-255 are reserved for special layouts, where 255 is always used to represent null (no data). Export do not need to use the full range 0 to 250 to represent the layer content.

The scaling to binary range (defined by the process [CreateScaling](#)) is tied to each composition and can not be defined as part of the export processes. Also the Legend layout, defined using the process [CreateLegend](#) is linked to the composition and can not be changed. The color ramp, defined using the Framework process [AddRasterPalette](#) is defined independently of the composition. To actually use a particular color ramp with a particular composition, the legend must be exported by the process [ExportLegend](#). The exception is when you want to apply a color ramp while dynamically setting the min-max range of actual pixel values, then the legend is exported on the fly.

To set the color ramp dynamically you set the parameter _minmax_ in the process [ExportTilesToByte](#) to _true_. You can then define values for min (_srcmin_) and max (_srcmin_) values, or let the Framework examine the min and max, but that will then always refer to the entire tile (not any part used for the image map).

## Process chain

To create an image map with a legend you must have setup and run the following Framework processes:

- CreateScaling
- AddRasterPalette
- CreateLegend
- ExportLegend

### CreateScaling

Elevation data can range from approximately -415 m in the Dead Sea Depression to 8850 m (Mouth Everst). This range is generally too large for capturing in 255 values. Thus the color ramp  for elevation data usually needs to be set dynamically.


<button id= "toggleCreateScaling" onclick="hiddencode('CreateScaling')">Hide/Show CreateScaling</button>

<div id="CreateScaling" style="display:none">

{% capture text-capture %}
{% raw %}

```
{
  "userproject": {
    "userid": "karttur",
    "projectid": "karttur",
    "tractid": "karttur",
    "siteid": "*",
    "plotid": "*",
    "system": "system"
  },
  "period": {
    "timestep": "static"
  },
  "process": [
    {
      "processid": "CreateScaling",
      "overwrite": false,
      "parameters": {
        "scalefac": 0.03125,
        "mirror0": false
      },
      "comp": [
        {
          "dem": {
            "source": "*",
            "product": "*",
            "content": "dem",
            "layerid": "dem",
            "suffix": "*"
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

### AddRasterPalette

Following the ideas of DEM color ramps on [stackexchange](https://gis.stackexchange.com/questions/25099/choosing-colour-ramp-to-use-for-elevation), the framework comes with four color ramps for elevation data. In the example below, the 4 palettes are set for dynamic ranges, indicated by the label _auto_ set for all break and id points.


<button id= "toggleCreateScaling" onclick="hiddencode('CreateScaling')">Hide/Show CreateScaling</button>

<div id="CreateScaling" style="display:none">

{% capture text-capture %}
{% raw %}

```
{
  "userproject": {
    "userid": "karttur",
    "projectid": "karttur",
    "tractid": "karttur",
    "siteid": "*",
    "plotid": "*",
    "system": "system"
  },
  "period": {
    "timestep": "static"
  },
  "process": [
    {
      "processid": "AddRasterPalette",
      "overwrite": false,
      "parameters": {
        "palette": "dem_dark_auto",
        "compid": "dem_dark_auto",
        "setcolor": {
          "0": {
            "red": "54",
            "green": "121",
            "blue": "36",
            "alpha": "0",
            "label": "auto",
            "hint": "auto"
          },
          "125": {
            "red": "247",
            "green": "248",
            "blue": "80",
            "alpha": "0",
            "label": "auto",
            "hint": "auto"
          },
          "250": {
            "red": "121",
            "green": "24",
            "blue": "21",
            "alpha": "0",
            "label": "auto",
            "hint": "auto"
          },
          "251": {
            "red": "0",
            "green": "0",
            "blue": "0",
            "alpha": "0",
            "label": "NA",
            "hint": "NA"
          },
          "255": {
            "red": "0",
            "green": "0",
            "blue": "0",
            "alpha": "0",
            "label": "No data",
            "hint": "No data"
          }
        }
      }
    },
    {
      "processid": "AddRasterPalette",
      "overwrite": false,
      "parameters": {
        "palette": "dem_darkest_auto",
        "compid": "dem_darkest_auto",
        "setcolor": {
          "0": {
            "red": "41",
            "green": "96",
            "blue": "58",
            "alpha": "0",
            "label": "auto",
            "hint": "auto"
          },
          "25": {
            "red": "54",
            "green": "121",
            "blue": "36",
            "alpha": "0",
            "label": "auto",
            "hint": "auto"
          },
          "125": {
            "red": "247",
            "green": "248",
            "blue": "80",
            "alpha": "0",
            "label": "auto",
            "hint": "auto"
          },
          "225": {
            "red": "121",
            "green": "24",
            "blue": "21",
            "alpha": "0",
            "label": "auto",
            "hint": "auto"
          },
          "250": {
            "red": "250",
            "green": "240",
            "blue": "245",
            "alpha": "0",
            "label": "auto",
            "hint": "auto"
          },
          "251": {
            "red": "0",
            "green": "0",
            "blue": "0",
            "alpha": "0",
            "label": "NA",
            "hint": "NA"
          },
          "255": {
            "red": "0",
            "green": "0",
            "blue": "0",
            "alpha": "0",
            "label": "No data",
            "hint": "No data"
          }
        }
      }
    },
    {
      "processid": "AddRasterPalette",
      "overwrite": false,
      "parameters": {
        "palette": "dem_light_auto",
        "compid": "dem_light_auto",
        "setcolor": {
          "0": {
            "red": "90",
            "green": "135",
            "blue": "75",
            "alpha": "0",
            "label": "auto",
            "hint": "auto"
          },
          "62": {
            "red": "230",
            "green": "219",
            "blue": "165",
            "alpha": "0",
            "label": "auto",
            "hint": "auto"
          },
          "125": {
            "red": "250",
            "green": "200",
            "blue": "110",
            "alpha": "0",
            "label": "auto",
            "hint": "auto"
          },
          "183": {
            "red": "184",
            "green": "157",
            "blue": "139",
            "alpha": "0",
            "label": "auto",
            "hint": "auto"
          },
          "250": {
            "red": "252",
            "green": "249",
            "blue": "245",
            "alpha": "0",
            "label": "auto",
            "hint": "auto"
          },
          "251": {
            "red": "0",
            "green": "0",
            "blue": "0",
            "alpha": "0",
            "label": "NA",
            "hint": "NA"
          },
          "255": {
            "red": "0",
            "green": "0",
            "blue": "0",
            "alpha": "0",
            "label": "No data",
            "hint": "No data"
          }
        }
      }
    },
    {
      "processid": "AddRasterPalette",
      "overwrite": false,
      "parameters": {
        "palette": "dem_lightest_auto",
        "compid": "dem_lightest_auto",
        "setcolor": {
          "0": {
            "red": "148",
            "green": "188",
            "blue": "114",
            "alpha": "0",
            "label": "auto",
            "hint": "auto"
          },
          "125": {
            "red": "255",
            "green": "252",
            "blue": "207",
            "alpha": "0",
            "label": "auto",
            "hint": "auto"
          },
          "250": {
            "red": "244",
            "green": "158",
            "blue": "95",
            "alpha": "0",
            "label": "auto",
            "hint": "auto"
          },
          "251": {
            "red": "0",
            "green": "0",
            "blue": "0",
            "alpha": "0",
            "label": "NA",
            "hint": "NA"
          },
          "255": {
            "red": "0",
            "green": "0",
            "blue": "0",
            "alpha": "0",
            "label": "No data",
            "hint": "No data"
          }
        }
      }
    }
  ]
}

```
{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html  toggle-text=text-capture  %}
</div>

There are several web tools for setting and testing color ramps, including for instance [Zonum Solutions Color Ramps Generator](http://www.zonums.com/online/color_ramp/).

### CreateLegend

The process [Createlegend](#) includes about 30 parameters for defining the legend and its layout. All parameters, except the _columnhead_ (color ramp) can be left with the default setting for all continuous data. For elevation legends, you thus only need to give the _columnhead_.

<button id= "toggleCreateLegend" onclick="hiddencode('CreateLegend')">Hide/Show CreateLegend</button>

<div id="CreateLegend" style="display:none">

{% capture text-capture %}
{% raw %}

```
{
  "userproject": {
    "userid": "karttur",
    "projectid": "karttur",
    "tractid": "karttur",
    "siteid": "*",
    "plotid": "*",
    "system": "system"
  },
  "period": {
    "timestep": "static"
  },
  "process": [
    {
      "processid": "CreateLegend",
      "overwrite": false,
      "parameters": {
        "columnhead": "Elevation (m.a.s.l)",
        "precision": "0"
      },
      "srccomp": [
        {
          "dem": {
            "source": "ESA",
            "product": "copdem",
            "content": "dem",
            "layerid": "dem",
            "prefix": "dem",
            "suffix": "v01-90m"
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

### ExportLegend

Legends with a fixed range can be exported as stand alone images. The example below exports the four elevation legends defined above calling the Framework process [ExportLegend](#).

<button id= "toggleExportLegend" onclick="hiddencode('ExportLegend')">Hide/Show ExportLegend/button>

<div id="ExportLegend" style="display:none">

{% capture text-capture %}
{% raw %}

```
{
  "userproject": {
    "userid": "karttur",
    "projectid": "karttur",
    "tractid": "karttur",
    "siteid": "*",
    "plotid": "*",
    "system": "system"
  },
  "period": {
    "timestep": "static"
  },
  "process": [
    {
      "processid": "ExportLegend",
      "overwrite": false,
      "parameters": {
        "palette": "dem_darkest_fixed",
        "legendopacity": 128
      },
      "dstpath": {
        "volume": "Karttur"
      },
      "srccomp": [
        {
          "dem": {
            "source": "ESA",
            "product": "copdem",
            "content": "dem",
            "layerid": "dem",
            "prefix": "dem-darkest",
            "suffix": "v01-90m"
          }
        }
      ]
    },
    {
      "processid": "ExportLegend",
      "overwrite": false,
      "parameters": {
        "palette": "dem_dark_fixed",
        "legendopacity": 128
      },
      "dstpath": {
        "volume": "Karttur"
      },
      "srccomp": [
        {
          "dem": {
            "source": "ESA",
            "product": "copdem",
            "content": "dem",
            "layerid": "dem",
            "prefix": "dem-dark",
            "suffix": "v01-90m"
          }
        }
      ]
    },

    {
      "processid": "ExportLegend",
      "overwrite": false,
      "parameters": {
        "palette": "dem_light_fixed",
        "legendopacity": 128
      },
      "dstpath": {
        "volume": "Karttur"
      },
      "srccomp": [
        {
          "dem": {
            "source": "ESA",
            "product": "copdem",
            "content": "dem",
            "layerid": "dem",
            "prefix": "dem-light",
            "suffix": "v01-90m"
          }
        }
      ]
    },
    {
      "processid": "ExportLegend",
      "overwrite": false,
      "parameters": {
        "palette": "dem_lightest_fixed",
        "legendopacity": 128
      },
      "dstpath": {
        "volume": "Karttur"
      },
      "srccomp": [
        {
          "dem": {
            "source": "ESA",
            "product": "copdem",
            "content": "dem",
            "layerid": "dem",
            "prefix": "dem-lightest",
            "suffix": "v01-90m"
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

To create a canvas with all 4 legends, I used [Image magick](£):

<span class='terminal'>$ magick montage -background \'#777777\' -geometry +4+4 dem_dem_dem_darkest_fixed.png dem_dem_dem_dark_fixed.png dem_dem_dem_light_fixed.png dem_dem_dem_lightest_fixed.png dem_legends.png </span>

<figure>
	<img src="../../images/dem_legends.png" alt="image">

  <figcaption>The 4 different elevation legends created above and exported using the process Exportlegend</figcaption>
</figure>



<figure class="half">
	<a href="../../images/dem3_copdem_x04y07_0_v01-90m.jpg"><img src="../../images/dem3_copdem_x04y07_0_v01-90m.jpg" alt="image"></a>

  <a href="../../images/dem3-shade_copdem_x04y07_0_v01-90m-3x3.jpg"><img src="../../images/dem3-shade_copdem_x04y07_0_v01-90m-3x3.jpg" alt="image not yet ready"></a>

<figcaption>Elevation data from which the metrics below was derived; left image at 90 m resolution, right image after average smoothing with a 3x3 equal weights square kernel.</figcaption>
</figure>

<figure class="half">
	<a href="../../images/slope3_copdem_x04y07_0_v01-90m-grass-3x3.jpg"><img src="../../images/slope3_copdem_x04y07_0_v01-90m-grass-3x3.jpg" alt="image"></a>

  <a href="../../images/slope3_copdem_x04y07_0_v01-90m-grass-9x9.jpg"><img src="../../images/slope3_copdem_x04y07_0_v01-90m-grass-9x9.jpg" alt="image"></a>

	<figcaption>Slope steepness derived from Karttur's GeoImagine Framework (numpy and scipy); left image from a 3x3 kernel, right image from a 9x9 kernel.</figcaption>
</figure>

<figure class="half">
	<a href="../../images/profc_copdem_x04y07_0_v01-90m-grass-3x3.jpg"><img src="../../images/profc_copdem_x04y07_0_v01-90m-grass-3x3.jpg" alt="image"></a>

  <a href="../../images/profc_copdem_x04y07_0_v01-90m-grass-9x9.jpg"><img src="../../images/profc_copdem_x04y07_0_v01-90m-grass-9x9.jpg" alt="image"></a>

	<figcaption>Profile curvature derived from the grass module r.params.scale; left image from a 3x3 kernel, right image from a 9x9 kernel.</figcaption>
</figure>

<figure class="half">
	<a href="../../images/crosc_copdem_x04y07_0_v01-90m-grass-3x3.jpg"><img src="../../images/crosc_copdem_x04y07_0_v01-90m-grass-3x3.jpg" alt="image"></a>

  <a href="../../images/crosc_copdem_x04y07_0_v01-90m-grass-9x9.jpg"><img src="../../images/crosc_copdem_x04y07_0_v01-90m-grass-9x9.jpg" alt="image"></a>

	<figcaption>Cross curvature derived from the grass module r.params.scale; left image from a 3x3 kernel, right image from a 9x9 kernel.</figcaption>
</figure>

<figure class="half">
	<a href="../../images/longc_copdem_x04y07_0_v01-90m-grass-3x3.jpg"><img src="../../images/longc_copdem_x04y07_0_v01-90m-grass-3x3.jpg" alt="image"></a>

  <a href="../../images/longc_copdem_x04y07_0_v01-90m-grass-9x9.jpg"><img src="../../images/longc_copdem_x04y07_0_v01-90m-grass-9x9.jpg" alt="image"></a>

	<figcaption>Longitudinal curvature derived from the grass module r.params.scale; left image from a 3x3 kernel, right image from a 9x9 kernel.</figcaption>
</figure>

<figure class="half">
	<a href="../../images/planc_copdem_x04y07_0_v01-90m-grass-3x3.jpg"><img src="../../images/planc_copdem_x04y07_0_v01-90m-grass-3x3.jpg" alt="image"></a>

  <a href="../../images/planc_copdem_x04y07_0_v01-90m-grass-9x9.jpg"><img src="../../images/planc_copdem_x04y07_0_v01-90m-grass-9x9.jpg" alt="image"></a>

	<figcaption>Planar curvature derived from the grass module r.params.scale; left image from a 3x3 kernel, right image from a 9x9 kernel.</figcaption>
</figure>


<figure class="half">
	<a href="../../images/tri_copdem_x04y07_0_v01-90m-3x3.jpg"><img src="../../images/tri_copdem_x04y07_0_v01-90m-3x3.jpg" alt="image"></a>

  <a href="../../images/tri_copdem_x04y07_0_v01-90m-9x9.jpg"><img src="../../images/tri_copdem_x04y07_0_v01-90m-9x9.jpg" alt="image"></a>

	<figcaption>Topographic Ruggedness Index (TRI) derived from GDAL and Karttur's GeoImagine Framework; left image from a 3x3 kernel, right image from a 9x9 kernel.</figcaption>
</figure>

<figure class="half">
	<a href="../../images/tpi_copdem_x04y07_0_v01-90m-3x3.jpg"><img src="../../images/tpi_copdem_x04y07_0_v01-90m-3x3.jpg" alt="image"></a>

  <a href="../../images/tpi_copdem_x04y07_0_v01-90m-9x9.jpg"><img src="../../images/tpi_copdem_x04y07_0_v01-90m-9x9.jpg" alt="image"></a>

	<figcaption>Topographic Position Index (TPI) derived from GDAL and Karttur's GeoImagine Framework; left image from a 3x3 kernel, right image from a 9x9 kernel.</figcaption>
</figure>

<figure class="half">
	<a href="../../images/landform-TPI_copdem_x04y07_0_v01-90m-np-stnd-1+3.jpg"><img src="../../images/landform-TPI_copdem_x04y07_0_v01-90m-np-stnd-1+3.jpg" alt="image"></a>

  <a href="../../images/landform-TPI_copdem_x04y07_0_v01-90m-np-stnd-1+9.jpg"><img src="../../images/landform-TPI_copdem_x04y07_0_v01-90m-np-stnd-1+9.jpg" alt="image not yet ready"></a>

	<figcaption>Landform classes derived from dual scale TPI analysis using Karttur's GeoImagine Framework; left image from a 3x3 + 9+9 kernel, right image from a 3x3 + 18x18 kernel.</figcaption>
</figure>

<figure class="half">
	<a href="../../images/geomorph_copdem_x04y07_0_v01-90m-grass-3x3.jpg"><img src="../../images/geomorph_copdem_x04y07_0_v01-90m-grass-3x3.jpg" alt="image"></a>

  <a href="../../images/geomorph_copdem_x04y07_0_v01-90m-grass-5x5.jpg"><img src="../../images/geomorph_copdem_x04y07_0_v01-90m-grass-5x5.jpg" alt="image not yet ready"></a>

  <a href="../../images/geomorph_copdem_x04y07_0_v01-90m-grass-5x5-elev3x3.jpg"><img src="../../images/geomorph_copdem_x04y07_0_v01-90m-grass-5x5-elev3x3.jpg" alt="image"></a>

  <a href="../../images/geomorph_copdem_x04y07_0_v01-90m-grass-9x9.jpg"><img src="../../images/geomorph_copdem_x04y07_0_v01-90m-grass-9x9.jpg" alt="image"></a>

	<figcaption>Geomorphon classes derived from GRASS module r.geomorphon; top row image from a 3x3 kernel and the original DEM, lower left image from a 5x5 kernel applied after filtering the DEM with an averaging 3x3 kernel, lower right image from a 9x9 kernel applied to an unfiltered DEM.</figcaption>

  <figure class="half">
  	<a href="../../images/landform-ps_copdem_x04y07_0_v01-90m-grass-3x3.jpg"><img src="../../images/landform-ps_copdem_x04y07_0_v01-90m-grass-3x3.jpg" alt="image"></a>

    <a href="../../images/landform-ps_copdem_x04y07_0_v01-90m-grass-9x9.jpg"><img src="../../images/landform-ps_copdem_x04y07_0_v01-90m-grass-9x9.jpg" alt="image not yet ready"></a>

  	<figcaption>Morphology classes derived from the GRASS module r.param.scale; left image from a 3x3 kernel, right image from a 9x9 kernel.</figcaption>
  </figure>

</figure>
