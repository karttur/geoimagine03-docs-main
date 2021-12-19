---
layout: article
title: "Karttur's GeoImagine Framework:<br />Setup processes (setup_processes)<br />Part 6 EASE-grid tile & projection system"
categories: setup
excerpt: "Setup EASE-grid 2 tiling and projection systems and define default regions"
previousurl: setup/setup-setup-ease-grid-2
nexturl: setup/setup-setup-landsat
tags:
 - addsubproc
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2020-12-10 T18:17:25.000Z'
modified: '2021-10-18 T18:17:25.000Z'
comments: true
share: true
---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>

## Introduction

The EASE-grid 2.0 projection and tiling systems are the preferred systems for large regions that are bound to one of the hemisperes of confined to within 45 degrees latitiude. This post outlines how to link [default regions](../setup-setup-processes-regions) to the EASE-grid projection and tiling systems.

#### EASE-grid 2.0

The setup of the specific EASE-grid 2.0 resources is inlcuded in the package <span class='package'>setup_processes</span>. Run the setup of EASE-grid related regions by setting the variable _EASE2_ to _True_ in <span class='module'>setup_process_main</span> under the defined functions _SetupDefaultRegions_

```
def SetupDefaultRegions(prodDB):
  ...
    DefaultRegions = False

    MODIS = False

    EASE2 = True
  ...
```

When you run the module, the EASE-grid linked scripts will be executed.

```
    if EASE2:

        '''Stand alone scripts that defines EASE grid tropical tile coordinates.
        Takes a minute or two due to massive reprojection tasks'''
        Ease2GlobalTileCoords(prodDB)

        projFN = 'EASEgrid_karttur_setup_20211108.txt'

        SetupProcessesRegions('ease2doc', projFN, prodDB)
```

The more complex tiling system of EASE-grid 2 tropical (denoted ease2t in the Framework) is done by a hardcoded function (_Ease2GlobalTileCoords_). The tiling system is saved in the database table _ease2t.tilecoords_.  The tiling and coordinates for EASE-grid 2.0 North (ease2n) and EASE-grid 2.0 South (ease2s) are created by the Framework ordinary json structure via the commands linked in <span class='file'>modis\_karttur\_setup\_YYYYMMDD.txt</span>.

The file <span class='file'>EASEgrid\_karttur\_setup\_YYYYMMDD.txt</span> links to a set of json command files that setup the EASE-grid 2 processing environment in the Framework. Inspect its content by toggling the <span class='button'>Hide/Show</span> button and click on the linked json file name.

The first json command file is identical to the EASE-grid setup file under _SetupCustomGrids_ (see the post on [Projection and tiling systems](../setup-custom-systems) for details).

<button id= "toggleEASE2" onclick="hiddencode('EASE2')">Hide/Show ease2\_karttur\_setup\_YYYYMMDD.txt</button>

<div id="EASE2" style="display:none">

{% capture text-capture %}
{% raw %}

\# Define the EASE-grid 2 north/South tile/project systems
[ease2_system-define_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_ease2/setup_processes/setup_processes-json-ease2_system-define/)

\# Link default regions to EASE-grid 2 North grid tiles
[regions-ease2ntiles_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_ease2/setup_processes/setup_processes-json-regions-ease2ntiles/)

\# Link default regions to EASE-grid 2 South grid tiles
[regions-ease2stiles_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_ease2/setup_processes/setup_processes-json-regions-ease2stiles/)

\# Link default regions to EASE-grid 2 Tropical grid tiles
[regions-ease2ttiles_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_ease2/setup_processes/setup_processes-json-regions-ease2ttiles/)

{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html toggle-text=text-capture  %}
</div>

Figure 1 illustrates the linking of continents to the EASE-grid 2.0 North tiling, in the EASE-grid 2.0 North and cut to the northern hemisphere (at the equator).

<figure>
<img src="../../images/ease2n_system_continent_regions.png" alt="image">
<figcaption>Continental regions and tiles in the EASE-grid 2.0 North tiling and projection system.</figcaption>
</figure>

## Next step

The next step is adding [Landsat scenes and data access](../setup-setup-landsat/).
