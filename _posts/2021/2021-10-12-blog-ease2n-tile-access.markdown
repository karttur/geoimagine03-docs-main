---
layout: post
title: "EASE-grid North"
categories: access
excerpt: "Accessing EASE-grid North tiles"
tags:
  - EASE-grid
  - tiles
  - north
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2021-10-12 T18:17:25.000Z'
modified: '2021-10-12 T18:17:25.000Z'
comments: true
share: true
figure1: soil-moisture-avg_SPL3SMP_global_2015-2018@D001_005

---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>

## Introduction

Sharing of products derived from Karttur's GeoImagine Framework is normally done using the tiling system with tiles compressed using gunzip and assembled using tarball (<span class='file'>.tar.gz</span>). This article outlines the EASE-grid 2.0 North (EPSG:6931) tiling system and how to unzip and mosaic the tiles.

## Prerequisites

Downloading and unzipping the tiles does not require any special tools; to create virtual mosaics you must have GDAL installed.

## EASE-grid 2.0 N

The EASE-grid 2.0 North projection (EPSG_6931) is a polar azimuthal equal-area projection for the Northern hemisphere. The coordinates in both directions of the projection xy-plane range from -9000000.0 to 9000000.0. The National Snow and Ice Data Center (NSIDC) defines different [default resolutions ranging from 3 to 36 km](https://nsidc.org/ease/ease-grid-projection-gt).

Karttur's GeoImagine Framework uses EASE-grid 2.0 N as the default system for Arctic data. In the Framework the EASE-grid 2.0 N projection is tiled into 400 tiles, 20 tiles in the x-dimension and 20 tiles in the y-direction. This means that each tile is 900000 * 900000 m. The tiles are intended for data at a maximum spatial resolution of 30 m, when each tile will contain 30000 * 30000 (900 million) cells. The tiles are numbered starting with x=0 and y=0. Tile naming is forced to 6 characters: xnnymm, where nn and mm are the x and y tile number respectively. Tiles 0-9 are given an extra 0 before the value.

## Land tiles

For most applications, but not all, the Framework Arctic tiles used with the EASE-grid 2.0 North projection are restricted to the tiles affecting Arctic regions. Including all the basins feeding into Arctic and Nordic waters, this corresponds to 104 (out of the total of 400) tiles.

## Compression and unzipping

The online available tiles are by default available as gunzipped tarballs (<span class='file'>.tar.gz</span>). Exploded tiles will be located in the same folder as the <span class='file'>.tar.gz</span>. Exploding should be straight forward in all operating systems.

Exploding the tiles, use the command line tool:

<span class='terminal'></span>find . -name "*.tar.gz" | while read filename; do tar -xf "`dirname "$filename"`" "$filename"; done;</span>

## Create virtual mosaic

With Karttur´s GeoIamgine Framework you can create virtual mosaics any predefined region using the tiles. If you want to mosaic two or more tiles outside the Framework, you can use the [Geographic Data Abstraction Library (GDAL)](https://gdal.org) virtual dataset [(<span class='file'>.vrt</span>) format](https://gdal.org/drivers/raster/vrt.html). To craete the virtual dataset, use the GDAL command [gdalbuildvrt](https://gdal.org/programs/gdalbuildvrt.html).
