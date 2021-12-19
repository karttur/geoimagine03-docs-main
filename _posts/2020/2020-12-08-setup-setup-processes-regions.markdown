---
layout: article
title: "Karttur's GeoImagine Framework:<br />Setup processes (setup_processes)<br />Part 4 Default regions"
categories: setup
excerpt: "Setup the default country and continent regions for Karttur's GeoImagine Framework"
previousurl: setup/setup-db-processes
nexturl: setup/setup-setup-modis
tags:
 - addsubproc
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2020-12-08 T18:17:25.000Z'
modified: '2021-10-18 T18:17:25.000Z'
comments: true
share: true
---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>

## Introduction

Karttur's GeoImagine Framework uses default regions to process spatial data. The standard default region is a country, but can also be several countries in a continent or an entire continent. It can also be smaller regions than a country. The Framework database contains the definition of a hierarchical set of regional categories, but no actual geographical regions smaller than a country are included in the default Framework. The default set of countries, sub-continents and continents are available at the Framework GitHub repo. This manual details how the country data was prepared and how to import the data to the Framework, extract the individual countries, continents etc. Note that if you setup the Framework by [restoring the database](../setup-db-processes) you anyway need to run the commands in this tutorial to retrieve the default regions as actual vector maps.

## Prerequisites

You must have completed the [post on setup process](../setup-setup-processes/).

## Systems and regions

In the Framework a _system_ refers to a projection with predefined tiles that can be used for processing spatiotemporal datasets. Even if the processing is using tiles, the regions given by the user are always geographical, like a country or a river basin. In the database, the tiles forming the regions are listed, and the processing takes place using the tiles. Most static datasets are regarded as _ancillary_ datasets and belong to the system _ancillary_. All default regions, used for defining geographic process regions, instead belong to the core system, called _system_. But existing data can not be directly imported as _system_ layers and must be imported as _ancillary_ and subsequently defined as default regions, and then also end up as _system_ datasets.

### Setup default regions

To start setup of default regions you must have completed the [setup of processes](../setup-setup-processes), or [restored the default database](../setup-db-processes).

In your Python environment (e.g. <span class='app'>Eclipse</span>), open the module <span class='module'>setup_process_main</span>. To avoid reinstalling the processes every time you run the python script, comment out _SetupProcesses_ (under the \_\_main\_\_ section):

```
    #SetupProcesses(prodDB)
```

and remove the comment sign ("#") for _SetupDefaultRegions_:

```
    # SetupDefaultRegions starts a subroutine with different region processing
    SetupDefaultRegions(prodDB)
```

In the subroutine _SetupDefaultRegions_ there is a list of boolean setup options:

```
    DefaultRegions = False

    MODIS = False

    ...
```

Change _DefaultRegions_ to _True_ and running the module will look for a file (<span class='file'>regions\_karttur\_setup\_YYYYMMDD.txt</span>) linking to definitions of default regions and create a set of both general and special regions.

```
    if DefaultRegions:

        projFN = 'regions_karttur_setup_20211108.txt'

        SetupProcessesRegions('regiondoc', projFN, prodDB)
```

