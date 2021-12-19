---
layout: article
title: "Karttur's GeoImagine Framework:<br />Setup processes (setup_processes)<br />Part 8 Sentinel satellite data & MGRS tiling"
categories: setup
excerpt: "Setup the Military Grid Reference System (MGRS) for tiling of sentinel satellite data"
previousurl: setup/setup-setup-landsat
nexturl: setup/setup-regions-tiling
tags:
 - addsubproc
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2020-12-11 T18:17:25.000Z'
modified: '2021-10-18 T18:17:25.000Z'
comments: true
share: true
---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>


#### Sentinel

By setting

```
    Sentinel = True
```

the module imports the Landsat WRS system for identifying Landsat scene positions. To see the original files, either go to the [sentineldoc](https://github.com/karttur/geoimagine03-setup_processes/tree/main/regiondoc) sub-directory in the [GeoImagine Framework GitHub repo for setup_processes](https://github.com/karttur/geoimagine03-setup_processes), or the [web (html) documents posted in a separate blog](https://karttur.github.io/geoimagine03-docs-setup_processes_sentinel/).


```
    if Sentinel:

        '''Link to project file that sets up the Sentinel tiling system'''

        projFN = 'sentinel_karttur_setup_20211108.txt'

        SetupProcessesRegions('sentineldoc',projFN, prodDB)
```

At present the only included process is the import of the WRS scene positioning system.

```
Import Landsat WRS scene positions
[ancillary-import-USGS-WRS_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes_landsat/setup_processes/setup_processes-ancillary-import-USGS-WRS/)
```
