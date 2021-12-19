---
layout: article
title: "Karttur's GeoImagine Framework:<br />Link regions & system tiles"
categories: setup
excerpt: "Linking default regions to regional tiling systems of Karttur's GeoImagine Framework"
previousurl: setup/setup-db
nexturl: setup/setup-regions
tags:
 - addsubproc
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2020-12-27 T18:17:25.000Z'
modified: '2021-11-26 T18:17:25.000Z'
comments: true
share: true
---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>

In karttur's GeoImagine Framework a _system_ refers to a projection with predefined tiles that can be used for processing spatiotemporal datasets. All spatial processing is related to a default region, but the actual processing is not done at the region as such, but based on [predefined tiles of the _system_](../setup-region-tiling/). This post describes the Framework process for linking a _system_ projection to default regions.

## Introduction

Every time you run a process in Karttur's GeoImagine Framework you must state the _projectid_ , _tractid_ and _system_ as part of the \"userproject\" defined in the json command structure:

```
{
  "postgresdb": {
    "db": "geoimagine"
  },
  "userproject": {
    "userid": "karttur",
    "projectid": "karttur",
    "tractid": "karttur",
    "siteid": "*",
    "plotid": "*",
    "system": "ease2n"
  },
```

The _tractid_ is always linked to a default region, otherwise you can not define it. The default region is in turn linked to the predefined tiles of the _system_ on which you operate. This is true even if you operate on a custom _system_ that you defined yourself. In order for that to function you **must** link the default regions to the _system_ that you work with, the topic of this post.

## Prerequisites

To identify the linkages between your _system_ tiles and the default regions, you must have [defined the _system_](../setup-region-tiling/) and [imported the default regions](../setup-setup-processes-regions/).

## LinkDefaultRegionTiles

The process that links default regions to _system_ tiles is <span class='process'>LinkDefaultRegionTiles</span>. The _system_ to apply the process to is defined as part of the json object \"userproject\" (see **Introduction**), that also defines the projection to use (can not be changed). The parameters to set include:

- defregmask (default region for restricting tile search),
- regioncat (the region category to link),
- ogr2ogr (whether to use ogr2ogr or python scripting for the process [boolean]),
- cmdpath (command line path to ogr2ogr if required),
- clipsrc (empty [default] or csv for src minx, miny, maxx, maxy),
- clipdst (clip reporojected vector to system boundaries [boolean]),
- wrapdateline (only for geographic projection [boolean]),
- onlyregionsfullywithinsystem (only process regions that fall completely inside system boundaries [boolean]), and
- checkfixvalidity (whether to check vector vaildity [boolean]),
- onlytiling (skip the reprojection and only creates vectors of the overlapping tiles [boolean]).            

### defregmask

The parameter _defregmask_ (default region mask) limits the tiling to an already existing tile region - for instance _land_ (the parameter default value) if the new tile region should only contain tiles that include a terrestrial area.

### regioncat

The _regionacat_ (region category) shoud be set to a default region category that fits your _system_ (e.g. _country_). You have to repeat the <span class='process'>LinkDefaultRegionTiles</span> process for each type of region category you want to link up the selected system.

### ogr2ogr

If set to _true_, the parameter _ogr2ogr_ directs the processing towards the [utility program ogr2ogr](https://gdal.org/programs/ogr2ogr.html). Otherwise the process will use python scripting.

#### ogr2ogr: clipsrc

In the current (December 2021) of the Framework, the parameter _clipsrc_ is only relevant if _ogr2ogr_ is _true_. Then the source (i.e. Geographic) datasource will be clipped prior to reprojection to the system projection. This is recommended for global projection, inlcuding MODIS and the thres EASE-grid project and tiling systems. The parameters _clipsrc_ must be gien as a comma separeted string with "min longitude, min latitude, max longitude, max latitude". _clipsrc_ has precedense over _clipdst_.

#### ogr2ogr: clipdst

In the current (December 2021) of the Framework, the parameter _clipdst_ is only relevant if _ogr2ogr_ is _true_. _clipdst_ is a bollean (_true_/_false_) parameter. If set to _true_ the reproejction will be clipped to the boundary extent of the system projection itself.

#### ogr2ogr: wrapdateline

In the current (December 2021) of the Framework, the parameter _wrapdateline_ is only relevant if _ogr2ogr_ is _true_. And it comes into action only if the destination projection is Geographic coordinates. It is a boolean (_true_/_false_) parameter.

### onlyregionsfullywithinsystem

_onlyregionsfullywithinsystem_ is a boolean parameter. If set to _true_ only those regions that are fully inside the _system_ boundaries are added to the database. Regions that are partially outside are omitted. Regions that are fully outside of the _system_ boundaries are always skipped.

###  onlytiling

_oonlytiling_ is another boolean parameter. If set to _true_ the process skips the reprojection step and only analysis the overlaps and produce vector representations of the overlapping tile.

### Continent region tiles for the ease2n system

As an example, the json parameterization for linking default country regions to the [ease2n system](#) are under the <span class='button'>Hide/Show</span> button. The _clipsrc_ parameter is set to the northern hemsiphere and _onlyregionsfullywithinsystem_ is set to _true_. This will include all parts of the world's continents north of the equator (see figure below).

<button id= "toggletiling" onclick="hiddencode('tiling')">Hide/Show regions-ease2ntiles_v090.json</button>

<div id="tiling" style="display:none">

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
    "startyear": 2014,
    "endyear": 2014,
    "timestep": "singleyear"
  },
  "process": [
    {
      "processid": "LinkDefaultRegionTiles",
      "overwrite": false,
      "version": "0.9",
      "verbose": 2,
      "parameters": {
        "defregmask": "global",
        "regioncat": "continent",
        "cmdpath": "/usr/local/bin",
        "ogr2ogr": true,
        "clipsrc": "-180,0,180,90",
        "clipdst": false,
        "checkfixvalidity": true,
        "onlyregionsfullywithinsystem": false
      },
      "srcpath": {
        "volume": "DEMDATA",
        "hdr": "shp",
        "dat": "shp"
      },
      "dstpath": {
        "volume": "DEMDATA"
      },
      "srccomp": [
        {
          "regions": {
            "source": "karttur",
            "product": "karttur",
            "content": "roi",
            "layerid": "defreg",
            "prefix": "defreg",
            "suffix": "tol@1km"
          }
        }
      ],
      "dstcomp": [
        {
          "region": {
            "source": "karttur",
            "product": "karttur",
            "content": "roi",
            "layerid": "defreg",
            "prefix": "defreg",
            "suffix": "tol@1km"
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

<figure>
<img src="../../images/ease2n_system_continent_regions.png" alt="image">
<figcaption>Continental regions and tiles in the EASS-grid 2.0 North tiling and projection system.</figcaption>
</figure>

#### EASE-grid 2 prepared setup

The post [EASE-grid tile & projection system](../setup-setup-ease-grid-2) contains the complete installation of the EASE-grid 2 tiling and projection systems.
