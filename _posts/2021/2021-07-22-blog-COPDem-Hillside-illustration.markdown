---
layout: post
title: DEM hill side indices - illustrations
categories: blog
datasource: dem
excerpt: "Illustration of DEM measures and indices representing the scale of the stream and its valley"
tags:
  - Copernicus DEM
  - hillside
  - r.watershed
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2021-07-22 T18:17:25.000Z'
modified: '2021-07-22 T18:17:25.000Z'
comments: true
share: true
---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>

# Introduction

This article illustrates some of the DEM hill side indices introduced in the [previous](../blog-COPDemTileProcess) post.

<figure class="half">
	<a href="../../images/dem3-shade_copdem_x04y07_0_v01-90m.jpg"><img src="../../images/dem3-shade_copdem_x04y07_0_v01-90m.jpg" alt="image"></a>

  <a href="../../images/dem3-shade_copdem_x04y07_0_v01-90m-3x3.jpg"><img src="../../images/dem3-shade_copdem_x04y07_0_v01-90m-3x3.jpg" alt="image not yet ready"></a>

<figcaption>Elevation data from which the metrics and indices below were derived; left image at 90 m resolution, right image after average smoothing with a 3x3 equal weights square kernel.</figcaption>
</figure>

<figure class="half">
	<a href="../../images/stream-dist_copdem_x04y07_0_v01-pfpf-hydrdem4+4-90m.jpg"><img src="../../images/stream-dist_copdem_x04y07_0_v01-pfpf-hydrdem4+4-90m.jpg" alt="image"></a>

  <a href="../../images/hydraulhead_copdem_x04y07_0_v01-pfpf-hydrdem4+4-90m.jpg"><img src="../../images/hydraulhead_copdem_x04y07_0_v01-pfpf-hydrdem4+4-90m.jpg" alt="image"></a>

	<figcaption>Streams and distances to draining stream along the hillside flow route (left panel) and elevation difference between land surface and drainage point (hydraulic head).</figcaption>
</figure>

<figure class="half">

  <a href="../../images/near-divide-dist_copdem_x04y07_0_v01-pfpf-hydrdem4+4-90m.jpg"><img src="../../images/near-divide-dist_copdem_x04y07_0_v01-pfpf-hydrdem4+4-90m.jpg" alt="image"></a>

  <a href="../../images/near-divide-head_copdem_x04y07_0_v01-pfpf-hydrdem4+4-90m.jpg"><img src="../../images/near-divide-head_copdem_x04y07_0_v01-pfpf-hydrdem4+4-90m.jpg" alt="image"></a>

	<figcaption>Distances to the closest water divider along the flow route (left panel) and elevation difference difference between the land surface and this nearest divider.</figcaption>
</figure>

<figure class="half">

  <a href="../../images/far-divide-dist_copdem_x04y07_0_v01-pfpf-hydrdem4+4-90m.jpg"><img src="../../images/far-divide-dist_copdem_x04y07_0_v01-pfpf-hydrdem4+4-90m.jpg" alt="image"></a>

  <a href="../../images/far-divide-head_copdem_x04y07_0_v01-pfpf-hydrdem4+4-90m.jpg"><img src="../../images/far-divide-head_copdem_x04y07_0_v01-pfpf-hydrdem4+4-90m.jpg" alt="image"></a>

	<figcaption>Distances to the furthest water divider along the flow route (left panel) and elevation difference difference between the land surface and this furthest divider. Note that the scaling differs compared to the figure above illustrating the distance and elevation difference to the nearest water divider</figcaption>
</figure>

<figure class="half">
	<a href="../../images/rusle-slopelength_copdem_x04y07_0_v01-pfpf-hydrdem4+4-90m.jpg"><img src="../../images/rusle-slopelength_copdem_x04y07_0_v01-pfpf-hydrdem4+4-90m.jpg" alt="image"></a>

  <a href="../../images/rusle-slopesteepness_copdem_x04y07_0_v01-pfpf-hydrdem4+4-90m.jpg"><img src="../../images/rusle-slopesteepness_copdem_x04y07_0_v01-pfpf-hydrdem4+4-90m.jpg" alt="image"></a>

	<figcaption>Revised Universal Soil Loss Equation (RUSLE) hillside indexes for, left: slope length, and right: slopre steepness.</figcaption>
</figure>

<figure class="half">
	<a href="../../images/sfd-updrain_copdem_x04y07_0_v01-pfpf-hydrdem4+4-90m.png"><img src="../../images/sfd-updrain_copdem_x04y07_0_v01-pfpf-hydrdem4+4-90m.png" alt="image"></a>

  <a href="../../images/mfd-updrain_copdem_x04y07_0_v01-pfpf-hydrdem4+4-90m.png"><img src="../../images/mfd-updrain_copdem_x04y07_0_v01-pfpf-hydrdem4+4-90m.png" alt="image"></a>

	<figcaption>Upstream drainage areas, left: from single flow direction (SFD) analysis, and right: Multiple Flow Direction (MFD) analysis. The scaling is the same for both images and represent the natural logarithm of the total upstream area of each cell. </figcaption>
</figure>

<figure class="half">
	<a href="../../images/tci_copdem_x04y07_0_v01-pfpf-hydrdem4+4-90m.png"><img src="../../images/tci_copdem_x04y07_0_v01-pfpf-hydrdem4+4-90m.png" alt="image"></a>

  <a href="../../images/psi_copdem_x04y07_0_v01-pfpf-hydrdem4+4-90m.png"><img src="../../images/psi_copdem_x04y07_0_v01-pfpf-hydrdem4+4-90m.png " alt="image"></a>

	<figcaption>Wetlness and steam power index; left: Topographci Convergence Index (TCI) also labeles Topographic Wetniess Index (TWI), and right: Stream Power Index (SPI).</figcaption>
</figure>
