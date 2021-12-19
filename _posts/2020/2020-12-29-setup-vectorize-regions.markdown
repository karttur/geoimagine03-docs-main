---
layout: article
title: "Karttur's GeoImagine Framework:<br />Vectorise regions"
categories: setup
excerpt: "Reproject regions to the system projection and generate a vector file of the region and the associated tiles"
previousurl: setup/setup-setup-link-regions
nexturl: setup/setup-setup-link-regions
tags:
 - addsubproc
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2020-12-27 T18:17:25.000Z'
modified: '2021-11-26 T18:17:25.000Z'
comments: true
share: true
---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>

In karttur's GeoImagine Framework a _system_ refers to a projection with predefined tiles that can be used for processing spatiotemporal datasets. All spatial processing is related to a default region, but the actual processing is not done at the region as such, but based on [predefined tiles of the _system_](../setup-region-tiling/). This post outlines how to produce vector files of regions and the associated tiles.

## Introduction
