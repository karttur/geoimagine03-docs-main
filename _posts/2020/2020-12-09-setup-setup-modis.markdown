---
layout: article
title: "Karttur's GeoImagine Framework:<br />Setup processes (setup_processes)<br />Part 5 MODIS tile regions and data access"
categories: setup
excerpt: "Setup MODIS regions and access to MODIS LPDAAC products for Karttur's GeoImagine Framework"
previousurl: setup/setup-setup-processes-regions
nexturl: setup/setup-setup-ease-grid-2
tags:
 - addsubproc
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2020-12-09 T18:17:25.000Z'
modified: '2021-10-18 T18:17:25.000Z'
comments: true
share: true
---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>

## Introduction

The MODIS SIN grid projection and tiling system is the default system for processing truly global datasets. The tiling for MODIS used in Karttur's GeoImagine Framework is identical to the original [MODIS SIN grid tiling](https://modis-land.gsfc.nasa.gov/MODLAND_grid.html). This post outlines how to link [default regions](../setup-setup-processes-regions) to the MODIS SIN grid projection and tiling system. It also covers the installation of processes for accessing online MODIS products.

#### MODIS

The setup of the specific MODIS resources is included in the package <span class='package'>setup_processes</span>. Run the setup of MODIS related regions by setting the variable _MODIS_ to _True_ in <span class='module'>setup_process_main</span> under the defined functions _SetupDefaultRegions_

```
def SetupDefaultRegions(prodDB):
  ...
    DefaultRegions = False

    MODIS = True
  ...
```
When you run the module, the MODIS linked scripts will be executed.

```
    if MODIS:

        '''Stand alone script that defines the MODIS tile coordinates'''
        ModisTileCoords(prodDB)

        projFN = 'modis_karttur_setup_20211108.txt'

        SetupProcessesRegions('modisdoc', projFN, prodDB)
```

The module will first create a default tiling system (function: _ModisTileCoords_ ) for MODIS data that fits the MODIS Sinusoidal (SIN) grid data available from the Land Processes Distributed Active Archive Center (LP DAAC). The tiling system is saved in the database table _modis.tileccords_.

The file <span class='file'>modis\_karttur\_setup\_YYYYMMDD.txt</span> links to a set of json command files that setup the MODIS processing environment in the Framework. Inspect its content by toggling the <span class='button'>Hide/Show</span> button and click on the linked json file name.

You can not run the Land Processes Distruted Active Archive Center (LPDAAC) until you have become an accepted user and added your crednetials to the hidden <span class='file'>.netrc</span> file. The default command structure thus excludes the LPDAAAC associated processes. Also the database restore commands are commented out, while the database backup of the modis db schema is included.

<button id= "toggleMODIS" onclick="hiddencode('MODIS')">Hide/Show modis\_karttur\_setup\_YYYYMMDD.txt</button>

<div id="MODIS" style="display:none">

{% capture text-capture %}
{% raw %}

Link global default regions to MODIS SIN grid tiles
[regions-global-modtiles_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_modis/setup_processes/setup_processes-json-regions-global-modtiles/)

Link country and continent default regions to MODIS SIN grid tiles
[regions-modtiles_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_modis/setup_processes/setup_processes-json-regions-modtiles/)

Search LPDAAC datapool for MODIS tiles
\#\#\# REMOVE To RUN \#\#\# [modis-search_datapool_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_modis/setup_processes/setup_processes-json-modis-search_datapool/)

Add html search results to the db
\#\#\# REMOVE To RUN \#\#\# [modis-datapool-search_todb_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_modis/setup_processes/setup_processes-json-modis-datapool-search_todb/)

dump (sql) and export (csv) the content of the db tables for MODIS tilecoords and regions
[modis-dumptablesql_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_modis/setup_processes/setup_processes-json-modis-dumptablesql/)

dump (sql) and export (csv) the content of the db schema for MODIS
[modis-dumpschemasql_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_modis/setup_processes/setup_processes-json-modis-dumpschemasql/)

Insert the MODIS db table data for tilecoords and regions from exported csv
\#\#\# REMOVE To RUN \#\#\# [modis-inserttable-tilecoords+regions_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_modis/setup_processes/setup_processes-json-modis-inserttable-tilecoords+regions/)

Insert the MODIS db schema data from exported csv
\#\#\# REMOVE To RUN \#\#\# [modis-insertschema_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_modis/setup_processes/setup_processes-json-modis-insertschema/)

Restore the data for the db table for modis.tilecoords from dumped sql
\#\#\# REMOVE To RUN \#\#\# [modis-RestoreTableSQL_v090.json](https://###karttur.github.io/geoimagine03-docs-setup_processes_modis/setup_processes/setup_processes-json-modis-RestoreTableSQL/)

{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html toggle-text=text-capture  %}
</div>

Figure 1 illustrates the linking of continents to the MODIS system tiling and projection system, in the MOD SIN grid projection.

<figure>
<img src="../../images/modis_system_continent_regions.png" alt="image">
<figcaption>Continental regions and tiles in the MODIS SIN grid tiling and projection system.</figcaption>
</figure>

## Next step

The next step is adding [EASE-grid 2 tile regions and data access](../setup-setup-ease-grid-2).