The json commands for setup of default schemas and tables are linked via the text file <span class='file'>db_karttur_setup_YYYYMMDD.txt</span>. It is under the directory [regiondoc](https://github.com/karttur/geoimagine03-setup_processes/tree/main/regiondoc) in the [GeoImagine Framework GitHub repo for setup_processes](https://github.com/karttur/geoimagine03-setup_processes). The json files are also available as [web (html) documents](https://karttur.github.io/geoimagine03-docs-setup_processes_defaultregions/), and linked under  <span class='button'>Hide/Show</span> button.

<button id= "togglesetuptxt" onclick="hiddencode('setuptxt')">Hide/Show db_karttur_setup_YYYYMMDD.txt</button>

<div id="setuptxt" style="display:none">

{% capture text-capture %}
{% raw %}

\# Add region categories to the db
[add_region_categories_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_defaultregions/setup_processes/setup_processes-json-add_region_categories/)

\# Add global default regions to the db
[add_arbitrary_default_regions_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_defaultregions/setup_processes/setup_processes-json-add_arbitrary_default_regions/)

\# Import global countries and continents as ancillary data
[ancillary-import-kartturROI_2014_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_defaultregions/setup_processes/setup_processes-json-ancillary-import-kartturROI_2014/)

\# Add countries, subcontinents and continents to the db
[add_default_regions_from-vector_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_defaultregions/setup_processes/setup_processes-json-add_default_regions_from-vector/)

\# Add global arctic regions to the db
[add_arctic_default_regions_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_defaultregions/setup_processes/setup_processes-json-add_arctic_default_regions/)

\# Add global arctic regions in EASE-grid 6931 to the db
[add_arctic_ease2n_regions_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_defaultregions/setup_processes/setup_processes-json-add_arctic_ease2n_regions/)

\#  Add Arctic hydrological basin regions for ease2n
[add_ease2n_hydro_regions_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_defaultregions/setup_processes/setup_processes-json-add_ease2n_hydro_regions/)

\# Adds African Sub-sahara region to the db
[add_Africa-Sub_Sahara_default-region_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_defaultregions/setup_processes/setup_processes-json-add_Africa-Sub_Sahara_default-region/)

{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html  toggle-text=text-capture  %}
</div>

You can skip individual json command files by setting a comment sign ('#') in front of the link to the json file.

If you want to create your own default regions for longitude-latitude coordinates, use the command file [add_arbitrary_default_regions_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_defaultregions/setup_processes/setup_processes-json-add_arbitrary_default_regions/) as template. If you want to create a default region bounded by a continent or a country, you can instead use [add_Africa-Sub_Sahara_default-region_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_defaultregions/setup_processes/setup_processes-json-add_Africa-Sub_Sahara_default-region/) as a template. Note that however you create a new default region, you have to give the correct default parent region as well as region category defined in the command file [add_region_categories_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_defaultregions/setup_processes/setup_processes-json-add_region_categories/).

#### Add region categories

The explained in the post on [](), the Framework spatial data are organized in projection and tiling systems. In additions there is also a hierarchical spatial system, ranging from the entire globe and down to a quarter or local domain. In addition there are two custom spatial scales that define a project: _tract_ and _site_. A _tract_ must be defined as being part of, or equal to, an existing default region of one of the default categories. A _tract_ can thus be the entire globe or just a quarter or the even smaller domain. A _tract_ can then be divided into any number of arbitrary _sites_, or just constitute a single _site_ (that then equals the _tract_). The project file to the db
[add_region_categories_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_defaultregions/setup_processes/setup_processes-json-add_region_categories/) adds the default sptial categories to the Framework database.

#### Add global default regions

The project file [add_arbitrary_default_regions_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_defaultregions/setup_processes/setup_processes-json-add_arbitrary_default_regions/) adds some arbitrary global default regions that might be useful. if you do not need these, just comment out the call to the project file. You can also use the project file as a template and define your own global, continental or national (etc) default regions.

#### Global default regions

The Framework comes with a set of global default regions, originally created from a 2014 dataset of global national countries. The dataset is generalised into the following spatial layers:

- countries
- continents
- continent-countries (transcontinental countries divided into continent parts)
- subcontinents
- land (all terrestrial land masses)

The same conglomeration of datasets are also available for countries including maritime regions.

##### Simplifying vector layers

The original layer of the global terrestrial political boundaries is a very high (~10 m) accuracy vector map. The original country map is large in size, too large to be stored for free with GitHub. The versions included in Karttur's GitHub repo are thus simplified versions of the original. The terrestrial country maps (countries and continent-countries) are simplified using a tolerance of 100 m. With the continental and subcontinental maps using a tolerance of 1 km. The post [Simplify vector lines and polygons](../setup-region-tolerance) explains how the simplification was done, and can be applied for other vector layers using the Framework itself.

As part of the simplification process also the validity of each polygon was tested and rectified if found erroneous.  The copies available at Karttur's GeoImagine Repo
[github](#) should thus be free or errors. You should be able to import them without checking validity. The parameterisation fo the import process (_OrganizeAncillary_) is set to use the gdal utility _ogr2ogr_ (set to _true_) and to include a _checkfixvalidity_ (set to _true_).

```
#  "process": [
    {
      "processid": "OrganizeAncillary",
      "overwrite": false,
      "verbose": 3,
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
```

#### Add default regions

Once imported as ancillary vector layers, the countries, subcontinents and continents are added as default regions with the process <span class='process'>DefaultRegionFromVector</span>. The project file for that is [add_default_regions_from-vector_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_defaultregions/setup_processes/setup_processes-json-add_default_regions_from-vector/). For each layer to import you have to state the fiels of the vector layer database that define the default region and its parent region.

## Next step

The next step is adding [MODIS tile regions and data access](../setup-setup-modis).
