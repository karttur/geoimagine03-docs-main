---
layout: article
title: "Karttur's GeoImagine Framework:<br />System setup & tiling"
categories: setup
excerpt: "The regional tilling system of Karttur's GeoImagine Framework"
previousurl: setup/setup-db
nexturl: setup/setup-regions
tags:
 - addsubproc
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2020-12-25 T18:17:25.000Z'
modified: '2021-11-26 T18:17:25.000Z'
comments: true
share: true
---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>

In the Framework a _system_ refers to a projection with predefined tiles that can be used for processing spatiotemporal datasets. This post first introduces the concept of a _system_ and outlines the default system, and then explains how to create a custom _system_.

## Introduction

Under the hood, almost all geospatial processing in Karttur's GeoImagine Framework operates on tiles - regular grids of raster data. To work with the Framework the user must have a pre-defined region (called _tract_) defined in a _project_. The _tract_ can for instance be a continent, a country or a district within a country. To create a _tract_ the user must associate it with a predefined default region. The predefined default regions are added when you setup the Framework, and include for instance all the world's countries. When the Framework is set up, each default region is linked to the predefined tiles of the different projection _systems_ used in the Framework. Thus for instance does the predefined region of the country Spain (es) link to 5 MODIS SIN grid tiles (Figure 1). Including the marine territory of Spain, additional two (2) tiles are linked. Spain is a country that spans two continents - Africa and Europe. The Framework contains separate default regions for the African and European parts of Spain, including both for the terrestrial and terrestrial+marine territories, also illustrated in figure 1.

<figure class="half">

  <img src="../../images/es_modis-tiling.png" alt="image">

  <img src="../../images/es-m_modis-tiling.png" alt="image">

  <img src="../../images/es-eu_modis-tiling.png" alt="image">

  <img src="../../images/es-af-m_modis-tiling.png" alt="image">

	<figcaption>MODIS SIN grid tiling system for the default region Spain; upper left: global terrestrial territories, upper right: global terrestrial + marine territories, lower left: European terrestrial territories, lower rigth: African terrestrial + marine territories. </figcaption>
</figure>

## Prerequisites

To run the tiling processes and produce the illustration in Fig. 1 you must have installed Karttur's GeoImagine Framework.

## Tiling system

Karttur's GeoImagine Framework includes 5 default tiling systems, each associated with a different projection:

- MODIS SIN grid
- EASE 2 north
- EASE 2 south
- EASE 2 tropical
- MGRS

The five different systems have different objectives. MODIS SIN grid is for moderate to coarse resolution (100 m and coarser) global data, and the only consistent global projection. The three EASE 2 systems together cover the globe, and are preferred over MODIS SIN Grid if the data is not truly global. Also the EASE 2 grid data is intended for coarse resolution data. MGRS is the system for fine scaled data, and has a much finer tiling system.

In addition to the above tiling systems, also the Landsat World Resource System (WRS) is included, but rather as a scene location system, used only for retrieving and pre-processing Landsat satellite imagery.

