---
layout: post
title: DEM neighbourhood analysis - illustrations
categories: blog
datasource: dem
excerpt: "Illustration of DEM measures and indexes from kernel neighbourhood analysis"
tags:
  - Copernicus DEM
  - kernel
  - slope
  - aspect
  - curvature
  - TPI
  - TRI
  - roughness
  - geomophology
  - landform
  - r.param.scale
  - r.geomprphon
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2021-07-30 T18:17:25.000Z'
modified: '2021-07-30 T18:17:25.000Z'
comments: true
share: true
---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>

# Introduction

This article illustrates some of the DEM neighborhood indices introduced in the [previous](../blog-COPDemTileProcess) post.


<figure class="half">
	<a href="../../images/dem3_copdem_x04y07_0_v01-90m.jpg"><img src="../../images/dem3_copdem_x04y07_0_v01-90m.jpg" alt="image"></a>

  <a href="../../images/dem3-shade_copdem_x04y07_0_v01-90m-3x3.jpg"><img src="../../images/dem3-shade_copdem_x04y07_0_v01-90m-3x3.jpg" alt="image not yet ready"></a>

<figcaption>Elevation data from which the metrics below was derived; left image at 90 m resolution, right image after average smoothing with a 3x3 equal weights square kernel.</figcaption>
</figure>

<figure class="half">
	<a href="../../images/slope3_copdem_x04y07_0_v01-90m-grass-3x3.jpg"><img src="../../images/slope3_copdem_x04y07_0_v01-90m-grass-3x3.jpg" alt="image"></a>

  <a href="../../images/slope3_copdem_x04y07_0_v01-90m-grass-9x9.jpg"><img src="../../images/slope3_copdem_x04y07_0_v01-90m-grass-9x9.jpg" alt="image"></a>

	<figcaption>Slope steepness derived from Karttur's GeoImagine Framework (numpy and scipy); left image from a 3x3 kernel, right image from a 9x9 kernel.</figcaption>
</figure>

<figure class="half">
	<a href="../../images/profc_copdem_x04y07_0_v01-90m-grass-3x3.jpg"><img src="../../images/profc_copdem_x04y07_0_v01-90m-grass-3x3.jpg" alt="image"></a>

  <a href="../../images/profc_copdem_x04y07_0_v01-90m-grass-9x9.jpg"><img src="../../images/profc_copdem_x04y07_0_v01-90m-grass-9x9.jpg" alt="image"></a>

	<figcaption>Profile curvature derived from the grass module r.params.scale; left image from a 3x3 kernel, right image from a 9x9 kernel.</figcaption>
</figure>

<figure class="half">
	<a href="../../images/crosc_copdem_x04y07_0_v01-90m-grass-3x3.jpg"><img src="../../images/crosc_copdem_x04y07_0_v01-90m-grass-3x3.jpg" alt="image"></a>

  <a href="../../images/crosc_copdem_x04y07_0_v01-90m-grass-9x9.jpg"><img src="../../images/crosc_copdem_x04y07_0_v01-90m-grass-9x9.jpg" alt="image"></a>

	<figcaption>Cross curvature derived from the grass module r.params.scale; left image from a 3x3 kernel, right image from a 9x9 kernel.</figcaption>
</figure>

<figure class="half">
	<a href="../../images/longc_copdem_x04y07_0_v01-90m-grass-3x3.jpg"><img src="../../images/longc_copdem_x04y07_0_v01-90m-grass-3x3.jpg" alt="image"></a>

  <a href="../../images/longc_copdem_x04y07_0_v01-90m-grass-9x9.jpg"><img src="../../images/longc_copdem_x04y07_0_v01-90m-grass-9x9.jpg" alt="image"></a>

	<figcaption>Longitudinal curvature derived from the grass module r.params.scale; left image from a 3x3 kernel, right image from a 9x9 kernel.</figcaption>
</figure>

<figure class="half">
	<a href="../../images/planc_copdem_x04y07_0_v01-90m-grass-3x3.jpg"><img src="../../images/planc_copdem_x04y07_0_v01-90m-grass-3x3.jpg" alt="image"></a>

  <a href="../../images/planc_copdem_x04y07_0_v01-90m-grass-9x9.jpg"><img src="../../images/planc_copdem_x04y07_0_v01-90m-grass-9x9.jpg" alt="image"></a>

	<figcaption>Planar curvature derived from the grass module r.params.scale; left image from a 3x3 kernel, right image from a 9x9 kernel.</figcaption>
