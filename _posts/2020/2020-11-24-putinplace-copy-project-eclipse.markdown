---
layout: article
title: Copy and paste Karttur's GeoImagine Framework
categories: putinplace
excerpt: "Copy and paste selected packages and modules of Karttur's GeoImagine Framework in Eclipse"
previousurl: putinplace/clone-desktop-git
nexturl: prep/prep-dblink
tags:
  - Copy and paste Karttur's GeoImagine Framework
  - Setup Karttur's GeoImagine Framework
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2020-11-25 T18:17:25.000Z'
modified: '2020-11-25 T18:17:25.000Z'
comments: true
share: true

---

## Introduction

A local clone or copy of a PyDev project can be imported to <span class='app'>Eclipse</span> either as a complete project, or by building a backbone PyDev project and copying and pasting selected parts. This post describes how to setup a PyDev backbone and then add packages and modules by copy and paste.

Another alternative is to clone the Framework directly into <span class='app'>Eclipse</span> from the repo on Karttur's GitHub pages as described in the post on [Git clone with Eclipse and no project](../putinplace-clone-eclipse-no-proj/).

## Prerequisites

To follow this post you must have cloned Karttur's GeoImagine Framework to your local machine. Described in the post on [Git clone with GitHub Desktop and terminal](../putinplace-clone-desktop-git). You must also have setup Eclipse for PyDev as described in the post on [Setup Eclipse for PyDev](https://karttur.github.io/setup-ide/setup-ide/install-eclipse/).

## Cloning Karttur's GeoImagine Framework

The core of Karttur's GeoImagine Framework is freely available at Github.com. At time of writing this (November 2021), the latest version available is [GeoIamgineFrame03](https://github.com/karttur/geoimagine03frame). If you did not clone the latest version, see the post on [Git clone with GitHub Desktop and terminal](../putinplace-clone-desktop-git).

## Selecting packages to include

The easiest option when copying the Framework project packages from a local clone to an <span class='app'>Eclipse</span> project is to grab all the packages and drop them in <span class='app'>Eclipse</span>. But you can also chose a subset of packages if you are only working with specific datasets and/or using specific processes. You can for instance exclude data source specific packages:

- Copernicus
- Grace
- Landsat
- MODIS
- Sentinel
- SMAP

Most other spatial data sources are imported to the Framework using the [ancillary package](https://github.com/karttur/geoimagine-ancillary). Point data representing elevation and ground surveyed points or plots are imported separately (not yet available in the public version).

You can also skip some of the processes, for example:

- Basins (river basin delineation)
- Grass (link to GRASS-GIS processing)

## Eclipse project


Start <span class='app'>Eclipse</span> and go inte your _Workspace_, or create a new _Workspace_. Create a new PyDev project in <span class='app'>Eclipse</span> as described in the blogpost [Setup Eclipse for PyDev](https://karttur.github.io/setup-ide/setup-ide/install-eclipse/#create-pydev-project). Just create an empty PyDev project.

## Copy packages and modules

The easiest way to add the resources (packages and modules) that you require is to use a file explorer and drag and drop the packages you want to include into the <span class='app'>Eclipse</span> project <span class='tab'>Navigation</span> pane.  You can also manually [create packages](https://karttur.github.io/setup-ide/setup-ide/install-eclipse/#create-pydev-package) and then drag and drop the individual modules into that package. This gives you more control and you can skip some additional modules, for example the database modules (in the postgresdb package) that links to data sources that you are not interested in.

## Package naming

If you cloned Karttur's GeoImagine Framework as descried in the post [Git clone with GitHub Desktop and terminal](../putinplace-clone-desktop-git/) all the packages in your local clone will have the correct name. The repos actually holding the individual packages are all named with prefix "_geoimagineXX_" followed by a hyphen ("-") and then the actual name of the package. Thus, if you cloned or downloaded one of the submodules directly the naming is not correct. 