Finally it is possible to define custom systems. These can be arbitrary defined but must have an accepted [EPSG code](https://epsg.io) in order for the Framework to translate (reproject) spatial data into the system.

### Setup of tiling systems

Each tiling system is setup as a schema in the Framework postgres database. The core tables for defining the system as such (not its spatial data content) include the tables _tilecoords_ (e.g. _modis.tilecoords_) and _regions_ (e.g. _modis.regions_).

The table _tilecoords_ defines all the tiles belonging to the projection system. In the projection system itself, the tiles are defined from 4 coordinates (_minx_, _miny_, _maxx_ and _maxy_). Converted to geographic coordinates (longitude, latitude) the corners must be defined using separate longitude and latitude pairs.

All table data is defined when running the <span class"'module'>setup_db.setup_db_main.py</span> as outlined in the post [Set up the database (setup_db)](../setup/setup-setup-db/) or by using postgres backup restore as described in the post [Database backup and restore](../setup/setup-db-processes/).

#### MODIS

The tile coordinates of the MODIS system are added to the database either by running the <span class='module'>setup_processes.setup_processes_main.py</span> with the alternative _MODIS_ set to _True_ (see the post [Setup processes Part 2 Setup regions](../setup/setup-setup-processes-regions/), or by using postgres backup restore as descibed in the post [Database backup and restore](../setup/setup-db-processes/).

The MODIS tiling system contains 36 horizontal tile (_htile_) columns and 18 vertical tile (_vtile_) rows. A large portion of these tiles, however, falls outside the Earthly domain. And for many applications with MODIS data, only tiles covering land (or continents excluding small islands) are of interest. To facilitate the use of the MODIS tiling system, the following default regions are added to the postgres database table _modis.regions_ as part of [<span class='module'>db_setup</span>](#) (in the json parameter file <span class='file'>modis_tile_regions_v090_sql.json</file>):

- global
- land
- continent

These regions are required for adding further MODIS regions using the process <span class='process'>LinkDefaultRegionTiles</span>. The json parameter file <span class='file'>regions-modtiles_v090.json</span> loops over the default regions (including all versions of Spain above) and links the regions ot the MODIS tiling. You can also add all the links between default regions and the MODIS tiles using the Framework process <span class='process'>InsertTableCsv</span>. If you set the parameters:

- \"_schema_\": \"_modis_\"
- \"_table_\": \"_regions_\"

the script will automatically search for the csv backup file

"DISKPATH"/dbdump/geoimagine/modis/regions/csv-geoimagine-modis-regions_YYYY-MM-DD.csv

and _INSERT_ all the records found in that file.

<button id= "togglemodisregion" onclick="hiddencode('modisregion')">Hide/Show modis-inserttable-regions_v090.json</button>

<div id="modisregion" style="display:none">

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
      "processid": "InsertTableCsv",
      "overwrite": true,
      "version": "0.9",
      "verbose": 2,
      "parameters": {
        "schema": "modis",
        "table": "regions"
      },
      "dstpath": {
        "volume": "DISKPATH"
      }
    }
  ]
}
```

{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html  toggle-text=text-capture  %}
</div>

### DefineCustomSystem

With the process <span class='process'>DefineCustomSystem</span> you can define a new projection _system_ including tiles. It will allow you to utilize the full potential of Karttur's GeoImagine Framework for any region. In contrast to most other processes, <span class='process'>DefineCustomSystem</span> is only accessible from the package <span class='package'>setup_processes</span>.

 A custom _system_ is defined using the following parameters:

- systemid [a system identifier]
- epsg [the system epsg code]
- minx [the system minimum x coordinate]
- minx [the system minimum y coordinate]
- maxx [the system maximum x coordinate]
- maxy [the system maximum y coordinate]
- xtiles [nr of columns spanning from minimum to macximum x]
- ytiles [nr of rows spanning from minimum to macximum y]

#### Schemas and tables

Each projection _system_ requires that the Framework postgres database have schema with the same name (= _systemid_) as the system itself. The schema must then contains the following tables:

- tilecoords
- regions
- compdef
- compprod
- layer
- mask

The system table _INSERT_ sql uses a predefined json command file that must be under the path <span class='file'>./systemdoc/system-setup_sql.json</span> directly under the <span class='module'>process_setup</span>:

<button id= "togglesystemsetup" onclick="hiddencode('systemsetup')">Hide/Show system-setup_sql.json</button>

<div id="systemsetup" style="display:none">

{% capture text-capture %}
{% raw %}

```
{
  "process": [
    {
      "processid": "createtable",
      "overwrite": false,
      "delete": false,
      "parameters": {
        "schema": "*",
        "table": "tilecoords",
        "command": [
          "xytile char(6)",
          "xtile smallint",
          "ytile smallint",
          "minx double precision",
          "miny double precision",
          "maxx double precision",
          "maxy double precision",
          "west double precision",
          "south double precision",
          "east double precision",
          "north double precision",
          "ullat double precision",
          "ullon double precision",
          "lrlat double precision",
          "lrlon double precision",
          "urlat double precision",
          "urlon double precision",
          "lllat double precision",
          "lllon double precision",
          "PRIMARY KEY (xytile)"
        ]
      }
    },
    {
      "processid": "createtable",
      "overwrite": false,
      "delete": false,
      "parameters": {
        "schema": "*",
        "table": "regions",
        "command": [
          "regionid varchar(64)",
          "regiontype varchar(8)",
          "xtile smallint",
          "ytile smallint",
          "PRIMARY KEY (regionid,xtile,ytile)"
        ]
      }
    },
    {
      "processid": "createtable",
      "overwrite": false,
      "delete": false,
      "parameters": {
        "schema": "*",
        "table": "compdef",
        "command": [
          "compid TEXT",
          "content varchar(32)",
          "layerid varchar(64)",
          "prefix varchar(32)",
          "scalefac real",
          "offsetadd real",
          "measure char(1) NOT NULL",
          "dataunit varchar(32)",
          "title varchar(255)",
          "label varchar(255)",
          "PRIMARY KEY (compid)"
        ]
      }
    },
    {
      "processid": "createtable",
      "overwrite": false,
      "delete": false,
      "parameters": {
        "schema": "*",
        "table": "compprod",
        "command": [
          "compid TEXT",
          "system varchar(16) NOT NULL",
          "source TEXT",
          "product varchar(32)",
          "suffix varchar(64)",
          "cellnull real",
          "celltype varchar(8)",
          "masked character(1) DEFAULT 'N'",
          "title varchar(255)",
          "label varchar(255)",
          "frequency varchar(20)",
          "PRIMARY KEY (compid,source,product,suffix)"
        ]
      }
    },
    {
      "processid": "createtable",
      "overwrite": false,
      "delete": false,
      "parameters": {
        "schema": "*",
        "table": "layer",
        "command": [
          "layerid bigserial",
          "compid TEXT",
          "source TEXT",
          "product varchar(32)",
          "suffix varchar(64)",
          "acqdatestr varchar(20)",
          "acqdate date",
          "doy smallint",
          "createdate date DEFAULT CURRENT_DATE",
          "xtile smallint",
          "ytile smallint",
          "xytile char(8)",
          "PRIMARY KEY (compid,source,product,suffix,xtile,ytile,acqdatestr)"
        ]
      }
    },
    {
      "processid": "createtable",
      "overwrite": false,
      "delete": false,
      "parameters": {
        "schema": "*",
        "table": "mask",
        "command": [
          "source TEXT",
          "product varchar(32)",
          "cellnull smallint",
          "water smallint",
          "cloudshadow smallint",
          "snow smallint",
          "cloud smallint",
          "clear smallint",
          "mask smallint ARRAY[3]",
          "PRIMARY KEY (source,product)"
        ]
      }
    }
  ]
}
```
{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html  toggle-text=text-capture  %}
</div>

#### EASE GRID 2 north

As an example, the json command file for creating the EASE GRID 2 North (ease2n) custom _system_ projection is available under the <span class='button'>Hide/Show</span> button.

<button id= "togglesimplify100m" onclick="hiddencode('simplify100m')">Hide/Show ancillary-import-kartturROI_2014_@100m_v090.json</button>

<div id="simplify100m" style="display:none">

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
      "processid": "DefineCustomSystem",
      "overwrite": false,
      "version": "0.9",
      "verbose": 3,
      "parameters": {
        "systemid": "ease2n",
        "epsg": 6931,
        "minx": -9000000,
        "miny": -9000000,
        "maxx": 9000000,
        "maxy": 9000000,
        "xtiles": 20,
        "ytiles": 20
      }
    }
  ]
}
```
{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html  toggle-text=text-capture  %}
</div>
