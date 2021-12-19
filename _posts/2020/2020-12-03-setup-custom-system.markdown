---
layout: article
title: "Karttur's GeoImagine Framework:<br />Setup processes (setup_processes)<br />Part 2 Projection and tiling systems"
categories: setup
excerpt: "Setup custom projection system and tiling"
previousurl: setup/setup-setup-processes
nexturl: setup/setup-db-processes
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2020-12-03 T18:17:25.000Z'
modified: '2021-10-15 T14:17:25.000Z'
comments: true
share: true
---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>

## Introduction

In the Framework a _system_ refers to a projection with predefined tiles that can be used for processing spatiotemporal datasets. This post first introduces the concept of a _system_ and outlines the default systems, and then explains how to create a custom _system_.

## Prerequisites

To run the tiling processes and produce the illustration in Fig. 1 you must have installed Karttur's GeoImagine Framework.

## Framework projection and tiling systems

Under the hood, almost all geospatial processing in Karttur's GeoImagine Framework relates to a projection system and operates on tiles - regular grids of raster data. There is also a default _system_ called _system_, for handling non-spatial data and arbitrary (usually Geographic) dataset.

To work with the Framework the _user_ must have a pre-defined region (called _tract_) defined in a _project_ and with the processing associated with a _system_. These parameters must be defined in the header of each json command file (see the post on [Json elements, variables and objects](../concept/concept-json-structure) for details):

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
    "system": "modis"
  },
  ...