</figure>


<figure class="half">
	<a href="../../images/tri_copdem_x04y07_0_v01-90m-3x3.jpg"><img src="../../images/tri_copdem_x04y07_0_v01-90m-3x3.jpg" alt="image"></a>

  <a href="../../images/tri_copdem_x04y07_0_v01-90m-9x9.jpg"><img src="../../images/tri_copdem_x04y07_0_v01-90m-9x9.jpg" alt="image"></a>

	<figcaption>Topographic Ruggedness Index (TRI) derived from GDAL and Karttur's GeoImagine Framework; left image from a 3x3 kernel, right image from a 9x9 kernel.</figcaption>
</figure>

<figure class="half">
	<a href="../../images/tpi_copdem_x04y07_0_v01-90m-3x3.jpg"><img src="../../images/tpi_copdem_x04y07_0_v01-90m-3x3.jpg" alt="image"></a>

  <a href="../../images/tpi_copdem_x04y07_0_v01-90m-9x9.jpg"><img src="../../images/tpi_copdem_x04y07_0_v01-90m-9x9.jpg" alt="image"></a>

	<figcaption>Topographic Position Index (TPI) derived from GDAL and Karttur's GeoImagine Framework; left image from a 3x3 kernel, right image from a 9x9 kernel.</figcaption>
</figure>

<figure class="half">
	<a href="../../images/landform-TPI_copdem_x04y07_0_v01-90m-np-stnd-1+3.jpg"><img src="../../images/landform-TPI_copdem_x04y07_0_v01-90m-np-stnd-1+3.jpg" alt="image"></a>

  <a href="../../images/landform-TPI_copdem_x04y07_0_v01-90m-np-stnd-1+9.jpg"><img src="../../images/landform-TPI_copdem_x04y07_0_v01-90m-np-stnd-1+9.jpg" alt="image not yet ready"></a>

	<figcaption>Landform classes derived from dual scale TPI analysis using Karttur's GeoImagine Framework; left image from a 3x3 + 9+9 kernel, right image from a 3x3 + 18x18 kernel.</figcaption>
</figure>

<figure class="half">
	<a href="../../images/geomorph_copdem_x04y07_0_v01-90m-grass-3x3.jpg"><img src="../../images/geomorph_copdem_x04y07_0_v01-90m-grass-3x3.jpg" alt="image"></a>

  <a href="../../images/geomorph_copdem_x04y07_0_v01-90m-grass-5x5.jpg"><img src="../../images/geomorph_copdem_x04y07_0_v01-90m-grass-5x5.jpg" alt="image not yet ready"></a>

  <a href="../../images/geomorph_copdem_x04y07_0_v01-90m-grass-5x5-elev3x3.jpg"><img src="../../images/geomorph_copdem_x04y07_0_v01-90m-grass-5x5-elev3x3.jpg" alt="image"></a>

  <a href="../../images/geomorph_copdem_x04y07_0_v01-90m-grass-9x9.jpg"><img src="../../images/geomorph_copdem_x04y07_0_v01-90m-grass-9x9.jpg" alt="image"></a>

	<figcaption>Geomorphon classes derived from GRASS module r.geomorphon; top row image from a 3x3 kernel and the original DEM, lower left image from a 5x5 kernel applied after filtering the DEM with an averaging 3x3 kernel, lower right image from a 9x9 kernel applied to an unfiltered DEM.</figcaption>

  <figure class="half">
  	<a href="../../images/landform-ps_copdem_x04y07_0_v01-90m-grass-3x3.jpg"><img src="../../images/landform-ps_copdem_x04y07_0_v01-90m-grass-3x3.jpg" alt="image"></a>

    <a href="../../images/landform-ps_copdem_x04y07_0_v01-90m-grass-9x9.jpg"><img src="../../images/landform-ps_copdem_x04y07_0_v01-90m-grass-9x9.jpg" alt="image not yet ready"></a>

  	<figcaption>Morphology classes derived from the GRASS module r.param.scale; left image from a 3x3 kernel, right image from a 9x9 kernel.</figcaption>
  </figure>

</figure>
