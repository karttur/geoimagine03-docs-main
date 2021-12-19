---
layout: article
title: "Karttur's GeoImagine Framework:<br />Setup processes (setup_processes)<br />Part 7 Landsat scene positions"
categories: setup
excerpt: "Link Landsat scene positions to default regions."
previousurl: setup/setup-setup-ease-grid-2
nexturl: setup/setup-setup-sentinel
tags:
 - addsubproc
 - landsat
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2020-12-11 T18:17:25.000Z'
modified: '2021-10-20 T18:17:25.000Z'
comments: true
share: true
---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>

## Introduction

The Landsat series of polar orbiting and sun-synchronous satellites have captured multi-spectral images of the Earth going back to 1972. Each acquired scene is approximately 180 x 180 km and positioned in a defined scene or tiling system, [the Worldwide Reference System (WRS)](https://www.usgs.gov/landsat-missions/landsat-shapefiles-and-kml-files). To retrieve and organise Landsat data in Karttur's GeoImagine Framework you need to setup Landsat WRS as a scene positioning system. This post explains how to do that.

## Prerequisites

You must have installed Karttur's GeoImagine Framework.

## Systems and regions

In the Framework a _system_ refers to a projection with predefined tiles (or scenes) that can be used for processing spatiotemporal datasets. As a legacy the original Landsat WRS (both version 1 for MultiSpectral Scanner [MSS] and version 2 for all later sensors) systems are included in the Framework. The Landsat _system_ of the framework can only be used for processing Landsat images. To combine the Landsat data with other data you need to first translate the Landsat data to the more generic systems (e.g. MGRS, EASE2 grids or MODIS SIN-grid).

## Import Landsat WRS

The Landsat series of satellites orbit the Earth at an angle of approximately 9 degrees compared to the longitudes and each scene is thus tilted compared to a north-south axis. The combined WRS systems, including both the [D]escending (daytime) and [A]scending (nighttime) paths of the satellites, contain approximately 120,000 scene positions. Importing the scene position layers and retrieving the corners of each scene position in longitude-latitude (WGS84) is fast and should just take a few minutes at the most. The vector polygons of the WRS scene positions that come with the Framework [GitHub repo](#) were prepared by using the Framework itself, and a specially written simplification algorithm as explained in the post [Simplify vector lines and polygons](../setup-region-tolerance).

Linking the individual scene positions to different default regions is a very time consuming process. Especially for large, global regions where the process includes testing every Landsat scene position against a very large (global) multipolygon vector. The rest of this post is thus divided into two parts; a first part that describes how to import a prepared version the complete Landsat dataset on WRS scene corners and links to default regions. This is done by simply importing the prepared database dumps that come with the Framework [GitHub repo](https://github.com). The second part explains how the scene positions are linked from scratch using ordinary Framework processing.

### Import Landsat database

The Framework [GitHub repo](#) comes with prepared text (<span class='file'>.csv</span>) and postgres (<span class='file'>.sql</span>) files where all the links between Landsat WRS and the Framework default regions are defined. You can thus simply run the Framework process <span class='process'>CopyTableCsv</span> or <span class='process'>RestoreTableSQL</span> to add the records defining all the links between Landsat WRS and the default regions. The commands for this are included in <span class='file'>landsat\_karttur\_setup\_YYYYMMDD.txt</span>.

To run the database restoration from the package <span class='package'>setup_processes</span> just change variable _Landsat_ to _True_ under the defined functions _SetupDefaultRegions_

```
def SetupDefaultRegions(prodDB):
  ...
    DefaultRegions = False

    MODIS = False

    EASE2 = False

    Landsat = True
  ...
```
When you run the module, the Landsat linked scripts (defined in <span class='file'>landsat_karttur_setup_YYYYMMDD.txt</span>) will be executed.

```
    if Landsat:

        '''Link to project file that imports the Landsat WRS system'''

        projFN = 'landsat_karttur_setup_20211108.txt'

        SetupProcessesRegions('landsatdoc',projFN, prodDB)

```

The file <span class='file'>landsat\_karttur\_setup\_YYYYMMDD.txt</span> links to a set of json command files that restores the Landsat database tables for _scenecoords_ and _regions_. Inspect the processes by toggling the <span class='button'>Hide/Show</span> button and click on the linked json file names.

<button id= "toggleLandsatSetup" onclick="hiddencode('LandsatSetup')">Hide/Show landsat\_karttur\_setup\_YYYYMMDD.txt</button>

<div id="LandsatSetup" style="display:none">

{% capture text-capture %}
{% raw %}

\# Insert region to Landsat WRS links from csv
[landsat-insert-csv_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_landsat/setup_processes/setup_processes-json-landsat-insert-csv/)

\# Restore region to Landsat WRS links as sql
[landsat-restore-sql_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_landsat/setup_processes/setup_processes-json-landsat-restore-sql/)

{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html toggle-text=text-capture  %}
</div>

### Link Landsat scenes to default regions

The prepared database dumps, used above to restore the Framework database, were originally created using the Framework process <span class='process'>LinkDefaultRegionScenes</span>. As noted above, the process takes a long time when a large number of scene positions (polygons) need to be tested for overlap vis-a-vis a large multipolygon  (i.e. the landmass of the world). However, for smaller (default) regions <span class='process'>LinkDefaultRegionScenes</span> first extracts only the tiles falling inside the region boundary, and then the search for overlap is  quicker. In addition, by setting the parameter _defregmask_ (default region mask) to a parent (or grand-parent etc) region of the actual region(s) to link to scene positions, the overlap test is restricted even further. This is how the overlap between all default regions and the Landsat WRS positions is accomplished in the Framework.

#### <span class='process'>LinkDefaultRegionScenes</span>

The Framework process <span class='process'>LinkDefaultRegionScenes</span> has 15 parameters [default setting]:

- defregmask ["land"], default region for restricting scenes
- srcepsgL [4326], Csv list of source epsg to use for Linking
- regioncat, region category to link
- regionid, ["*"], specific region to link, (or \"\*\" for all regions)
- checkfixvalidity [false],  whether or not to control region vector validity
- ogr2ogr [false], wheter or not to use the gdal utility ogr2ogr or python scripting for reprojections
- cmdpath [None], operating system path to gdal executable, if required
- clipsrc [""], empty (default) or csv for source minx, miny, maxx, maxy
- clipdst [false], whether or not to clip scene search to default region extent
- wrapdateline [true], only applicable when projecting to Geographic coordinates
- onlyregionsfullywithinsystem [true], only link scenes to default regions fully within system boundaries
- onlytiling [false], do not reproject region, only find the overlapping scenes
- wrs [2], the wrs system to analyse (1 or 2)
- dir ['D'], the path direction to analyse ([D]escending or [A]scending)
- minarea [0], minimum overlap area of region and scene for linking

The naming of the output layers from the processes are defaulted, and you do not need to explicitly give any _"dstcomp"_ (destination compositions) when running <span class='process'>LinkDefaultRegionScenes</span>. However, as each default region (e.g. _africa_) is associated with four (4) different Landsat WRS scene systems:

- WRS 1 ascending
- WRS 1 descending
- WRS 2 ascending
- WRS 2 descending

you should explicitly state the output layers for the tiles (but keep the region the same). For processes that require more than a single source (src) or destination (dst) layer, you have to give the correct id for each layer in the json commands.  <span class='process'>LinkDefaultRegionScenes</span> then generates two output layers for each input:

- region (the reprojected default region)
- tiles (the tiles or scenes covering the region in the system projection)

Thus the command to link Landsat WRS 2 Descending (daytime) scenes to all continental regions becomes:

```
{
  "userproject": {
    "userid": "karttur",
    "projectid": "karttur",
    "tractid": "karttur",
    "siteid": "*",
    "plotid": "*",
    "system": "landsat"
  },
  "period": {
    "startyear": 2014,
    "endyear": 2014,
    "timestep": "singleyear"
  },
  "process": [
    {
      "processid": "LinkDefaultRegionScenes",
      "overwrite": false,
      "version": "0.9",
      "verbose": 2,
      "parameters": {
        "defregmask": "land",
        "regioncat": "continent",
        "dir": "D",
        "wrs": 2,
        "ogr2ogr": true,
        "cmdpath": "/usr/local/bin",
        "clipsrc": "-180,0,180,90",
        "onlytiling": false,
        "minarea": 0
      },
      "srcpath": {
        "volume": "GeoImg2021",
        "hdr": "shp",
        "dat": "shp"
      },
      "dstpath": {
        "volume": "GeoImg2021",
        "hdr": "shp",
        "dat": "shp"
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
          },
          "tiles": {
            "source": "karttur",
            "product": "karttur",
            "content": "roi",
            "layerid": "tiles",
            "prefix": "tiles-wrs2-D",
            "suffix": "0"
          }
        }
      ]
    }
  ]
}
```

Note that the parameter _defregmask_ is set to _land_. For this to work you must start the processing chain by actually linking the global landmass to the approximately 30000 Landsat scenes defined in WRS 2 descending (daytime). This is thus the first process in the chain outlined in the next section. Note also how the file name _prefix_ of the _tiles_ destination composition (_dstcomp_) is set ot _tiles-wrs2-D_, while the _layerid_ is just _tiles_. You can check the settings for producing all the other WRS tiles under the next section or in te [GitHub repo](#).

#### Process chain

The process chain for setting up the Landsat WRS scene positions and linking them to the default regions are in the file <span class='file'>landsat_karttur_setup-from-scratch_20211108.txt</span>. Inspect the processes by toggling the <span class='button'>Hide/Show</span> button and click on the linked json file names.

<button id= "toggleLandsatScratchSetup" onclick="hiddencode('LandsatScratchSetup')">Hide/Show landsat\_karttur\_setup\_YYYYMMDD.txt</button>

<div id="LandsatScratchSetup" style="display:none">

{% capture text-capture %}
{% raw %}

\# Import Landsat WRS scene positions as quadrangles
[ancillary-import-USGS-WRS-quadrangle_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_landsat/setup_processes/setup_processes-json-ancillary-import-USGS-WRS-quadrangle/)

\# Extract WRS tile coordinates to database
[wrs-extract_tile_coords_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_landsat/setup_processes/setup_processes-json-wrs-extract_tile_coords/)

\# Link region land to Landsat WRS scenes
[landregion-landsat-scenes-1A_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_landsat/setup_processes/setup_processes-json-landregion-landsat-scenes-1A/)

[landregion-landsat-scenes-2A_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_landsat/setup_processes/setup_processes-json-landregion-landsat-scenes-2A/)

[landregion-landsat-scenes-1D_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_landsat/setup_processes/setup_processes-json-landregion-landsat-scenes-1D/)

[landregion-landsat-scenes-2D_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_landsat/setup_processes/setup_processes-json-landregion-landsat-scenes-2D/)

\# With the land region linked, restrict search and link continents and countries
[continentregion-landsat-scenes-1A_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_landsat/setup_processes/setup_processes-json-continentregion-landsat-scenes-1A/)

[continentregion-landsat-scenes-2A_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_landsat/setup_processes/setup_processes-json-continentregion-landsat-scenes-2A/)

[continentregion-landsat-scenes-1D_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_landsat/setup_processes/setup_processes-json-continentregion-landsat-scenes-1D/)

[continentregion-landsat-scenes-2D_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_landsat/setup_processes/setup_processes-json-continentregion-landsat-scenes-2D/)

[subcontinentregion-landsat-scenes-1A_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_landsat/setup_processes/setup_processes-json-subcontinentregion-landsat-scenes-1A/)

[subcontinentregion-landsat-scenes-2A_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_landsat/setup_processes/setup_processes-json-subcontinentregion-landsat-scenes-2A/)

[subcontinentregion-landsat-scenes-1D_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_landsat/setup_processes/setup_processes-json-subcontinentregion-landsat-scenes-1D/)

[subcontinentregion-landsat-scenes-2D_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_landsat/setup_processes/setup_processes-json-subcontinentregion-landsat-scenes-2D/)

[countryregion-landsat-scenes-1A_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_landsat/setup_processes/setup_processes-json-countryregion-landsat-scenes-1A/)

[countryregion-landsat-scenes-2A_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_landsat/setup_processes/setup_processes-json-countryregion-landsat-scenes-2A/)

[countryregion-landsat-scenes-1D_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_landsat/setup_processes/setup_processes-json-countryregion-landsat-scenes-1D/)

[countryregion-landsat-scenes-2D_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_landsat/setup_processes/setup_processes-json-countryregion-landsat-scenes-2D/)

[continentcountryregion-landsat-scenes-1A_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_landsat/setup_processes/setup_processes-json-continentcountryregion-landsat-scenes-1A/)

[continentcountryregion-landsat-scenes-2A_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_landsat/setup_processes/setup_processes-json-continentcountryregion-landsat-scenes-2A/)

[continentcountryregion-landsat-scenes-1D_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_landsat/setup_processes/setup_processes-json-continentcountryregion-landsat-scenes-1D/)

[continentcountryregion-landsat-scenes-2D_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_landsat/setup_processes/setup_processes-json-continentcountryregion-landsat-scenes-2D/)

\# Export linked landregion as csv
[landsat-export-csv_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_landsat/setup_processes/setup_processes-json-landsat-export-csv/)

\# Dump linked landregion as sql
[landsat-dumptable-sql_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_landsat/setup_processes/setup_processes-json-landsat-dumptable-sql/)

{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html toggle-text=text-capture  %}
</div>

If you want to run the above commands you have to replace the default linked file (landsat_karttur_setup_YYYYMMDD.txt) and replace it with landsat_karttur_setup-from-scratch_YYYYMMDD.txt, in the python script.

```
    if Landsat:

        '''Link to project file that imports the Landsat WRS system'''

        projFN = 'landsat_karttur_setup-from-scratch_20211108.txt'

        SetupProcessesRegions('landsatdoc',projFN, prodDB)

```
