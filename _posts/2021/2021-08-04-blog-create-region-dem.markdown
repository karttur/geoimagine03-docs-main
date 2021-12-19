---
layout: post
title: Create regional DEM
categories: blog
datasource: dem
biophysical: Null
excerpt: "Identify and defined a regional DEM"
tags:
  - DEM
  - region
  - hydrografi
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2021-08-04 T18:17:25.000Z'
modified: '2021-08-04 T18:17:25.000Z'
comments: true
share: true
figure1: soil-moisture-avg_SPL3SMP_global_2015-2018@D001_005
fig2a: soil-moisture-am_SPL3SMP_global_20160122_005
fig2b: soil-moisture-avg_SPL3SMP_global_20160122_005
fig2c: soil-moisture-pm_SPL3SMP_global_20160122_005
figure3: soil-moisture-avg_SPL3SMP_global_2016009_005
movie1: soil-moisture-avg_SPL3SMP_global_2015121-2018345_005
movie2: soil-moisture-avg_SPL3SMP_global_2015-2018@16D_005
SMAP-0100_search-daac_20150331-20150807: SMAP-0100_search-daac_20150331-20150807
---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>

## Introduction

This post covers how to define a geographic region for hydrological modeling using DEM.

## Defining a regional DEM

Defining a region for use in hydrological modeling is an iterative process as the aim is to include complete river basins. And these basins are usually not known beforehand - or if they are it is not certain that they will exactly fit your DEM. Once defined, you must create one or more default regions in the projection system you want to use for the hydrological modeling, then define a user project and region (tract) for that default region. The principal steps for identifying and extracting a regional DEM for hydrological modeling include:

1. Identify DEM region that encloses the complete basin(s) of interest
2. Adjust region(s) to the selected projection system
3. Define default region(s) and system in the Framework
4. Define user project(s) for each of the defined default regions
5. Link DEM tiles to the default region(s)
6. Mosaic regional DEM(s)

### Identify DEM region

