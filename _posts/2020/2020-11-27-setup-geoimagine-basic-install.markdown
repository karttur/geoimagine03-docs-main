---
layout: article
title: "Karttur's GeoImagine Framework:<br /> Basic components installation"
categories: setup
tutorial: null
excerpt: "A complete installation scheme for the basic components of Karttur's GeoImagine Framework"
previousurl: concept/concept-concept
nexturl: setup/setup-setup-db
tags:
  - GeoImagine
  - Framework
  - setup
  - install
  - complete
  - basic
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2020-11-27 T18:17:25.000Z'
modified: '2021-09-27 T18:17:25.000Z'
comments: true
share: true
---

## Introduction

Karttur's GeoImagine Framework is a system for processing Big Spatial Data. It is not easy to setup and learn, but once you have it running it is more versatile than other systems. This post links to all the steps required for setting up the basic Framework in MacOS or Linux.

## Basic tools

You need a good text editor that can handle simple text (<span class='file'>.txt</span> and <span class='file'>.csv</span>) files and json (<span class='file'>.json</span>) files. Perhaps the best alternative is to use the open source app [<span class='app'>Atom</span>](https://atom.io).

if you are setting up the Framework for MacOS and want to follow the instructions, you also need to install [Homebrew - the Missing Package Manager for macOS (or Linux)](https://brew.sh)

My very first blog and its sole post - [Set up blog tools: Atom, Homebrew and Jekyll](https://karttur.github.io/setup-blog/2017/12/21/setup-blog-tools.html), explains how to install <span class='app'>Atom</span>, <span class='terminalapp'>Homebrew</span> and the blog tool (<span class='terminalapp'>jekyll</span>) that I use.

## Image and video editing tools

Some parts of Framework make use of command line image and video editing tools - e.g. for producing maps and animations. These tools are installed using [Homebrew](https://brew.sh), as outlined in detail in the two blog posts on [ImageMagick](https://karttur.github.io/setup-theme-blog/blog/install-imagemagick/) and [Create FFmpeg movie](https://karttur.github.io/setup-theme-blog/blog/ffmpeg-movie/).

## Spatial Data Integrated Development Environment (SPIDE)

The blog [Install and setup SPIDE](https://karttur.github.io/setup-ide/) covers installing and setting up Geographic Information Systems (GIS), a general Integrated Development Environment (IDE), a tool for creating virtual python environments and the PostgreSQL database that store all the information on processing and spatial data layers in the Framework.

Here are the links to the core posts on MacOS setup in the SPIDE blog:

- [Install GDAL, QGIS and GRASS](https://karttur.github.io/setup-ide/setup-ide/install-gis/)
- [Install Anaconda](https://karttur.github.io/setup-ide/setup-ide/install-anaconda/)
- [Setup Eclipse for PyDev](https://karttur.github.io/setup-ide/setup-ide/install-eclipse/)
- [Install postgreSQL and postGIS](https://karttur.github.io/setup-ide/setup-ide/install-postgres/)
- [Conda virtual environments I](https://karttur.github.io/setup-ide/setup-ide/conda-environ/)

The complete setup in Linux is summarised in a singel post: [SPIDE for Ubuntu 20](https://karttur.github.io/setup-ide/blog/ubuntu20-setup-spide/).

The blog [Install and setup SPIDE](https://karttur.github.io/setup-ide/) also contains some more details on various problems and options for the setup.

## Next step

The next step is to [setup the database](../setup-setup-db).
