---
layout: article
title: "Karttur's GeoImagine Framework:<br />Setup processes (setup_processes)<br />Simplify Landsat WRS polygons"
categories: landsat
excerpt: "Special script for simplifying quadrangles, including the Landsat WRS scene polygons"
previousurl: setup/setup-db
nexturl: setup/setup-regions
tags:
 - addsubproc
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2020-12-31 T18:17:25.000Z'
modified: '2021-11-13 T18:17:25.000Z'
comments: true
share: true
---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>

## Introduction

This post details how to simplify quadrangle polygons to only be represented by four (4) vertices. The process for quadrangle simplification was specifically developed for the Landsat [Worldwide Reference System (WRS)](https://landsat.gsfc.nasa.gov/about/worldwide-reference-system) scene position tiles.

## Prerequisites

You must have installed Karttur's GeoImagine Framework.

## Simplifying scene positions to quadrangles and rectangles

As mentioned above, all scene positions in the original WRS dataset are defined by more than 4 corners. In the Framework database defining tiles and scenes, only corner coordinates are included - intermediate nodes or vertices are not allowed. This vastly speeds up the construction and transformation of the polygons defining the tiles/scenes. The [Landsat WRS scene dataset supplied with Framework on GitHub]((https://github.com/karttur/geoimagine03-setup_processes/tree/main/landsatdoc) are already cleaned up and each scene position is defined by either 3 or 4 corner vertices (for scenes cu by the dateline some will only have 3 corners due to the 9 degree tilt of the orbit). This section outlines how it was done should you need to clean up some other quadrangle data with surplus vertices.

In the Framework the process _OganiseAncillary_?? can be used for simplifying vectors using three principally different methods:

- [Tolerance simplification using shapely](https://shapely.readthedocs.io/en/stable/manual.html#object.simplify)
- Tolerance simplification using angles (for strictly geometric polygons)
- Simplification of quadrangles to four (4) corners

### Tolerance simplification using shapely

The standard [Shapely simplification tool](https://shapely.readthedocs.io/en/stable/manual.html#object.simplify) can be used for any line of polygon vector. The quicker algorithm that does not necessarily preserve topology (Douglas-Peucker) is not implemented in the Framework. Just set the parameter for _tolerance_ > _0_ for the process _AncillaryImport_, but keep _"angletolerance"_ : _0_ and _"quadrangle"_: _false_:

```
        "tolerance": 0.1,
        "angletolerance": 0,
        "quadrangle": false
```

Each vector of the imported dataset will be simplified and keep its internal topology. The topology between vectors can, however, be distorted.

### Tolerance simplification using angles (for strictly geometric polygons)

The simplification of geometric polygons using angles instead of tolerance was developed by Mike Toves and is available from [GitHub](https://github.com/Toblerity/Shapely/issues/1046). To invoke the angle tolerance simplification t set the parameter for _angletolerance_ > _0_ for the process _AncillaryImport_ while keeping _"tolerance"_ : _0_ and _"quadrangle"_: _false_:

```
        "tolerance": 0.0,
        "angletolerance": 1,
        "quadrangle": false
```

### Simplification of quadrangles to four (4) corners

Simplification of quadrangles to four (4) corners sets a rectangular boundary and keeps the four vertices that intersects with the boundary. When one of the sides of the original quadrangle is either vertical or horisontal an extra loop finds the corners - thus you must set both _quadrabngl_ to _True_ and a _tolerance_. If the quadranlge is actually triangle, it is saved as a triangle.

```
        "tolerance": 0.1,
        "angletolerance": 0,
        "quadrangle": true
```
The WRS scene position datasets that are available with Karttur´s GeoImagine Framework were generated using the quadrangle simplification with the settings above.
