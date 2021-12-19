---
layout: post
title: Mosaics for avoiding edge effects
categories: blog
datasource: dem
biophysical: geomorphology
excerpt: "Virtual mosaics for avoiding edge effects from neighbourhood analysis in raster data"
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2021-07-02 T18:17:25.000Z'
modified: '2021-07-02 T18:17:25.000Z'
comments: true
share: true

---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>

# Introduction

When analysing raster data for conditions that relate to a neighbourhood, edge effects are inevitable. To avoid that, Karttur's GeoImagine Framework can generated virtual mosaics that enlarge every tile by using all 8 neighbours. Any neighbourhood analysis can then be done using the enlarged, virtual mosaic, while limiting the output to the core tile region. The result will be a set of seamless tiles without any edge effects.

# MosaicAdjacentTiles

The process for generating enlarged virtual tiles is _MosaicAdjacentTiles_. The process operates on regions defined for any projection system (e.g. MODIS SIN or EASE-grids).

## json

All required parameters have default values. The virtual tile will always be saved as a virtual GDAL dataset, with the ending _-full.vrt_ added to the basename of the original tile. The default expansing is 101 cells in all directions.

<button id= "toggleMosaicAdjacentTiles" onclick="hiddencode('MosaicAdjacentTiles')">Hide/Show importclimateindex.json</button>
<div id="MosaicAdjacentTiles" style="display:none">
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
      "processid": "MosaicAdjacentTiles",
      "version": "1.3",
      "overwrite": false,
      "parameters": {
        "asscript": true,
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
            "srccomp": "dem_arcticdem"
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

## Applying the enlarged virtual mosaics

When running processes that rely on neighborhood analysis you apply the enlarged tiles by setting the parameter _mosaic_ to _true_.
