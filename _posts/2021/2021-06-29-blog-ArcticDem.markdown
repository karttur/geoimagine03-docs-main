---
layout: post
title: Arctic DEM
categories: blog
datasource: dem
biophysical: geomorphology
excerpt: "Downloading and organization the Arctic Digital Elevation Model (DEM)"
tags:
  - DEM
  - Acrtic DEM
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2021-06-29 T18:17:25.000Z'
modified: '2021-06-29 T18:17:25.000Z'
comments: true
share: true
fig1: arcticdem_polar-stereographic
fig2: arcticdem_h18v02
---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>

# Introduction

A Digital Elevation Model (DEM) is a general representation of heights above or below a reference geoid (where the geoid is a mathematical shape of an orb, for instance Earth). A Digital Terrain Model (DTM) refers to the natural surface of the Earth, i.e. disregarding vegetation, buildings and other 3 dimensional (3D) human structures. A Digital Surface Model (DSM) instead includes all human 3D objects. Theoretically the conceptual definitions of DTM and DSM are more strict, with DEM being more widely defined. In reality the three concepts are mixed and note seldom used interchangeably. The [Arctic DEM](https://www.pgc.umn.edu/data/arcticdem/) is defined as a DSM.

# Overview

In this post you will add the ArcticDEM to your GeoImagine Framework. To be effective and cover the correct region, you have to start with defining a default region that fits the ArcticDEM. Then you have to link that default region to a project owned by your user (i.e. the system superuser). When you have created your own project and region you can import the ArcticDEM as an ancillary layer, and then tile it to one the predefined systems available in the Framework (i.e. the MODIS SIN grid, or an EASE-grid).

# Arctic DEM

The Arctic DEM is an effort led by the United States National Geospatial-Intelligence Agency (NGA) and the National Science Foundation (NSF) to create a high resolution DEM of the Arctic land area. The DEM is created from optical stereo imagery, high-performance computing, and open source photogrammetry software. The DEM covers all land areas north of 60 degrees, all territory of Greenland, the State of Alaska in entirety, and the Kamchatka Peninsula of the Russian Federation.

<figure>
<img src="{{ site.commonurl }}/images/{{ site.data.images[page.fig1].file }}">
<figcaption> {{ site.data.images[page.fig1].caption }} </figcaption>
</figure>

## Create a default regions

To accommodate and work with the Arctic region in Karttur´s GeoImagine Framework, you need to create corresponding default regions. In my version I created three new default regions as defined in the json file below:

<button id= "togglecreateregion" onclick="hiddencode('createregion')">Hide/Show add_special_default_regions_v090.json</button>

<div id="createregion" style="display:none">

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
      "processid": "DefaultRegionFromCoords",
      "overwrite": false,
      "parameters": {
        "regioncat": "global",
        "regionid": "arcticdem",
        "regionname": "Arctic circumpolar DEM",
        "parentid": "globe",
        "parentcat": "globe",
        "epsg": "4326",
        "stratum": "1",
        "minx": -180,
        "miny": 58,
        "maxx": 180,
        "maxy": 90,
        "version": "1.0",
        "title": "Global arctic DEM",
        "label": "Region covering 60 to 90 degrees north, coinciding with the core region of the Arctic DEM."
      },
      "dstpath": {
        "volume": "geoinfo2021"
      }
    },
    {
      "processid": "DefaultRegionFromCoords",
      "overwrite": false,
      "parameters": {
        "regioncat": "global",
        "regionid": "arcticland",
        "regionname": "Arctic circumpolar land",
        "parentid": "globe",
        "parentcat": "globe",
        "stratum": "1",
        "minx": -180,
        "miny": 58,
        "maxx": 180,
        "maxy": 84,
        "version": "1",
        "title": "Global arctic land zone",
        "label": "Region covering arctic cricumpolar land masses extending from 58 to 84 degrees north."
      },
      "dstpath": {
        "volume": "geoinfo2021"
      },
      "dstcomp": [
        {
          "arcticland": {
            "masked": "N",
            "measure": "N",
            "source": "karttur",
            "product": "pubroi",
            "content": "roi",
            "layerid": "defreg",
            "prefix": "defreg",
            "suffix": "v010",
            "dataunit": "boundary",
            "celltype": "vector",
            "cellnull": "0"
          }
        }
      ]
    },
    {
      "processid": "DefaultRegionFromCoords",
      "overwrite": false,
      "parameters": {
        "regioncat": "global",
        "regionid": "arcticdemext",
        "regionname": "Arctic circumpolar DEM",
        "parentid": "globe",
        "parentcat": "globe",
        "stratum": "1",
        "minx": -180,
        "miny": 50,
        "maxx": 180,
        "maxy": 90,
        "version": "1",
        "title": "Global arctic extended DEM",
        "label": "Region covering 50 to 90 degrees north, coinciding with the extended region of the Arctic DEM."
      }
    }
  ]
}
```

{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html  toggle-text=text-capture  %}
</div>

### Create user tracts linked to arctic regions

The Framework is built in such a way that no user, including the super users, can use default regions for actual data processing. All processing can only be done vis-a-vis regions that are owned by the logged in user. Thus you have to create user regions (called "tracts") that correspond to the default regions that you created above.

<button id= "togglecreatedefregproj" onclick="hiddencode('defregproj')">Hide/Show add_user_projects-regions_arctic.json</button>

<div id="defregproj" style="display:none">

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
      "processid": "ManageDefRegProj",
      "overwrite": false,
      "parameters": {
        "defaultregion": "arcticland",
        "tractid": "karttur-arcticland",
        "tractname": "karttur arcticland",
        "projid": "karttur-arcticland",
        "projname": "karttur arcticland",
        "tracttitle": "Karttur arcticland",
        "tractlabel": "Karttur arcticland",
        "projtitle": "Karttur arcticland",
        "projlabel": "Karttur arcticland"
      }
    },
    {
      "processid": "ManageDefRegProj",
      "overwrite": false,
      "parameters": {
        "defaultregion": "arcticdem",
        "tractid": "karttur-arcticdem",
        "tractname": "karttur arcticdem",
        "projid": "karttur-arcticdem",
        "projname": "karttur arcticdem",
        "tracttitle": "Karttur arcticdem",
        "tractlabel": "Karttur arcticdem",
        "projtitle": "Karttur arcticdem",
        "projlabel": "Karttur arcticdem"
      }
    },
    {
      "processid": "ManageDefRegProj",
      "overwrite": false,
      "parameters": {
        "defaultregion": "arcticdemext",
        "tractid": "karttur-arcticdemext",
        "tractname": "karttur arcticdemext",
        "projid": "karttur-arcticdemext",
        "projname": "karttur arcticdemext",
        "tracttitle": "Karttur arcticdemext",
        "tractlabel": "Karttur arcticdemext",
        "projtitle": "Karttur arcticdemext",
        "projlabel": "Karttur arcticdemext"
      }
    }
  ]
}

```
{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html  toggle-text=text-capture  %}
</div>

