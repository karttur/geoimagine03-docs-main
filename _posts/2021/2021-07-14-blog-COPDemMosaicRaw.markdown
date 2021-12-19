---
layout: post
title: Mosaic, import and tile CopDEM
categories: blog
datasource: dem
thematic: copdem
excerpt: "Mosaic Copernicus DEM to a virtual dataset and then import and tile the virtual dataset"
tags:
  - Copernicus DEM
  - mosaic
  - import
  - organize
  - tile
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2021-07-14 T18:17:25.000Z'
modified: '2021-07-14 T18:17:25.000Z'
comments: true
share: true
---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>

# Introduction

Several of the global DEMs listed in the post on [Digital Elevation Models (DEMs)](../blog-global-dem) come as tiled layers in geographic (latitude and longitude) postions. Some also require that you have an account and give your credentials before accessing. Once you have accessed and downloaded the tiles, it makes no sense importing individual tiles to Karttur´s GeoImagine Framework. Instead you should create a virtual mosaic of the raw tiled data, import (organize) the mosaic and then tile the mosaic into the Framework projection system.

# Overview

This post will take you through the steps for searching, downloading, exploding,  mosaicking and importing Copernicus DEM data. The first parts deals with the 90 m version available from [https://gisco-services.ec.europa.eu/dem/copernicus/outD/](https://gisco-services.ec.europa.eu/dem/copernicus/outD/). These tiles come as zip files and requires exploding before mosaicking. The [versions available from AWS](https://registry.opendata.aws/copernicus-dem/) do not require any prior search or unzipping but are retrieved as geotiff files and if you just want to process them, you can skip to the section called **Mosaic ancillary**.

## Search tiles

Many global datasets are delivered as tiles and to access them using machine scripting you must list the urls beforehand. For the Copernicus DEM data available from [https://gisco-services.ec.europa.eu/dem/copernicus/outD/](https://gisco-services.ec.europa.eu/dem/copernicus/outD/), the process _SearchCopernicusProduct_ searches and lists all the Copernicus 90 tiles.

<button id= "togglesearch" onclick="hiddencode('searchdiv')">Hide/Show Search for Copernicus products (json)</button>
<div id="searchdiv" style="display:none">
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
      "processid": "SearchCopernicusProducts",
      "dsversion": "1.3",
      "parameters": {
        "remoteuser": "UserName",
        "product": "CopernicusDem90",
        "version": "",
        "serverurl": "https://gisco-services.ec.europa.eu"
      },
      "srcpath": {
        "volume": "karttur"
      },
      "dstpath": {
        "volume": "karttur"
      }
    }
  ]
}
```
{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html  toggle-text=text-capture  %}
</div>

## Download tiles

The search results in a <span class='file'>html</span> file that lists all the available urls. The Framework process _DownloadCopernicus_ loops the <span class='file'>html</span> file and downloads all the listed tiles.

<button id= "toggledownloadh" onclick="hiddencode('downloaddiv')">Hide/Show Download for Copernicus products (json)</button>
<div id="downloaddiv" style="display:none">
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
      "processid": "DownloadCopernicus",
      "dsversion": "1.3",
      "parameters": {
        "remoteuser": "Gumbricht",
        "product": "CopernicusDem90",
        "version": "",
        "doneserach": true,
        "serverurl": "https://gisco-services.ec.europa.eu"
      },
      "srcpath": {
        "volume": "karttur"
      },
      "dstpath": {
        "volume": "karttur"
      }
    }
  ]
}
```
{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html  toggle-text=text-capture  %}
</div>

## Explode zip

