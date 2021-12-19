---
layout: article
title: "Karttur's GeoImagine Framework:<br />Setup processes (setup_processes)<br />Simplify vector lines and polygons"
categories: setup
excerpt: "Simplify vectors during import by changing the tolerance for vertices positional accuracy"
previousurl: setup/setup-db
nexturl: setup/setup-regions
tags:
 - addsubproc
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2020-12-30 T18:17:25.000Z'
modified: '2021-11-24 T18:17:25.000Z'
comments: true
share: true
---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>

## Introduction

The original vector datasets used by Karttur's GeoImagine Framework for default regions, including countries and continents, are of a very high spatial accuracy. The original data was preprocessed by Karttur to remove all errors (slivers), and is available from Karttur's web-site (**not** from the GitHub repo). The vector data over countries, subcontintents, continents and countries divided into continental parts, available at Karttur's GitHub repo are simplified versions of the original. Two simplified versions are included with the Framework GitHub repo, where the layer (shape file) last name component denotes the tolerance applied when creating the files:

 - "spatial-feature"_karttur_global_2014_tol@100m.shp: 100 m tolerance
 - "spatial-feature"_karttur_global_2014_tol@1km.shp: 1 km tolerance

This post outlines how the vector data supplied with the Framework GitHub project was created. The process used for simplifying the vectors can be applied to any other (line or vector) dataset imported to the Framework.

## Prerequisites

You must have completed the [previous post on setup process](../setup-setup-processes/).

## OrganizeAncillary

The process for importing Ancillary vector data to the Framework is <span class='process'>OrganizeAncillary</span>. The vector simplification integrated with the process is controlled by four parameters:

- tolerance (float),
- angletolerance (float),
- quadrangle (boolean), and
- checkfixvalidity (boolean).

The simplification is controlled by the combined setting of the first three parameters while the fourth (_checkfixvalidity_) determines whether to validate and fix the topology or not (default is set to _true_ and thus perform the validity check and fix).

### Skip simplification

To skip the simplification set _tolerance_ and _angletolerance_ to _0_ and _quadrangle_ to _false_.
The imported vectors will still be validated for topological consistency and corrected, unless also _checkfixvalidity_ is set to _false_.

### Quadrangle simplification

_quadrangle_ is a special simplification algorithm developed for 4-cornered polygons that have vertices in addition to the 4 corners. It was specifically developed for correcting the Landsat WRS polygons. To work, you must set _quandrangle_ to _true_ **and** set a value for _tolerance_ > _0_.

The _quadrangle_ algorithm first creates a rectangular boundary. In theory the 4 corners of any quadrangle  intersect with the boundary. If the quadrangle is not a rectangle (but a parallelogram) the four corners will be identified directly. If, however, one or more sides is horistontal or vertical (e.g. at the international date line for Landsat WRS polygons), there might be multiple vertices identified. To distinguish between the corner vertices and other nodes, the _tolerance_ value is used.

If _quadrangle_ is set to _true_ it has precedence over _teolerance_ and _angletolerance_.

### Tolerance simplification