As the objective of creating regional DEMs is to prepare data for hydrological modelling, you need to make sure that the complete river basins of interest are included in your region(s). Global datasets of river basins, like The World Bank [Major River Basins Of The World](https://datacatalog.worldbank.org/dataset/major-river-basins-world) or the [CEO water mandate Interactive Database of the Wolrd's River Basins](http://riverbasins.wateractionhub.org) are coarse and with large gaps. The best option is to identity the river basins directly from the elevation data itself.

As identifying the boundaries of the river basins is the overall aim, locating basin boundaries for selecting the region to work with becomes a catch-22. That is overcome by first running the basin analysis using a coarser version the DEM at hand. The suggested steps for identifying the geographical region(s) thus becomes:

- Create a coarser spatial resolution DEM,
- Mosaic the region of interest, including margins,
- Run the complete basin delineation as outlined in this blog section,
- Manually identify the geographical region(s).

#### Create a coarser spatial resolution DEM

Use averaging for reducing the reduction of your DEM data. A reduction of 10 % in cell size leads to a reduction of 99% of the DEM layer itself. You can change the spatial resolution of any dataset registered in Karttur's GeoImagine Framework with the GDAL linked commands _TranslateTiles_ and _TranslateRegion_. If the only thing you want to do with the tiles of changed resolution is to mosaic them, the process _MosaicTiles_ can also change the spatial resolution on the fly, and thus you can skip this step.

Here is an example that changes the Copernicus DEM 90 m version to 1 km virtual tiles for the northern hemisphere projected to EASE-grid North (EPSG:6931).

<button id= "toggletranslate" onclick="hiddencode('translate')">Hide/Show command for translating tiles to virtual 1 km spatial resolution</button>

<div id="translate" style="display:none">

{% capture text-capture %}
{% raw %}
```
{
  "userproject": {
    "userid": "karttur",
    "projectid": "karttur-nordichydro",
    "tractid": "karttur-nordichydro",
    "siteid": "*",
    "plotid": "*",
    "system": "ease2n"
  },
  "period": {
    "timestep": "static"
  },
  "process": [
    {
      "processid": "TranslateTiles",
      "version": "1.3",
      "overwrite": false,
      "parameters": {
        "tr_xres": 1000,
        "tr_yres": 1000,
        "resample":"average"
      },
      "srcpath": {
        "volume": "Ancillary",
        "hdr": "tif"
      },
      "dstpath": {
        "volume": "Ancillary",
        "hdr": "vrt"
      },
      "srccomp": [
        {
          "copernicusdem90": {
            "source": "ESA",
            "product": "copernicusdem",
            "content": "dem",
            "layerid": "dem90",
            "prefix": "dem90",
            "suffix": "v01"
          }
        }
      ],
      "dstcopy": [
        {
          "copernicusdem90": {
            "layerid": "dem1k",
            "prefix": "dem1k",
            "suffix": "v01"
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
#### Mosaic the region of interest

In my example I want to delineate all river basins emptying into Arctic waters. With Arctic waters also including the North Atlantic, Hudson Bay, the Baltic Sea etc. I thus need to create a mosaic for large parts of the northern hemisphere - the region I have called _northlandease2n_. Below I have included the json parameterisations for solid (GeoTiff) mosaics both from prepared virtual 1 km tiles, and from the original tiles in 90 m spatial resolution.

<button id= "togglemosaic1" onclick="hiddencode('mosaic1')">Hide/Show command for mosaicking virutal tiles</button>

<div id="mosaic1" style="display:none">

{% capture text-capture %}
{% raw %}
```
{
  "userproject": {
    "userid": "karttur",
    "projectid": "karttur-northlandease2n",
    "tractid": "karttur-northlandease2n",
    "siteid": "*",
    "plotid": "*",
    "system": "ease2n"
  },
  "period": {
    "timestep": "static"
  },
  "process": [    
    {
      "processid": "MosaicTiles",
      "version": "1.3",
      "overwrite": false,
      "parameters": {
        "tr_xres": 1000,
        "tr_yres": 1000,
        "resample": "near",
        "asscript": false,
        "fillnodata": false,
        "fillmaxdist": 0,
        "fillsmooth": 0
      },
      "srcpath": {
        "volume": "karttur",
        "hdr": "tif"
      },
      "dstpath": {
        "volume": "karttur",
        "hdr": "tif"
      },
      "srccomp": [
        {
          "copdem90": {
            "source": "ESA",
            "product": "copdem",
            "content": "dem",
            "layerid": "dem90",
            "prefix": "dem90",
            "suffix": "v01"
          }
        }
      ],
      "dstcopy": [
        {
          "copdem90": {
            "layerid": "dem1k",
            "prefix": "dem",
            "suffix": "v01-1k"
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

<button id= "togglemosaic2" onclick="hiddencode('mosaic2')">Hide/Show command for mosaicking original tiles</button>

<div id="mosaic2" style="display:none">

{% capture text-capture %}
{% raw %}
```
{
  "userproject": {
    "userid": "karttur",
    "projectid": "karttur-northlandease2n",
    "tractid": "karttur-northlandease2n",
    "siteid": "*",
    "plotid": "*",
    "system": "ease2n"
  },
  "period": {
    "timestep": "static"
  },
  "process": [    
    {
      "processid": "MosaicTiles",
      "version": "1.3",
      "overwrite": false,
      "parameters": {
        "tr_xres": 1000,
        "tr_yres": 1000,
        "resample": "average",
        "asscript": false,
        "fillnodata": false,
        "fillmaxdist": 0,
        "fillsmooth": 0
      },
      "srcpath": {
        "volume": "karttur",
        "hdr": "tif"
      },
      "dstpath": {
        "volume": "karttur",
        "hdr": "tif"
      },
      "srccomp": [
        {
          "copdem90": {
            "source": "ESA",
            "product": "copdem",
            "content": "dem",
            "layerid": "dem90",
            "prefix": "dem",
            "suffix": "v01-90m"
          }
        }
      ],
      "dstcopy": [
        {
          "copdem90": {
            "layerid": "dem1k",
            "prefix": "dem",
            "suffix": "v01-1k"
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

### Adjust region to projection system

To align different DEM regions you need to set the corners of your DEM such that they fit the pixels of your original DEM tiles. Karttur's GeoImagine Framework contains a support module, _regionfit_ that aligns a set of 4 corner coordinates to the selected projection system. The script can fit two different spatial resolutions for the same region. If for instance you want to apply a filtering or dual scale analysis the, _regionfit_  will make sure both resolutions are fitted both to each other and to the default projection system. The script will also generate the json codes for creating the regions.

<button id= "toggleregionfit" onclick="hiddencode('regionfit')">Hide/Show command for fitting arctic hydrological regions to the EASE-grid north system</button>

<div id="regionfit" style="display:none">

{% capture text-capture %}
{% raw %}
```
{
  "ease2n": [

    {
      "x0": -9000000,
      "y0": -9000000,
      "regionid": "nordichydro_ease2n",
      "dimdiv": 1000,
      "xres": 90,
      "yres": 90,
      "minx": 242256,
      "miny": -4650000,
      "maxx": 2080000,
      "maxy": -1845000
    },
    {
      "x0": -9000000,
      "y0": -9000000,
      "regionid": "greenlandhydro_ease2n",
      "dimdiv": 1000,
      "xres": 90,
      "yres": 90,
      "minx": -3122000,
      "miny": -2807000,
      "maxx": -179000,
      "maxy": -360080
    },
    {
      "x0": -9000000,
      "y0": -9000000,
      "regionid": "cahydro_ease2n",
      "dimdiv": 1000,
      "xres": 90,
      "yres": 90,
      "minx": -5370000,
      "miny": -2850000,
      "maxx": -2870000,
      "maxy": 295000
    },
    {
      "x0": -9000000,
      "y0": -9000000,
      "regionid": "alaskahydro_ease2n",
      "dimdiv": 1000,
      "xres": 90,
      "yres": 90,
      "minx": -4840000,
      "miny": -426000,
      "maxx": -750000,
      "maxy": 3140000
    },
    {
      "x0": -9000000,
      "y0": -9000000,
      "regionid": "kolymahydro_ease2n",
      "dimdiv": 1000,
      "xres": 90,
      "yres": 90,
      "minx": -850000,
      "miny": 1340000,
      "maxx": 2000000,
      "maxy": 4000000
    },
    {
      "x0": -9000000,
      "y0": -9000000,
      "regionid": "lenahydro_ease2n",
      "dimdiv": 1000,
      "xres": 90,
      "yres": 90,
      "minx": 1430000,
      "miny": 540000,
      "maxx": 5000000,
      "maxy": 3700000
    },
    {
      "x0": -9000000,
      "y0": -9000000,
      "regionid": "yieniseyhydro_ease2n",
      "dimdiv": 1000,
      "xres": 90,
      "yres": 90,
      "minx": 2050000,
      "miny": -434000,
      "maxx": 5000000,
      "maxy": 1730000
    },
    {
      "x0": -9000000,
      "y0": -9000000,
      "regionid": "obhydro_ease2n",
      "dimdiv": 1000,
      "xres": 90,
      "yres": 90,
      "minx": 1800000,
      "miny": -2180000,
      "maxx": 5000000,
      "maxy": 415000
    },
    {
      "x0": -9000000,
      "y0": -9000000,
      "regionid": "dvinahydro_ease2n",
      "dimdiv": 1000,
      "xres": 90,
      "yres": 90,
      "minx": 1750000,
      "miny": -2740000,
      "maxx": 2660000,
      "maxy": -1710000
    },
    {
      "x0": -9000000,
      "y0": -9000000,
      "regionid": "arcticoceanhydro_ease2n",
      "dimdiv": 1000,
      "xres": 90,
      "yres": 90,
      "minx": 242256,
      "miny": -1845000,
      "maxx": 2080000,
      "maxy": 1500000
    }
  ]
}
```
{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html  toggle-text=text-capture  %}
</div>

The script outputs two new json parameter files, one for creating the default regions, and one for creating user project linking  to the default region.

<button id= "toggledefreg" onclick="hiddencode('defreg')">Hide/Show command for creating default regions</button>

<div id="defreg" style="display:none">

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
      "system": "ease2n"
   },
   "period": {
      "timestep": "static"
   },
   "process": [
      {
         "processid": "DefaultRegionFromCoords",
         "overwrite": true,
         "parameters": {
            "regioncat": "global",
            "regionid": "nordichydro_ease2n",
            "regionname": "nordichydro_ease2n hydro ease2n",
            "parentcat": "global",
            "parentid": "global",
            "stratum": "1",
            "minx": 234000,
            "miny": -4653000,
            "maxx": 2124000,
            "maxy": -1773000,
            "version": "1.0",
            "title": "nordichydro_ease2n hydro ease2n",
            "label": "nordichydro_ease2n hydrological region for ease2n."
         },
         "dstpath": {
            "volume": "Ancillary"
         },
         "dstcomp": [
            {
               "nordichydro_ease2n": {
                  "masked": "N",
                  "measure": "N",
                  "source": "karttur",
                  "product": "pubroi",
                  "content": "roi",
                  "layerid": "hydroreg",
                  "prefix": "hydroreg",
                  "suffix": "v01-ease2n",
                  "dataunit": "boundary",
                  "celltype": "vector",
                  "cellnull": "0"
               }
            }
         ]
      },
      {
         "processid": "DefaultRegionFromCoords",
         "overwrite": true,
         "parameters": {
            "regioncat": "global",
            "regionid": "greenlandhydro_ease2n",
            "regionname": "greenlandhydro_ease2n hydro ease2n",
            "parentcat": "global",
            "parentid": "global",
            "stratum": "1",
            "minx": -3123000,
            "miny": -2808000,
            "maxx": -153000,
            "maxy": -288000,
            "version": "1.0",
            "title": "greenlandhydro_ease2n hydro ease2n",
            "label": "greenlandhydro_ease2n hydrological region for ease2n."
         },
         "dstpath": {
            "volume": "Ancillary"
         },
         "dstcomp": [
            {
               "greenlandhydro_ease2n": {
                  "masked": "N",
                  "measure": "N",
                  "source": "karttur",
                  "product": "pubroi",
                  "content": "roi",
                  "layerid": "hydroreg",
                  "prefix": "hydroreg",
                  "suffix": "v01-ease2n",
                  "dataunit": "boundary",
                  "celltype": "vector",
                  "cellnull": "0"
               }
            }
         ]
      },
      {
         "processid": "DefaultRegionFromCoords",
         "overwrite": true,
         "parameters": {
            "regioncat": "global",
            "regionid": "cahydro_ease2n",
            "regionname": "cahydro_ease2n hydro ease2n",
            "parentcat": "global",
            "parentid": "global",
            "stratum": "1",
            "minx": -5373000,
            "miny": -2853000,
            "maxx": -2853000,
            "maxy": 297000,
            "version": "1.0",
            "title": "cahydro_ease2n hydro ease2n",
            "label": "cahydro_ease2n hydrological region for ease2n."
         },
         "dstpath": {
            "volume": "Ancillary"
         },
         "dstcomp": [
            {
               "cahydro_ease2n": {
                  "masked": "N",
                  "measure": "N",
                  "source": "karttur",
                  "product": "pubroi",
                  "content": "roi",
                  "layerid": "hydroreg",
                  "prefix": "hydroreg",
                  "suffix": "v01-ease2n",
                  "dataunit": "boundary",
                  "celltype": "vector",
                  "cellnull": "0"
               }
            }
         ]
      },
      {
         "processid": "DefaultRegionFromCoords",
         "overwrite": true,
         "parameters": {
            "regioncat": "global",
            "regionid": "alaskahydro_ease2n",
            "regionname": "alaskahydro_ease2n hydro ease2n",
            "parentcat": "global",
            "parentid": "global",
            "stratum": "1",
            "minx": -4842000,
            "miny": -432000,
            "maxx": -702000,
            "maxy": 3168000,
            "version": "1.0",
            "title": "alaskahydro_ease2n hydro ease2n",
            "label": "alaskahydro_ease2n hydrological region for ease2n."
         },
         "dstpath": {
            "volume": "Ancillary"
         },
         "dstcomp": [
            {
               "alaskahydro_ease2n": {
                  "masked": "N",
                  "measure": "N",
                  "source": "karttur",
                  "product": "pubroi",
                  "content": "roi",
                  "layerid": "hydroreg",
                  "prefix": "hydroreg",
                  "suffix": "v01-ease2n",
                  "dataunit": "boundary",
                  "celltype": "vector",
                  "cellnull": "0"
               }
            }
         ]
      },
      {
         "processid": "DefaultRegionFromCoords",
         "overwrite": true,
         "parameters": {
            "regioncat": "global",
            "regionid": "kolymahydro_ease2n",
            "regionname": "kolymahydro_ease2n hydro ease2n",
            "parentcat": "global",
            "parentid": "global",
            "stratum": "1",
            "minx": -855000,
            "miny": 1332000,
            "maxx": 2025000,
            "maxy": 4032000,
            "version": "1.0",
            "title": "kolymahydro_ease2n hydro ease2n",
            "label": "kolymahydro_ease2n hydrological region for ease2n."
         },
         "dstpath": {
            "volume": "Ancillary"
         },
         "dstcomp": [
            {
               "kolymahydro_ease2n": {
                  "masked": "N",
                  "measure": "N",
                  "source": "karttur",
                  "product": "pubroi",
                  "content": "roi",
                  "layerid": "hydroreg",
                  "prefix": "hydroreg",
                  "suffix": "v01-ease2n",
                  "dataunit": "boundary",
                  "celltype": "vector",
                  "cellnull": "0"
               }
            }
         ]
      },
      {
         "processid": "DefaultRegionFromCoords",
         "overwrite": true,
         "parameters": {
            "regioncat": "global",
            "regionid": "lenahydro_ease2n",
            "regionname": "lenahydro_ease2n hydro ease2n",
            "parentcat": "global",
            "parentid": "global",
            "stratum": "1",
            "minx": 1422000,
            "miny": 540000,
            "maxx": 5022000,
            "maxy": 3780000,
            "version": "1.0",
            "title": "lenahydro_ease2n hydro ease2n",
            "label": "lenahydro_ease2n hydrological region for ease2n."
         },
         "dstpath": {
            "volume": "Ancillary"
         },
         "dstcomp": [
            {
               "lenahydro_ease2n": {
                  "masked": "N",
                  "measure": "N",
                  "source": "karttur",
                  "product": "pubroi",
                  "content": "roi",
                  "layerid": "hydroreg",
                  "prefix": "hydroreg",
                  "suffix": "v01-ease2n",
                  "dataunit": "boundary",
                  "celltype": "vector",
                  "cellnull": "0"
               }
            }
         ]
      },
      {
         "processid": "DefaultRegionFromCoords",
         "overwrite": true,
         "parameters": {
            "regioncat": "global",
            "regionid": "yieniseyhydro_ease2n",
            "regionname": "yieniseyhydro_ease2n hydro ease2n",
            "parentcat": "global",
            "parentid": "global",
            "stratum": "1",
            "minx": 2043000,
            "miny": -441000,
            "maxx": 5013000,
            "maxy": 1809000,
            "version": "1.0",
            "title": "yieniseyhydro_ease2n hydro ease2n",
            "label": "yieniseyhydro_ease2n hydrological region for ease2n."
         },
         "dstpath": {
            "volume": "Ancillary"
         },
         "dstcomp": [
            {
               "yieniseyhydro_ease2n": {
                  "masked": "N",
                  "measure": "N",
                  "source": "karttur",
                  "product": "pubroi",
                  "content": "roi",
                  "layerid": "hydroreg",
                  "prefix": "hydroreg",
                  "suffix": "v01-ease2n",
                  "dataunit": "boundary",
                  "celltype": "vector",
                  "cellnull": "0"
               }
            }
         ]
      },
      {
         "processid": "DefaultRegionFromCoords",
         "overwrite": true,
         "parameters": {
            "regioncat": "global",
            "regionid": "obhydro_ease2n",
            "regionname": "obhydro_ease2n hydro ease2n",
            "parentcat": "global",
            "parentid": "global",
            "stratum": "1",
            "minx": 1800000,
            "miny": -2187000,
            "maxx": 5040000,
            "maxy": 423000,
            "version": "1.0",
            "title": "obhydro_ease2n hydro ease2n",
            "label": "obhydro_ease2n hydrological region for ease2n."
         },
         "dstpath": {
            "volume": "Ancillary"
         },
         "dstcomp": [
            {
               "obhydro_ease2n": {
                  "masked": "N",
                  "measure": "N",
                  "source": "karttur",
                  "product": "pubroi",
                  "content": "roi",
                  "layerid": "hydroreg",
                  "prefix": "hydroreg",
                  "suffix": "v01-ease2n",
                  "dataunit": "boundary",
                  "celltype": "vector",
                  "cellnull": "0"
               }
            }
         ]
      },
      {
         "processid": "DefaultRegionFromCoords",
         "overwrite": true,
         "parameters": {
            "regioncat": "global",
            "regionid": "dvinahydro_ease2n",
            "regionname": "dvinahydro_ease2n hydro ease2n",
            "parentcat": "global",
            "parentid": "global",
            "stratum": "1",
            "minx": 1746000,
            "miny": -2745000,
            "maxx": 2736000,
            "maxy": -1665000,
            "version": "1.0",
            "title": "dvinahydro_ease2n hydro ease2n",
            "label": "dvinahydro_ease2n hydrological region for ease2n."
         },
         "dstpath": {
            "volume": "Ancillary"
         },
         "dstcomp": [
            {
               "dvinahydro_ease2n": {
                  "masked": "N",
                  "measure": "N",
                  "source": "karttur",
                  "product": "pubroi",
                  "content": "roi",
                  "layerid": "hydroreg",
                  "prefix": "hydroreg",
                  "suffix": "v01-ease2n",
                  "dataunit": "boundary",
                  "celltype": "vector",
                  "cellnull": "0"
               }
            }
         ]
      },
      {
         "processid": "DefaultRegionFromCoords",
         "overwrite": true,
         "parameters": {
            "regioncat": "global",
            "regionid": "arcticoceanhydro_ease2n",
            "regionname": "arcticoceanhydro_ease2n hydro ease2n",
            "parentcat": "global",
            "parentid": "global",
            "stratum": "1",
            "minx": 234000,
            "miny": -1845000,
            "maxx": 2124000,
            "maxy": 1575000,
            "version": "1.0",
            "title": "arcticoceanhydro_ease2n hydro ease2n",
            "label": "arcticoceanhydro_ease2n hydrological region for ease2n."
         },
         "dstpath": {
            "volume": "Ancillary"
         },
         "dstcomp": [
            {
               "arcticoceanhydro_ease2n": {
                  "masked": "N",
                  "measure": "N",
                  "source": "karttur",
                  "product": "pubroi",
                  "content": "roi",
                  "layerid": "hydroreg",
                  "prefix": "hydroreg",
                  "suffix": "v01-ease2n",
                  "dataunit": "boundary",
                  "celltype": "vector",
                  "cellnull": "0"
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

<button id= "toggleuserproj" onclick="hiddencode('userproj')">Hide/Show command for creating suer projects linking to the default refions</button>

<div id="userproj" style="display:none">

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
      "system": "ease2n"
   },
   "period": {
      "timestep": "static"
   },
   "process": [
      {
         "processid": "ManageDefRegProj",
         "overwrite": false,
         "parameters": {
            "defaultregion": "nordichydro_ease2n",
            "tractid": "karttur-nordichydro_ease2n",
            "tractname": "karttur nordichydro_ease2n",
            "projid": "karttur-nordichydro_ease2n",
            "projname": "karttur nordichydro_ease2n",
            "tracttitle": "karttur nordichydro_ease2n",
            "tractlabel": "karttur nordichydro_ease2n",
            "projtitle": "karttur nordichydro_ease2n",
            "projlabel": "karttur nordichydro_ease2n"
         }
      },
      {
         "processid": "ManageDefRegProj",
         "overwrite": false,
         "parameters": {
            "defaultregion": "greenlandhydro_ease2n",
            "tractid": "karttur-greenlandhydro_ease2n",
            "tractname": "karttur greenlandhydro_ease2n",
            "projid": "karttur-greenlandhydro_ease2n",
            "projname": "karttur greenlandhydro_ease2n",
            "tracttitle": "karttur greenlandhydro_ease2n",
            "tractlabel": "karttur greenlandhydro_ease2n",
            "projtitle": "karttur greenlandhydro_ease2n",
            "projlabel": "karttur greenlandhydro_ease2n"
         }
      },
      {
         "processid": "ManageDefRegProj",
         "overwrite": false,
         "parameters": {
            "defaultregion": "cahydro_ease2n",
            "tractid": "karttur-cahydro_ease2n",
            "tractname": "karttur cahydro_ease2n",
            "projid": "karttur-cahydro_ease2n",
            "projname": "karttur cahydro_ease2n",
            "tracttitle": "karttur cahydro_ease2n",
            "tractlabel": "karttur cahydro_ease2n",
            "projtitle": "karttur cahydro_ease2n",
            "projlabel": "karttur cahydro_ease2n"
         }
      },
      {
         "processid": "ManageDefRegProj",
         "overwrite": false,
         "parameters": {
            "defaultregion": "alaskahydro_ease2n",
            "tractid": "karttur-alaskahydro_ease2n",
            "tractname": "karttur alaskahydro_ease2n",
            "projid": "karttur-alaskahydro_ease2n",
            "projname": "karttur alaskahydro_ease2n",
            "tracttitle": "karttur alaskahydro_ease2n",
            "tractlabel": "karttur alaskahydro_ease2n",
            "projtitle": "karttur alaskahydro_ease2n",
            "projlabel": "karttur alaskahydro_ease2n"
         }
      },
      {
         "processid": "ManageDefRegProj",
         "overwrite": false,
         "parameters": {
            "defaultregion": "kolymahydro_ease2n",
            "tractid": "karttur-kolymahydro_ease2n",
            "tractname": "karttur kolymahydro_ease2n",
            "projid": "karttur-kolymahydro_ease2n",
            "projname": "karttur kolymahydro_ease2n",
            "tracttitle": "karttur kolymahydro_ease2n",
            "tractlabel": "karttur kolymahydro_ease2n",
            "projtitle": "karttur kolymahydro_ease2n",
            "projlabel": "karttur kolymahydro_ease2n"
         }
      },
      {
         "processid": "ManageDefRegProj",
         "overwrite": false,
         "parameters": {
            "defaultregion": "lenahydro_ease2n",
            "tractid": "karttur-lenahydro_ease2n",
            "tractname": "karttur lenahydro_ease2n",
            "projid": "karttur-lenahydro_ease2n",
            "projname": "karttur lenahydro_ease2n",
            "tracttitle": "karttur lenahydro_ease2n",
            "tractlabel": "karttur lenahydro_ease2n",
            "projtitle": "karttur lenahydro_ease2n",
            "projlabel": "karttur lenahydro_ease2n"
         }
      },
      {
         "processid": "ManageDefRegProj",
         "overwrite": false,
         "parameters": {
            "defaultregion": "yieniseyhydro_ease2n",
            "tractid": "karttur-yieniseyhydro_ease2n",
            "tractname": "karttur yieniseyhydro_ease2n",
            "projid": "karttur-yieniseyhydro_ease2n",
            "projname": "karttur yieniseyhydro_ease2n",
            "tracttitle": "karttur yieniseyhydro_ease2n",
            "tractlabel": "karttur yieniseyhydro_ease2n",
            "projtitle": "karttur yieniseyhydro_ease2n",
            "projlabel": "karttur yieniseyhydro_ease2n"
         }
      },
      {
         "processid": "ManageDefRegProj",
         "overwrite": false,
         "parameters": {
            "defaultregion": "obhydro_ease2n",
            "tractid": "karttur-obhydro_ease2n",
            "tractname": "karttur obhydro_ease2n",
            "projid": "karttur-obhydro_ease2n",
            "projname": "karttur obhydro_ease2n",
            "tracttitle": "karttur obhydro_ease2n",
            "tractlabel": "karttur obhydro_ease2n",
            "projtitle": "karttur obhydro_ease2n",
            "projlabel": "karttur obhydro_ease2n"
         }
      },
      {
         "processid": "ManageDefRegProj",
         "overwrite": false,
         "parameters": {
            "defaultregion": "dvinahydro_ease2n",
            "tractid": "karttur-dvinahydro_ease2n",
            "tractname": "karttur dvinahydro_ease2n",
            "projid": "karttur-dvinahydro_ease2n",
            "projname": "karttur dvinahydro_ease2n",
            "tracttitle": "karttur dvinahydro_ease2n",
            "tractlabel": "karttur dvinahydro_ease2n",
            "projtitle": "karttur dvinahydro_ease2n",
            "projlabel": "karttur dvinahydro_ease2n"
         }
      },
      {
         "processid": "ManageDefRegProj",
         "overwrite": false,
         "parameters": {
            "defaultregion": "arcticoceanhydro_ease2n",
            "tractid": "karttur-arcticoceanhydro_ease2n",
            "tractname": "karttur arcticoceanhydro_ease2n",
            "projid": "karttur-arcticoceanhydro_ease2n",
            "projname": "karttur arcticoceanhydro_ease2n",
            "tracttitle": "karttur arcticoceanhydro_ease2n",
            "tractlabel": "karttur arcticoceanhydro_ease2n",
            "projtitle": "karttur arcticoceanhydro_ease2n",
            "projlabel": "karttur arcticoceanhydro_ease2n"
         }
      }
   ]
}
```
{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html  toggle-text=text-capture  %}
</div>


### Link DEM tiles to the default region

Before you can create the regional DEM, the system tiles covering the new region must be identified and registered. The Framework process _LinkDefaultRegionTiles_ does that.

<button id= "togglelinktiles" onclick="hiddencode('linktiles')">Hide/Show command for linking default regions to tiles</button>

<div id="linktiles" style="display:none">

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
    "system": "ease2n"
  },
  "period": {
    "timestep": "static"
  },
  "process": [
    {
      "processid": "LinkDefaultRegionTiles",
      "version": "0.9",
      "verbose": 2,
      "parameters": {
        "defregmask": "global"
        },
      "srcpath": {
        "volume": "MODIS56",
        "hdr": "shp",
        "dat": "shp"
      },
      "srccomp": [
        {
          "regions": {
            "source": "karttur",
            "product": "roi",
            "content": "pubroi",
            "layerid": "defreg",
            "prefix": "defreg",
            "suffix": "v010"
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

### Mosaic a regional DEM

Create the regional DEM layer from tiles with the process _MosaicTiles_.

<button id= "togglemosaictiles" onclick="hiddencode('mosaictiles')">Hide/Show command for Mosaic tiles</button>

<div id="mosaictiles" style="display:none">

{% capture text-capture %}
{% raw %}

```
{
  "userproject": {
    "userid": "karttur",
    "projectid": "karttur-nordichydro",
    "tractid": "karttur-nordichydro",
    "siteid": "*",
    "plotid": "*",
    "system": "ease2n"
  },
  "period": {
    "timestep": "static"
  },
  "process": [
    {
      "processid": "MosaicTiles",
      "version": "1.3",
      "overwrite": true,
      "parameters": {
        "tr_xres": 90,
        "tr_yres": 90,
        "resample": "near",
        "asscript": false,
        "fillnodata": true,
        "fillmaxdist": 3,
        "fillsmooth": 0
      },
      "srcpath": {
        "volume": "MODIS56"
      },
      "dstpath": {
        "volume": "MODIS56"
      },
      "srccomp": [
        {
          "dem90": {
            "source": "ESA-DUE",
            "product": "panarcticdem",
            "content": "dem",
            "layerid": "panarcticdem90",
            "prefix": "dem90",
            "suffix": "v01"
          }
        }
      ],
      "dstcopy": [
        {
          "dem90": {
            "srccomp": "dem_dem90",
            "layerid": "panarcticdem90"
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
