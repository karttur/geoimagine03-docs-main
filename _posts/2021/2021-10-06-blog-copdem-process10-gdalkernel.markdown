---
layout: post
title: "DEM processing 10: Extracting kernel indexes with GDAL"
categories: blog
datasource: dem
biophysical: elevation
excerpt: "Process chain for Copernicus DEM: xtracting kernel indexes with GDAL"
tags:
  - DEM
  - GDALDEM
  - kernel
  - index
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2021-10-06 T18:17:25.000Z'
modified: '2021-10-06 T18:17:25.000Z'
comments: true
share: true
figure1: soil-moisture-avg_SPL3SMP_global_2015-2018@D001_005

---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>

## Introduction

A plethora of different indexes can be extracted from Digital Elevation Models (DEMs). This post covers the indexes that can be retrieved using [GDALDEM](https://gdal.org/programs/gdaldem.html).

## Prerequisites

You must have a systematically tiled DEM setup with Karttur´s GeoImagine Framework. As outlined in the provious posts on elevation data in this blog.

## Framework process

The Framework process for extracting indices from tiled DEMs using [GDALDEM](https://gdal.org/programs/gdaldem.html) is _GdalDemTiles_. _GdalDemTiles_ is just an envelop binding to [GDALDEM](https://gdal.org/programs/gdaldem.html).

### Json parameterization

For the Copernicus DEM example used throughout this blog, the json parameterization for _GdalDemTiles_ is under the <span class='button'>Hide/Show</span> button.

<button id= "togglejson" onclick="hiddencode('processchain')">Hide/Show 0301_GdalDemTiles_CopDEM-90m.json</button>

<div id="processchain" style="display:none">

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
      "processid": "GdalDemTiles",
      "version": "1.3",
      "overwrite": true,
      "parameters": {
        "mode": "hillshade",
        "mosaic": true,
        "palette": "",
        "radiuscsv": "1",
        "asscript": true
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
        {
          "copdem90": {
            "source": "ESA",
            "product": "copdem",
            "content": "dem",
            "layerid": "copdem",
            "prefix": "dem",
            "suffix": "v01-90m"
          }
        }
      ],
      "dstcopy": [
        {
          "copdem90": {
            "layerid": "auto",
            "prefix": "auto",
            "suffix": "auto",
            "dataunit": "auto"
          }
        }
      ]
    },
    {
      "processid": "GdalDemTiles",
      "version": "1.3",
      "overwrite": true,
      "parameters": {
        "mode": "TPI",
        "mosaic": true,
        "radiuscsv": "1,3",
        "asscript": true
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
        {
          "copdem90": {
            "source": "ESA",
            "product": "copdem",
            "content": "dem",
            "layerid": "copdem",
            "prefix": "dem",
            "suffix": "v01-90m"
          }
        }
      ],
      "dstcopy": [
        {
          "copdem90": {
            "layerid": "auto",
            "prefix": "auto",
            "suffix": "auto",
            "dataunit": "auto"
          }
        }
      ]
    },
    {
      "processid": "GdalDemTiles",
      "version": "1.3",
      "overwrite": true,
      "parameters": {
        "mode": "TRI",
        "algorithm": "Riley",
        "mosaic": true,
        "radiuscsv": "1,3",
        "asscript": true
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
        {
          "copdem90": {
            "source": "ESA",
            "product": "copdem",
            "content": "dem",
            "layerid": "copdem",
            "prefix": "dem",
            "suffix": "v01-90m"
          }
        }
      ],
      "dstcopy": [
        {
          "copdem90": {
            "layerid": "auto",
            "prefix": "auto",
            "suffix": "auto",
            "dataunit": "auto"
          }
        }
      ]
    },
    {
      "processid": "GdalDemTiles",
      "version": "1.3",
      "overwrite": true,
      "parameters": {
        "mode": "slope",
        "mosaic": true,
        "radiuscsv": "1,3",
        "asscript": true
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
        {
          "copdem90": {
            "source": "ESA",
            "product": "copdem",
            "content": "dem",
            "layerid": "copdem",
            "prefix": "dem",
            "suffix": "v01-90m"
          }
        }
      ],
      "dstcopy": [
        {
          "copdem90": {
            "layerid": "auto",
            "prefix": "auto",
            "suffix": "auto",
            "dataunit": "auto"
          }
        }
      ]
    },
    {
      "processid": "GdalDemTiles",
      "version": "1.3",
      "overwrite": true,
      "parameters": {
        "mode": "aspect",
        "mosaic": true,
        "radiuscsv": "1",
        "asscript": true
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
        {
          "copdem90": {
            "source": "ESA",
            "product": "copdem",
            "content": "dem",
            "layerid": "copdem",
            "prefix": "dem",
            "suffix": "v01-pfpf-hydrdem4+4-90m"
          }
        }
      ],
      "dstcopy": [
        {
          "copdem90": {
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

The json parameterization calls _GdalDemTiles_ x times to generate the following indices:

- hillshade (radius: 1 cell)
- TPI (radius: 1, 3 cell)
- TRI (radius: 1, 3 cell)
- slope (radius: 1, 3 cell)
- aspect (radius: 1 cell)

Hillshade and aspect are only produced for a kernel with a radius of 1 cell (kernel with 3 x 3 cells). Topographic Position index (TPI), Topographic Roughness Index (TRI) and slope are produced using two different kernel radiuses, 1 and 3 cells.


### Hillshade