## Data access and download

The [Artic DEM](https://www.pgc.umn.edu/data/arcticdem/) is freely available from [GRACE TELLUS](http://data.pgc.umn.edu/elev/dem/setsm/ArcticDEM). The data are available through ftp (ftp.data.pgc.umn.edu/ and then under the folder tree elev/dem/setsm/ArcticDEM). The mosaics at 100 m and coarser resolution are available as single file mosaics.

Karttur's GeoImagine Framework does not include any process for downloading the Arctic DEM. To download the Arctic DEM, please use any FTP client (for example [Filezilla](https://filezilla-project.org)).

At time of writing, the Arctic DEM version is 3.0, and the two files that I downloaded where the 100 and 500 m mosaics:

- arcticdem_mosaic_100m_v3.0.tif
- arcticdem_mosaic_500m_v3.0.tif

## Import as ancillary data

DEM data is imported to the Framework as ancillary data, in the example import below both the 100 and 500 m versions are imported. Note that the project and tract for importing are set to the extended arctic region, as defined above.

<button id= "toggleimport" onclick="hiddencode('import')">Hide/Show ancillary-import-arcticDEM.json</button>

<div id="import" style="display:none">

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
        "importcode": "tif",
        "epsg": "3413",
        "orgid": "NGA-NSF",
        "dsname": "arctiddem",
        "dsversion": "3.0",
        "accessdate": "20181110",
        "regionid": "arcticdem",
        "regioncat": "global",
        "dataurl": "",
        "metaurl": "",
        "title": "Arctic DEM",
        "label": "Arctice Digitial Surface Model"
      },
      "srcpath": {
        "volume": "karttur",
        "hdr": "tif",
        "dat": "tif"
      },
      "dstpath": {
        "volume": "karttur",
        "hdr": "tif",
        "dat": "tif"
      },
      "srcraw": [
        {
          "dem500": {
            "datadir": "ancillary/arcticdem",
            "datafile": "arcticdem_mosaic_500m_v3.0",
            "datalayer": "DEM",
            "title": "Arctic DEM",
            "label": "Arctice Digitial Surface Modeln"
          },
          "dem100": {
            "datadir": "ancillary/arcticdem",
            "datafile": "arcticdem_mosaic_100m_v3.0",
            "title": "Arctic DEM",
            "label": "Arctice Digitial Surface Modeln"
          }
        }
      ],
      "dstcomp": [
        {
          "dem500": {
            "source": "NGA-NSF",
            "product": "arcticdem",
            "content": "dem",
            "layerid": "dem500",
            "prefix": "dem500",
            "suffix": "v30",
            "scalefac": 1,
            "offsetadd": 0,
            "dataunit": "masl",
            "celltype": "Float32",
            "cellnull": -9999,
            "measure": "R",
            "masked": "N"
          }
        },
        {
          "dem100": {
            "source": "NGA-NSF",
            "product": "arcticdem",
            "content": "dem",
            "layerid": "dem100",
            "prefix": "dem100",
            "suffix": "v30",
            "scalefac": 1,
            "offsetadd": 0,
            "dataunit": "masl",
            "celltype": "Float32",
            "cellnull": -9999,
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

## Link MODIS tiles

One of the basic concepts behind Karttur´s GeoImagine Framework is to use tiling systems for processing the Earth's surface piecewise. The main tiling systems in use are :

- MODIS sinusoidal grid
- EASE-grids (north polar, south polar and tropical)
- MGRS (UTM based)

The json command file below identifies all MODIS SIN tiles that overlap with the Arctic regions (defined in the json object above). To change to any other default system you just have to change the _system_ parameter under _userproject_ (e.g. to _ease2n_ for EASE-grid north [EPSG:6931]).

If your Framework lack the MODIS tiles, you need to setup the regions, including the MODIS tiling system as described in the post on setting up regions [LINK NEEDED]. Setting the parameter _defregmask_ to _land_ limits the identified tiles to those that actually cover at least a single pixel of land surface.

<button id= "togglelinkmodis" onclick="hiddencode('linkmodis')">Hide/Show regions-modtiles_v090.json</button>

<div id="linkmodis" style="display:none">

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
    "system": "modis"
  },
  "period": {
    "timestep": "static"
  },
  "process": [
    {
      "processid": "LinkDefaultRegionTiles",
      "overwrite": false,
      "version": "0.9",
      "verbose": 2,
      "parameters": {
        "defregmask": "land"
        },
      "srcpath": {
        "volume": "Ancillary",
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

To run the actual tiling below, you must have identified the tiles covering the region.

## Tiling

At this stage your Framework should contain:

- ArcticDEM (imported as ancillary layer)
- Arctic default regions coinciding with the spatial extent of the arcticDEM
- User project and tract built from the ArcticDEM fitted default region(s)
- MODIS tiles coinciding with the ArcticDEM fitted default region(s)

If you have all of the above, you can tile the ArcticDEM data to the MODIS SIN grid system.

<button id= "toggletilings" onclick="hiddencode('tilingdiv')">Hide/Show tile_ArcticDEM2modis.json</button>

<div id="tilingdiv" style="display:none">

{% capture text-capture %}
{% raw %}

```
{
  "userproject": {
    "userid": "karttur",
    "projectid": "karttur-arcticdem",
    "tractid": "karttur-arcticdem",
    "siteid": "*",
    "plotid": "*",
    "system": "modis"
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
        "defregid": "arcticdemext",
        "tr_xres": 500,
        "tr_yres": 500,
        "resample": "near",
        "asscript": false
      },
      "srcpath": {
        "volume": "karttur"
      },
      "dstpath": {
        "volume": "karttur"
      },
      "srccomp": [
        {
          "dem500": {
            "source": "NGA-NSF",
            "product": "arcticdem",
            "content": "dem",
            "layerid": "dem500",
            "prefix": "dem500",
            "suffix": "v30"
          }
        }
      ],
      "dstcopy": [
        {
          "dem500": {
            "srccomp": "dem_dem500",
            "layerid": "dem500"
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

The json above generates a shell script that you must run manually. The code snippet below shows the code for generating a single tile (h18v02 central Scandinavia) shown in the figure below.

```
mkdir -p /Volumes/karttur3tb/modis/NGA-NSF/tiles/dem/h18/v02/0;
/Library/Frameworks/GDAL.framework/Versions/2.1/Programs/gdalwarp -t_srs "+proj=sinu +lon_0=0 +x_0=0 +y_0=0 +a=6371007.181 +b=6371007.181 +units=m +no_defs " -tr 463.313000000 463.313000000  -te 0.0 6671703.118 1111950.51966667 7783653.63766667  -r near  /Volumes/karttur3tb/ancillary/NGA-NSF/region/dem/arcticdemext/0/dem500_arcticdem_arcticdemext_0_v30.tif /Volumes/karttur3tb/modis/NGA-NSF/tiles/dem/h18/v02/0/dem500_arcticdem_h18v02_0_v30.tif;
```

<figure>
<img src="{{ site.commonurl }}/images/{{ site.data.images[page.fig2].file }}">
<figcaption> {{ site.data.images[page.fig2].caption }} </figcaption>
</figure>

As you can see in the figure above there are quite a lot of no data in the Arctic DEM. Alternative DEMs and how to download them is described in the post [Digital Elevation Models (DEMs)](../blog-global-dems).