By setting the parameter _tolerance_ > _0_ (with _quadrangle_ set to _false_), the process utilises the ordinary (topology preserving) [<span class='package'>shapely</span> simplify algorithm](https://shapely.readthedocs.io/en/stable/manual.html). The much quicker Douglas-Peucker algorithm for simplification available with <span class='package'>shapely</span> is not implemented.

### Angletolerance simplification

The _angletolerance_ algorithm is taken from [Toblerity GitHub pages](https://github.com/Toblerity/Shapely/issues/1046). It is intended for simplifying the polygons of regular geometric figures with at least 5 vertices and a surplus of nodes in between.

### Simplifying Country and continent vector data

As stated above, the original country and continent data prepared for the Framework is of very high spatial accuracy. The versions supplied with Karttur's GitHub pages are simplifications, created with the json parameter files under the <span class='button'>Hide/Show</span> buttons below.

<button id= "togglesimplify100m" onclick="hiddencode('simplify100m')">Hide/Show ancillary-import-kartturROI_2014_@100m_v090.json</button>

<div id="simplify100m" style="display:none">

{% capture text-capture %}
{% raw %}

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
    "system": "ancillary"
  },
  "period": {
    "startyear": 2014,
    "endyear": 2014,
    "timestep": "singleyear"
  },
  "process": [
    {
      "processid": "OrganizeAncillary",
      "overwrite": true,
      "parameters": {
        "importcode": "shp",
        "epsg": "4326",
        "orgid": "karttur",
        "dsname": "globalROI",
        "dsversion": "1.0",
        "accessdate": "20170320",
        "regionid": "globe",
        "regioncat": "globe",
        "dataurl": "",
        "metaurl": "",
        "title": "Global default regions",
        "label": "Global default regions based on countries and continents",
        "tolerance": 0.00086,
        "checkfixvalidity": true
      },
      "srcpath": {
        "volume": ".",
        "hdr": "shp"
      },
      "dstpath": {
        "volume": "DEMDATA",
        "hdr": "shp"
      },
      "srcraw": [
        {
          "country": {
            "datadir": "data/political",
            "datafile": "countries_karttur_global_2014",
            "datalayer": "countries",
            "title": "Global countries (with iso-codes)",
            "label": "Cleaned vectors from ShareGeo representing global countries for 2014"
          }
        },
        {
          "country-continent": {
            "datadir": "data/political",
            "datafile": "countries-continents_karttur_global_2014",
            "datalayer": "countries-continents",
            "title": "Global countries (with iso-codes)",
            "label": "Cleaned vectors from ShareGeo representing global countries for 2014"
          }
        },
        {
          "continent-subregions": {
            "datadir": "data/political",
            "datafile": "continent-subregions_karttur_global_2014",
            "datalayer": "continent-subregions",
            "title": "Global countries (with iso-codes)",
            "label": "Cleaned vectors from ShareGeo representing global countries for 2014"
          }
        },
        {
          "continents": {
            "datadir": "data/political",
            "datafile": "continents_karttur_global_2014",
            "datalayer": "continents",
            "title": "Global countries (with iso-codes)",
            "label": "Cleaned vectors from ShareGeo representing global countries for 2014"
          }
        },
        {
          "marine-countries": {
            "datadir": "data/political",
            "datafile": "marine-countries_karttur_2014",
            "datalayer": "marine-countries",
            "title": "Global countries (with iso-codes)",
            "label": "Cleaned vectors from ShareGeo representing global countries for 2014"
          }
        },
        {
          "marine-continent-countries": {
            "datadir": "data/political",
            "datafile": "marine-continent-countries_karttur_2014",
            "datalayer": "marine-continent-countries",
            "title": "Global countries (with iso-codes)",
            "label": "Cleaned vectors from ShareGeo representing global countries for 2014"
          }
        },
        {
          "marine-continent-subregions": {
            "datadir": "data/political",
            "datafile": "marine-continent-subregions_karttur_2014",
            "datalayer": "marine-continent-subregions",
            "title": "Global countries (with iso-codes)",
            "label": "Cleaned vectors from ShareGeo representing global countries for 2014"
          }
        },
        {
          "marine-continents": {
            "datadir": "data/political",
            "datafile": "marine-continents_karttur_2014",
            "datalayer": "marine-continents",
            "title": "Global countries (with iso-codes)",
            "label": "Cleaned vectors from ShareGeo representing global countries for 2014"
          }
        }
      ],
      "dstcomp": [
        {
          "country": {
            "source": "karttur",
            "product": "karttur",
            "content": "defaultregions",
            "layerid": "country",
            "prefix": "country",
            "suffix": "tol@100m",
            "dataunit": "boundary",
            "celltype": "vector",
            "cellnull": "-32768",
            "masked": "Y",
            "measure": "N"
          }
        },
        {
          "country-continent": {
            "masked": "Y",
            "measure": "N",
            "source": "karttur",
            "product": "karttur",
            "content": "defaultregions",
            "layerid": "country-continent",
            "prefix": "country-continent",
            "suffix": "tol@100m",
            "dataunit": "boundary",
            "celltype": "vector",
            "cellnull": "-32768"
          }
        },
        {
          "continent-subregions": {
            "masked": "Y",
            "measure": "N",
            "source": "karttur",
            "product": "karttur",
            "content": "defaultregions",
            "layerid": "continent-subregions",
            "prefix": "continent-subregions",
            "suffix": "tol@100m",
            "dataunit": "boundary",
            "celltype": "vector",
            "cellnull": "-32768"
          }
        },
        {
          "continents": {
            "masked": "Y",
            "measure": "N",
            "source": "karttur",
            "product": "karttur",
            "content": "defaultregions",
            "layerid": "continents",
            "prefix": "continents",
            "suffix": "tol@100m",
            "dataunit": "boundary",
            "celltype": "vector",
            "cellnull": "-32768"
          }
        },
        {
          "marine-countries": {
            "masked": "Y",
            "measure": "N",
            "source": "karttur",
            "product": "karttur",
            "content": "defaultregions",
            "layerid": "marine-countries",
            "prefix": "marine-countries",
            "suffix": "tol@100m",
            "dataunit": "boundary",
            "celltype": "vector",
            "cellnull": "-32768"
          }
        },
        {
          "marine-continent-countries": {
            "masked": "Y",
            "measure": "N",
            "source": "karttur",
            "product": "karttur",
            "content": "defaultregions",
            "layerid": "marine-continent-countries",
            "prefix": "marine-continent-countries",
            "suffix": "tol@100m",
            "dataunit": "boundary",
            "celltype": "vector",
            "cellnull": "-32768"
          }
        },
        {
          "marine-continent-subregions": {
            "masked": "Y",
            "measure": "N",
            "source": "karttur",
            "product": "karttur",
            "content": "defaultregions",
            "layerid": "marine-continent-subregions",
            "prefix": "marine-continent-subregions",
            "suffix": "tol@100m",
            "dataunit": "boundary",
            "celltype": "vector",
            "cellnull": "-32768"
          }
        },
        {
          "marine-continents": {
            "masked": "Y",
            "measure": "N",
            "source": "karttur",
            "product": "karttur",
            "content": "defaultregions",
            "layerid": "marine-continents",
            "prefix": "marine-continents",
            "suffix": "tol@100m",
            "dataunit": "boundary",
            "celltype": "vector",
            "cellnull": "-32768"
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

<button id= "togglesimplify1km" onclick="hiddencode('simplify1km')">Hide/Show ancillary-import-kartturROI_2014_@1km_v090.json</button>

<div id="simplify1km" style="display:none">

{% capture text-capture %}
{% raw %}

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
    "system": "ancillary"
  },
  "period": {
    "startyear": 2014,
    "endyear": 2014,
    "timestep": "singleyear"
  },
  "process": [
    {
      "processid": "OrganizeAncillary",
      "overwrite": true,
      "parameters": {
        "importcode": "shp",
        "epsg": "4326",
        "orgid": "karttur",
        "dsname": "globalROI",
        "dsversion": "1.0",
        "accessdate": "20170320",
        "regionid": "globe",
        "regioncat": "globe",
        "dataurl": "",
        "metaurl": "",
        "title": "Global default regions",
        "label": "Global default regions based on countries and continents",
        "tolerance": 0.0086,
        "checkfixvalidity": true
      },
      "srcpath": {
        "volume": ".",
        "hdr": "shp"
      },
      "dstpath": {
        "volume": "DEMDATA",
        "hdr": "shp"
      },
      "srcraw": [
        {
          "country": {
            "datadir": "data/political",
            "datafile": "countries_karttur_global_2014",
            "datalayer": "countries",
            "title": "Global countries (with iso-codes)",
            "label": "Cleaned vectors from ShareGeo representing global countries for 2014"
          }
        },
        {
          "country-continent": {
            "datadir": "data/political",
            "datafile": "countries-continents_karttur_global_2014",
            "datalayer": "countries-continents",
            "title": "Global countries (with iso-codes)",
            "label": "Cleaned vectors from ShareGeo representing global countries for 2014"
          }
        },
        {
          "continent-subregions": {
            "datadir": "data/political",
            "datafile": "continent-subregions_karttur_global_2014",
            "datalayer": "continent-subregions",
            "title": "Global countries (with iso-codes)",
            "label": "Cleaned vectors from ShareGeo representing global countries for 2014"
          }
        },
        {
          "continents": {
            "datadir": "data/political",
            "datafile": "continents_karttur_global_2014",
            "datalayer": "continents",
            "title": "Global countries (with iso-codes)",
            "label": "Cleaned vectors from ShareGeo representing global countries for 2014"
          }
        },
        {
          "marine-countries": {
            "datadir": "data/political",
            "datafile": "marine-countries_karttur_2014",
            "datalayer": "marine-countries",
            "title": "Global countries (with iso-codes)",
            "label": "Cleaned vectors from ShareGeo representing global countries for 2014"
          }
        },
        {
          "marine-continent-countries": {
            "datadir": "data/political",
            "datafile": "marine-continent-countries_karttur_2014",
            "datalayer": "marine-continent-countries",
            "title": "Global countries (with iso-codes)",
            "label": "Cleaned vectors from ShareGeo representing global countries for 2014"
          }
        },
        {
          "marine-continent-subregions": {
            "datadir": "data/political",
            "datafile": "marine-continent-subregions_karttur_2014",
            "datalayer": "marine-continent-subregions",
            "title": "Global countries (with iso-codes)",
            "label": "Cleaned vectors from ShareGeo representing global countries for 2014"
          }
        },
        {
          "marine-continents": {
            "datadir": "data/political",
            "datafile": "marine-continents_karttur_2014",
            "datalayer": "marine-continents",
            "title": "Global countries (with iso-codes)",
            "label": "Cleaned vectors from ShareGeo representing global countries for 2014"
          }
        },
        {
          "land": {
            "datadir": "data/political",
            "datafile": "land_karttur_global_2014_tol@1km",
            "datalayer": "land",
            "title": "Global land mass at 1 km tolerance",
            "label": "Uncleaned with with overlaps and gaps"
          }
        }
      ],
      "dstcomp": [
        {
          "country": {
            "source": "karttur",
            "product": "karttur",
            "content": "defaultregions",
            "layerid": "country",
            "prefix": "country",
            "suffix": "tol@1km",
            "dataunit": "boundary",
            "celltype": "vector",
            "cellnull": "-32768",
            "masked": "Y",
            "measure": "N"
          }
        },
        {
          "country-continent": {
            "masked": "Y",
            "measure": "N",
            "source": "karttur",
            "product": "karttur",
            "content": "defaultregions",
            "layerid": "country-continent",
            "prefix": "country-continent",
            "suffix": "tol@1km",
            "dataunit": "boundary",
            "celltype": "vector",
            "cellnull": "-32768"
          }
        },
        {
          "continent-subregions": {
            "masked": "Y",
            "measure": "N",
            "source": "karttur",
            "product": "karttur",
            "content": "defaultregions",
            "layerid": "continent-subregions",
            "prefix": "continent-subregions",
            "suffix": "tol@1km",
            "dataunit": "boundary",
            "celltype": "vector",
            "cellnull": "-32768"
          }
        },
        {
          "continents": {
            "masked": "Y",
            "measure": "N",
            "source": "karttur",
            "product": "karttur",
            "content": "defaultregions",
            "layerid": "continents",
            "prefix": "continents",
            "suffix": "tol@1km",
            "dataunit": "boundary",
            "celltype": "vector",
            "cellnull": "-32768"
          }
        },
        {
          "marine-countries": {
            "masked": "Y",
            "measure": "N",
            "source": "karttur",
            "product": "karttur",
            "content": "defaultregions",
            "layerid": "marine-countries",
            "prefix": "marine-countries",
            "suffix": "tol@1km",
            "dataunit": "boundary",
            "celltype": "vector",
            "cellnull": "-32768"
          }
        },
        {
          "marine-continent-countries": {
            "masked": "Y",
            "measure": "N",
            "source": "karttur",
            "product": "karttur",
            "content": "defaultregions",
            "layerid": "marine-continent-countries",
            "prefix": "marine-continent-countries",
            "suffix": "tol@1km",
            "dataunit": "boundary",
            "celltype": "vector",
            "cellnull": "-32768"
          }
        },
        {
          "marine-continent-subregions": {
            "masked": "Y",
            "measure": "N",
            "source": "karttur",
            "product": "karttur",
            "content": "defaultregions",
            "layerid": "marine-continent-subregions",
            "prefix": "marine-continent-subregions",
            "suffix": "tol@1km",
            "dataunit": "boundary",
            "celltype": "vector",
            "cellnull": "-32768"
          }
        },
        {
          "marine-continents": {
            "masked": "Y",
            "measure": "N",
            "source": "karttur",
            "product": "karttur",
            "content": "defaultregions",
            "layerid": "marine-continents",
            "prefix": "marine-continents",
            "suffix": "tol@1km",
            "dataunit": "boundary",
            "celltype": "vector",
            "cellnull": "-32768"
          }
        },
        {
          "land": {
            "masked": "Y",
            "measure": "N",
            "source": "karttur",
            "product": "karttur",
            "content": "defaultregions",
            "layerid": "land",
            "prefix": "land",
            "suffix": "tol@1km",
            "dataunit": "boundary",
            "celltype": "vector",
            "cellnull": "-32768"
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