```

The _tract_ can for instance be a continent, a country or a district within a country. To create a _tract_ the user must associate it with a predefined default region. The predefined default regions are added when you setup the Framework, and include for instance all the world's countries. When the Framework is set up, each default region is linked to the predefined tiles of the different projection _systems_ used in the Framework. Thus for instance does the predefined region of the country Spain (_es_) link to 5 MODIS SIN grid tiles (Figure 1). Including the marine territory of Spain, additional two (2) tiles are linked. Spain is a country that spans two continents - Africa and Europe. The Framework contains separate default regions for the African and European parts of Spain, including both for the terrestrial and terrestrial+marine territories, also illustrated in figure 1.

<figure class="half">

  <img src="../../images/es_modis-tiling.png" alt="image">

  <img src="../../images/es-m_modis-tiling.png" alt="image">

  <img src="../../images/es-eu_modis-tiling.png" alt="image">

  <img src="../../images/es-af-m_modis-tiling.png" alt="image">

	<figcaption>MODIS SIN grid tiling system for the default region Spain; upper left: global terrestrial territories, upper right: global terrestrial + marine territories, lower left: European terrestrial territories, lower rigth: African terrestrial + marine territories. </figcaption>
</figure>

## Projection tiling system

Karttur's GeoImagine Framework includes 2 default projection tiling systems: MODIS SIN GRID and MGRS UTM. In addition the Framework is also prepared for the three [Equal-Area Scalable Earth (EASE) grid 2.0 systems](https://nsidc.org/data/ease): EASE-grid 2 North (ease2n), EASE-grid 2 South (ease2s) and EASE-grid 2 tropical (ease2t).

The MODIS, MGRS and EASE-grid 2 systems have different objectives. MODIS SIN grid projection system is for moderate to coarse resolution (100 m and coarser) global data, and the only consistent global projection. The three EASE-grid 2 projection systems together cover the globe, and are preferred over MODIS SIN Grid if the data is not truly global. Also the EASE-grid 2 systems are intended for coarse resolution data. MGRS is the system for fine scaled data, and has a much finer tiling system. MGRS can not be generated as a custom system, it is instead installed as a predefined system.

In addition to the above projection tiling systems, also the Landsat Worldwide Reference System (WRS) is included as a system, but rather as a scene location system, used only for retrieving and pre-processing Landsat satellite imagery.

### EASE-grid 2 projection systems

[db_setup](../setup-setup-db/) includes definitions of tables directly related to EASE-grid 2 data, including data products acquired from the Soil Moisture Active Passive (SMAP) mission. [db_setup](../setup-setup-db/) also includes the complex setup of EASE-grid 2 tropical (with tiles of varying sizes to completely cover the Earth with no gaps or overlaps). The tiling systems for ease2n and ease2s, however, must be setup as custom projection systems. They will thus also serve as templates for setting up any other projection system in this manual. Compared to other custom systems you can not freely select the naming for the EASE-grid system, you **must** call them ease2n and ease2s.

### Setup of tiling systems

Each tiling system is setup as a schema in the Framework postgres database. The core tables for defining the system as such (not its spatial data content) include the tables _tilecoords_ (e.g. _modis.tilecoords_) and _regions_ (e.g. _modis.regions_).

The table _tilecoords_ defines all the tiles belonging to the projection system. In the projection system itself, the tiles are defined from 4 coordinates (_minx_, _miny_, _maxx_ and _maxy_). Converted to geographic coordinates (longitude, latitude) the corners must be defined using separate longitude and latitude pairs.

#### MODIS

The MODIS tiling system contains 36 horizontal tile (originally called _htile_, but in the Framework changed to _xtile_) columns and 18 vertical tile (orignally _vtile_, but changed to _ytile_) rows. A large portion of these tiles, however, fall outside the Earthly domain. Including these dropouts can cause redundancy. The setup of the MODIS predefined tiling system is thus accomplished with a hardcoded script that is part of the <span class='package'>setup_processes</span> package.

The tile coordinates of the MODIS system are added to the database either by running the <span class='module'>setup_processes.setup_processes_main.py</span> with the alternative _MODIS_ set to _True_ (see the post [Setup processes Part 2 Setup regions](../setup-setup-processes-regions/)), or by using postgres [database backup and restore](../setup/setup-db-processes/).

For many applications with MODIS data, only tiles covering land (or continents excluding small islands) are of interest. To facilitate the use of the MODIS tiling system, the following default regions are added to the postgres database table _modis.regions_ as part of [<span class='module'>db_setup</span>](#) (in the json parameter file <span class='file'>modis_tile_regions_v090_sql.json</span>):

- global
- land
- continent

These regions are required for adding further MODIS regions using the process <span class='process'>LinkDefaultRegionTiles</span>. The json parameter file <span class='file'>regions-modtiles_v090.json</span> loops over the default regions (including all versions of Spain above) and links the regions to the MODIS tiling. You can also add all the links between default regions and the MODIS tiles using the Framework process <span class='process'>InsertTableCsv</span>. If you set the parameters:

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

Each projection _system_ requires that the Framework postgres database have a schema with the same name (= _systemid_) as the system itself. The schema must then contains the following tables:

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

#### EASE-grid 2 north

As an example, the json command file for creating the EASE-grid 2 North (ease2n) custom _system_ projection is available under the <span class='button'>Hide/Show</span> button.

<button id= "toggleease2def" onclick="hiddencode('ease2def')">Hide/Show ease2_system-define_v090.json</button>

<div id="ease2def" style="display:none">

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

To create a projection and tiling system also for EASE-grid 2.0 South, you only need to replace _systemid_ to _ease2s_ and _epsg_ to _6932_. Remember, EASE-grid 2.0 Tropical is preinstalled as the complex tiles require special solutions. Do **not** install _ease2t_ using the Framework process <span class='module'>DefineCustomSystem</span>

#### SetupCustomGrids for EASE-grid 2

The json commands for setting up both EASE-grid North are prepared via the text file <span class='file'>process_karttur_setup-ease-grid_YYYYMMDD.txt</span>. Because the process includes several hudred reprojections it takes a bit longer to finish. You run it by just removing the comment sign for the call _SetupCustomGrids(prodDB)_:

```
    # To setup custom projection and tiling systems, remove the comment
    #SetupCustomGrids(prodDB)
```

The function _SetupCustomGrids_ links to <span class='file'>process_karttur_setup-ease-grid_YYYYMMDD.txt</span>. Inspect its content by toggling the <span class='button'>Hide/Show</span> button and click on the json file names.

<button id= "toggleprocesschain" onclick="hiddencode('processchain')">Hide/Show process_karttur_setup-ease-grid_YYYYMMDD.txt</button>

<div id="processchain" style="display:none">

{% capture text-capture %}
{% raw %}

\# Define the EASE-grid 2 tile/project systems
[ease2_system-define_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-ease2_system-define/)

{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html toggle-text=text-capture  %}
</div>

If you want to setup your version of the Framework with support for EASE-grid 2.0, just remove the comment sing and rerun the module <span class='module'>setup_process_main.py</span>.

#### Custom projection tiling systems

Using the EASE-grid 2 projection tiling above as template, you can create any tiling system, as long as its projection has a proper [epsg](https://epsg.io) definition.

## Next step

The next step is [Database backup and restore](../setup-db-processes).