The tiles from [https://gisco-services.ec.europa.eu/dem/copernicus/outD/](https://gisco-services.ec.europa.eu/dem/copernicus/outD/) are zipped, and also contain multiple layers. To only explode the DEM data layers of each zip file, use the Framework process _UnZipRawData_.

<button id= "toggleunzip" onclick="hiddencode('unzipdiv')">Hide/Show Unzip for Copernicus products (json)</button>
<div id="unzipdiv" style="display:none">
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
    "system": "ancillary"
  },
  "period": {
    "timestep": "static"
  },
  "process": [
    {
      "processid": "UnZipRawData",
      "dsversion": "1.3",
      "parameters": {
        "path": "/Volumes/Ancillary/DOWNLOADS/CopernicusDem90/CopernicusDem90-0.csv",
        "rootdir": "RAWAUXILIARY/CopernicusDem90",
        "srcsubdir": "",
        "dstsubdir": "DEM",
        "getlist": "csvfile-getpath1",
        "pattern": "DEM",
        "zipreplace": ".tif",
        "minlon": -180,
        "maxlon": 180,
        "minlat": -90,
        "maxlat": 90
      },
      "srcpath": {
        "volume": "Ancillary"
      },
      "dstpath": {
        "volume": "Ancillary"
      }
    }
  ]
}
```
{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html  toggle-text=text-capture  %}
</div>

## Mosaic ancillary

To actually import the tiles, we are first going to create one large, global and virtual mosaic, and then import just this virtual mosaic. In later steps you will tile the DEM into the default systems used by the Framework, but starting with the virtual mosaic.

If you downloaded the 30 m or 90 m version using [AWS Open Data](https://registry.opendata.aws/copernicus-dem/) (as described in the post on [Digital Elevation Models (DEMs)](../blog-global-dems)), then you can start from here.

The Framework contains a special process, _MosaicAncillary_, for creating a list of all files of a particular kind or pattern. Setting the parameter _mosaiccode_ to _subdirfiles_ the process recursively traverses all subfolders under a root.

<button id= "togglemosaic" onclick="hiddencode('mosaicdiv')">Hide/Show Mosaic Copernicus products (json)</button>
<div id="mosaicdiv" style="display:none">
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
    "system": "ancillary"
  },
  "period": {
    "timestep": "static"
  },
  "process": [
    {
      "processid": "MosaicAncillary",
      "overwrite": false,
      "parameters": {
        "mosaiccode": "subdirfiles",
        "datadir": "RAWAUXILIARY/CopernicusDem90/DEM",
        "datafile": "CopernicusDem90_mosaic"
      },
      "srcpath": {
        "volume": "Ancillary",
        "hdr": "tif"
      },
      "dstpath": {
        "volume": "Ancillary",
        "hdr": "vrt"
      },
      "dstcomp": [
        {
          "copernicusdem90": {
            "source": "ESA",
            "product": "copernicusdem",
            "content": "dem",
            "layerid": "copernicusdem90",
            "prefix": "dem90",
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

## Import

Import the virtual mosaic as an ancillary layer to the Framework with the process _OrganizeAncillary_. Before you do that you need to check in the original virtual mosaic that the link to the original tiles is absolute - alternatively you need to create the original mosaic in the destination folder of the import function.

<button id= "toggleimport" onclick="hiddencode('importdiv')">Hide/Show Import Copernicus products (json)</button>
<div id="importdiv" style="display:none">
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
    "system": "ancillary"
  },
  "period": {
    "timestep": "static"
  },
  "process": [
    {
      "processid": "OrganizeAncillary",
      "overwrite": false,
      "parameters": {
        "importcode": "vrt",
        "epsg": "4326",
        "orgid": "ESA",
        "dsname": "copem30",
        "dsversion": "1.0",
        "accessdate": "20210320",
        "regionid": "global",
        "regioncat": "global",
        "dataurl": "https://registry.opendata.aws/copernicus-dem/",
        "metaurl": "https://docs.sentinel-hub.com/api/latest/data/dem/",
        "title": "Copernicus DEM global 30 m",
        "label": "Copernicus DEM global 30 m"
      },
      "srcpath": {
        "volume": "Ancillary",
        "hdr": "vrt"
      },
      "dstpath": {
        "volume": "Ancillary",
        "hdr": "vrt"
      },
      "srcraw": [
        {
          "copdem30": {
            "datadir": "/Volumes/Ancillary/ancillary/ESA/region/dem/global/0/",
            "datafile": "dem_copdem_global_0_v01-full",
            "datalayer": "DEM",
            "title": "Copernicus DEM global 30 m",
            "label": "Copernicus DEM global 30 m"
          }
        }
      ],
      "dstcomp": [
        {
          "copdem30": {
            "source": "ESA",
            "product": "copdem",
            "content": "dem",
            "layerid": "copdem",
            "prefix": "dem",
            "suffix": "v01-30m",
            "scalefac": 1,
            "offsetadd": 0,
            "dataunit": "masl",
            "celltype": "Float32",
            "cellnull": -32767,
            "measure": "R",
            "masked": "N"
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

## Tiling

Before you can tile the mosaicked original DEM data you must have created a project and a region for your user that defines the tiles to create. How to do that is covered in the post on [Arctic DEM](../blog-ArcticDem). In the example below I have a _projectid_ and _tractid_ called _karttur-northlandease2n_ that is based on a default region called _northlandease2n_. This region is defined using EASE-grid North (EPSG:6931) and covers all tiles that contain at least a single cell of land. The Framework for this region is _ease2n_. In essence this means that the global Copernicus DEM mosaic will be tiled into 104 seamless pieces that together cover all land masses of the northern hemisphere above approximately 30 degrees North.


<button id= "toggletiling" onclick="hiddencode('tilingdiv')">Hide/Show tile Copernicus products (json)</button>
<div id="tilingdiv" style="display:none">
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
      "processid": "TileAncillaryRegion",
      "version": "1.3",
      "overwrite": false,
      "parameters": {
        "defregid": "global",
        "tr_xres": 90,
        "tr_yres": 90,
        "resample": "bilinear",
        "asscript": true
      },
      "srcpath": {
        "volume": "Ancillary",
        "hdr": "vrt"
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
            "suffix": "v01-90m",
            "cellnull": -32767
          }
        }
      ],
      "dstcopy": [
        {
          "copdem90": {
            "srccomp": "dem_copdem"
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
