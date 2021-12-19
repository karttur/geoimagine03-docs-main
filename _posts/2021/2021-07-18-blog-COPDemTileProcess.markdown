---
layout: post
title: DEM neighbourhood analysis
categories: blog
datasource: dem
excerpt: "Deriving DEM measures and indexes from kernel neighbourhood analysis"
tags:
  - Copernicus DEM
  - kernel
  - slope
  - aspect
  - curvature
  - TPI
  - TRI
  - roughness
  - geomophology
  - landform
  - r.param.scale
  - r.geomprphon
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2021-07-18 T18:17:25.000Z'
modified: '2021-07-18 T18:17:25.000Z'
comments: true
share: true
---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>

# Introduction

From Digital Elevation Models (DEMs) a plethora of measures and indices can be extracted by analysing a the elevation variations within a moving window or kernel. Karttur´s GeoImagine Framework can derive such measures and indices using either interfacing to [gdaldem](https://gdal.org/programs/gdaldem.html), calling the [GRASS GIS](https://grass.osgeo.org) commands [r.slope.aspect](https://grass.osgeo.org/grass78/manuals/r.slope.aspect.html), [r.param.scale](https://grass.osgeo.org/grass78/manuals/r.param.scale.html) or [r.geomorphon](https://grass.osgeo.org/grass78/manuals/r.geomorphon.html) (and other GRASS commands), and a few builtin (improved) processes.

# Overview

This post illustrates the use of Karttur's GeoImagine Framework for neighbourhood (kernel) analysis of DEMs. While there is a limited set of measures and indices (about 20) that can be calculated, the calculations can be done on any size kernel, and with all kinds of kernel smoothing and enhancement (with kernels of different shapes and geometric value properties) as pre-processing. This in effect means that there is an infinite amount of measures and indices that can be produced. The first section of this post is an attempt to categorize the measures and indices. Thereafter follows examples on how to retrieve some of them using the Framework.

## Measures and indices derived from DEM neighbourhood analysis

I have divided the measures and indices that can be derived from a DEM neoghborhood analysis in 4 classes:

- geographic
- metric
- indices
- classes

### Geographic

- Aspect
- Hillshade

Aspect (direction around the horizon of the steepest slope) and hillshade are unique in the sense that they are only relevant in a geographic context. All other measures and indices can be regarded as local, not so aspect or hillshade. Aspect can be defined starting either in the North, East or West direction, more seldom in the South. Hillshade requires an altitude and azimuth ('aspect') of the suns position.

### Metric

Most derivates compare the central cell with the neighbours falling inside the kernel. Some indices are explicitly metric, while others use mathematical conversions or normalizations nd might be considers without dimensions. As the definitions, however, are based on well defined metric conditions, I have put also such indices in this group.

- slope (drop in elevation [m/m] along steepest slope)
- intensity (mean elevation in kernel [m])
- exposition (maximum difference in kernel and central cell [m])
- range (difference between highest and lowest elevation in kernel [m])
- variance (variation in elevation within kernel [m])
- TPI [Topographic Position Index] (the difference in elevation [m] between the central cell and all neighbours)
- TRI [Topographic Ruggedness Index] (A measure of total and absolute elevation difference [m] between the central cell and all neighbours)
- roughness (largest inter-cell difference [m] between the central cell and all neighbours)
- elongations (within kernel shape length [m] of line-of-sight pattern)
- width (within kernel shape width [m] of line-of-sight pattern)
- extend (within kernel area [m**2] shape of line-of-sight pattern)
- profile curvature (radius [m] of curvature along maximum gradient direction (steepest slope))
- plan curvature (curvature [m] in a horizontal plane
- cross sectional curvature (curvature radius [m] perpendicular to the profile curvature)
- longitudinal curvature (curvature radius [m] defined by the surface normal and maximum gradient direction)
- maximum curvature (radius [m] of strongest curvature in any direction)
- minimum curvature (radius [m] of curvature perpendicular to the strongest curvature)

### Indices

A few indices are based on the geometric properties of line of sight within the kernel, and are thus unit less in their definitions.

- ternary (pattern based on line of sight from central pixel in kernel)
- positie [ternary]
- negative [ternary]

### classes

The Framework include 3 generic classification tools that characterise landform using only DEM data. These tools are expanded further down in this post.

- geomorphon (10 basic form elements building a landscape)
- landform (10 superimposed classes of positions)
- land feature (6 generic geometric classes of landforms)

## Manual for DEM neighborhood analysis in Karttur's GeoImagine Framework

This section is divided after the applications applied.

### gdaldem

The use [gdaldem](https://gdal.org/programs/gdaldem.html) is outlined in detail in the posts [GDAL Terrain analysis I](blog-ArcticDemSlopeAspect) and [GDAL Terrain analysis II](blog-ArcticDemTPI). The same processes are also available in other GIS software, like [QGIS]().

### GRASS

[GRASS GIS](https://grass.osgeo.org) includes at least four commands for deriving properties using kernel analysis and DEMs:

- [r.slope.aspect](https://grass.osgeo.org/grass78/manuals/r.slope.aspect.html),
- [r.param.scale](https://grass.osgeo.org/grass78/manuals/r.param.scale.html),
- [r.geomorphon](https://grass.osgeo.org/grass78/manuals/r.geomorphon.html), and
- [r.neighbors](https://grass.osgeo.org/grass79/manuals/r.neighbors.html)

#### r.slope.aspect

[r.slope.aspect](https://grass.osgeo.org/grass78/manuals/r.slope.aspect.html) can apart for slope and aspect also produce profile curvature and tangential curvature, and
first and second partial derivates.

Otherwise are the processing available with [r.slope.aspect](https://grass.osgeo.org/grass78/manuals/r.slope.aspect.html) also covered in [r.param.scale](https://grass.osgeo.org/grass78/manuals/r.param.scale.html) that is more versatile regarding the kernel settings.

#### r.param.scale

With [r.param.scale](https://grass.osgeo.org/grass78/manuals/r.param.scale.html) you can apply any kernel from 3 to 499 cells and thus derive the 9 available metrics representing very different sizes:

- elevation (smoothing)
- slope
- aspect
- profile curvature
- planar curvature
- longitudinal curvature
- maximum curvature
- minimum curvature
- landform features in 6 geometric classes

The curvatures are keys for exploring and mapping landscape hydrological properties. The landform classes are less flexible compared to the TPI landforms that can be generated with customized python coding (see further down) or the landscape element that can be generated with r.geomorphon (also explained later). Selecting the appropriate kernel size, form and cell weights for calculating slopes and curvatures have a very large influence on the results.

#### r.geomorphon

[r.geomorphon](https://grass.osgeo.org/grass78/manuals/r.geomorphon.html) combines statistical estimates within the kerncel (alsa available with the command [r.neighbors](https://grass.osgeo.org/grass79/manuals/r.neighbors.html) and a line of sight analysis that reveals basic geometric forms from a classification of which facets of kernel cells that have a line of sight. The most widely adopted statistical measures for describing DEM neighborhoods are TPI, TRI and roughness (e.g. available via gdaldem above). The automated conversion of the combined indices into 10 generic classes of basin geometric elements is an alternative to other landscape element classifications.

<figure>

<img src="../../images/geomorphon_forms.png" alt="image">

<figcaption>Geomorphon geometric elements.</figcaption>
</figure>

#### r.neighbors

[r.neighbors](https://grass.osgeo.org/grass79/manuals/r.neighbors.html) is a more general moving window analysis package for raster data. As such it is more versatile in the construction of the kernel compared to other filters.


#### GRASS processing

The processing of GRASS commands from the Framework uses the package [grass-session](https://github.com/zarch/grass-session). Any number of GRASS commands can be joined together. The example below imports a DEM tile and then uses [r.param.scale](https://grass.osgeo.org/grass78/manuals/r.param.scale.html) and [r.geomorphon](https://grass.osgeo.org/grass78/manuals/r.geomorphon.html) to produce different DEM derivates that are then exported as GeoTiffs. When finished all files are deleted from the GRASS location and the process continues with the next DEM tile.

<button id= "togglegrassdem" onclick="hiddencode('grassdiv')">Hide/Show GRASS terrain analysis (json)</button>
<div id="grassdiv" style="display:none">
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
      "processid": "GrassOnetoManyTiles",
      "version": "1.3",
      "overwrite": false,
      "dryrun": false,
      "verbose": 1,
      "parameters": {
        "asscript": false,
        "mosaic": true,
        "subparameter": [
          {
            "r.in.gdal": {
              "flags": "e",
              "input": "srcFPN",
              "output": "srcFN"
            }
          },
          {
            "g.region": {
              "flags": "s",
              "raster": "srcFN"
            }
          },
          {
            "r.param.scale": {
              "input": "srcFN",
              "output": "elev3x3",
              "method": "elev",
              "size": 3
            }
          },
          {
            "r.out.gdal": {
              "input": "elev3x3",
              "output": "elev3x3out"
            }
          },
          {
            "g.remove": {
              "flags": "f",
              "type": "raster",
              "name": "elev3x3"
            }
          },
          {
            "r.param.scale": {
              "input": "srcFN",
              "output": "slope3x3",
              "method": "slope",
              "size": 3
            }
          },
          {
            "r.out.gdal": {
              "input": "slope3x3",
              "output": "slope3x3out"
            }
          },
          {
            "g.remove": {
              "flags": "f",
              "type": "raster",
              "name": "slope3x3"
            }
          },
          {
            "r.param.scale": {
              "input": "srcFN",
              "output": "profc3x3",
              "method": "profc",
              "size": 3
            }
          },
          {
            "r.out.gdal": {
              "input": "profc3x3int",
              "fotmat": "int16",
              "output": "profc3x3out"
            }
          },
          {
            "g.remove": {
              "flags": "f",
              "type": "raster",
              "name": "profc3x3"
            }
          },
          {
            "r.param.scale": {
              "input": "srcFN",
              "output": "crosc3x3",
              "method": "crosc",
              "size": 3
            }
          },
          {
            "r.out.gdal": {
              "input": "crosc3x3",
              "output": "crosc3x3out"
            }
          },
          {
            "g.remove": {
              "flags": "f",
              "type": "raster",
              "name": "crosc3x3"
            }
          },
          {
            "r.param.scale": {
              "input": "srcFN",
              "output": "planc3x3",
              "method": "planc",
              "size": 3
            }
          },
          {
            "r.out.gdal": {
              "input": "planc3x3",
              "output": "planc3x3out"
            }
          },
          {
            "g.remove": {
              "flags": "f",
              "type": "raster",
              "name": "planc3x3"
            }
          },
          {
            "r.param.scale": {
              "input": "srcFN",
              "output": "longc3x3",
              "method": "longc",
              "size": 3
            }
          },
          {
            "r.out.gdal": {
              "input": "longc3x3",
              "output": "longc3x3out"
            }
          },
          {
            "g.remove": {
              "flags": "f",
              "type": "raster",
              "name": "longc3x3"
            }
          },
          {
            "r.param.scale": {
              "input": "srcFN",
              "output": "lf3x3",
              "method": "feature",
              "size": 3
            }
          },
          {
            "r.out.gdal": {
              "input": "lf3x3",
              "output": "lf3x3out"
            }
          },
          {
            "g.remove": {
              "flags": "f",
              "type": "raster",
              "name": "lf3x3"
            }
          },
          {
            "r.geomorphon": {
              "elevation": "srcFN",
              "search": 3,
              "skip": 0,
              "flat": 1,
              "dist": 0,
              "forms": "geomorph3x3"
            }
          },
          {
            "r.out.gdal": {
              "input": "geomorph3x3",
              "output": "geomorph3x3out"
            }
          },
          {
            "g.remove": {
              "flags": "f",
              "type": "raster",
              "name": "geomorph3x3"
            }
          },
          {
            "g.remove": {
              "flags": "f",
              "type": "raster",
              "name": "srcFN"
            }
          }
        ]
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
          "*": {
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
          "elev3x3out": {
            "source": "copy",
            "product": "copy",
            "content": "copy",
            "layerid": "copy",
            "prefix": "copy",
            "suffix": "v01-90m-grass-3x3"
          }
        },
        {
          "slope3x3out": {
            "source": "copy",
            "product": "copy",
            "content": "copy",
            "layerid": "copslope",
            "prefix": "slope",
            "suffix": "v01-90m-grass-3x3"
          }
        },
        {
          "profc3x3out": {
            "source": "copy",
            "product": "copy",
            "content": "copy",
            "layerid": "copprofc",
            "prefix": "profc",
            "suffix": "v01-90m-grass-3x3"
          }
        },
        {
          "crosc3x3out": {
            "source": "copy",
            "product": "copy",
            "content": "copy",
            "layerid": "copcrosc",
            "prefix": "crosc",
            "suffix": "v01-90m-grass-3x3"
          }
        },
        {
          "longc3x3out": {
            "source": "copy",
            "product": "copy",
            "content": "copy",
            "layerid": "coplongc",
            "prefix": "longc",
            "suffix": "v01-90m-grass-3x3"
          }
        },
        {
          "planc3x3out": {
            "source": "copy",
            "product": "copy",
            "content": "copy",
            "layerid": "copplanc",
            "prefix": "planc",
            "suffix": "v01-90m-grass-3x3"
          }
        },
        {
          "lf3x3out": {
            "source": "copy",
            "product": "copy",
            "content": "copy",
            "layerid": "coplandform-ps",
            "prefix": "landform-ps",
            "suffix": "v01-90m-grass-3x3"
          }
        },
        {
          "geomorph3x3out": {
            "source": "copy",
            "product": "copy",
            "content": "copy",
            "layerid": "copgeomorph",
            "prefix": "geomorph",
            "suffix": "v01-90m-grass-3x3"
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

### Karttur

The Framework contains one specialized process that resembles the GRASS command [r.neighbors](https://grass.osgeo.org/grass79/manuals/r.neighbors.html) but with focus on retrieving dual scale TPI values for construction of landform classes. This special landform classification routine is built for [Topographic Position and Landforms Analysis](http://www.jennessent.com/downloads/TPI-poster-TNC_18x22.pdf) as described by A. Weiss (2001). The analysis compares TPI as two scales and determines landform in 10 classes. The solution implemented in the Framework allows the two scales to be represented at the same spatial resolution without distortions caused by pixel aggregation. The landform classification can also be done directly from a DEM without any intermediate TPI layers.


<button id= "togglenumpytpi" onclick="hiddencode('numpytpidiv')">Hide/Show TPI landform classification (json)</button>
<div id="numpytpidiv" style="display:none">
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
      "processid": "NumpyDemTiles",
      "version": "1.3",
      "overwrite": false,
      "parameters": {
        "mode": "landformTPI",
        "mosaic": true,
        "radiuscsv": "1,3"
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
    }
  ]
}
```

{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html  toggle-text=text-capture  %}
</div>
