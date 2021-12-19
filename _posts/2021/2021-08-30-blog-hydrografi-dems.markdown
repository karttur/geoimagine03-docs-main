---
layout: post
title: Hydrografi
categories: blog
datasource: dem
biophysical: hydrography
excerpt: "Extracting hydrografi from DEMs"
tags:
  - DEM
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2021-08-30 T18:17:25.000Z'
modified: '2021-08-30 T18:17:25.000Z'
comments: true
share: true
figure1: soil-moisture-avg_SPL3SMP_global_2015-2018@D001_005
fig2a: soil-moisture-am_SPL3SMP_global_20160122_005
fig2b: soil-moisture-avg_SPL3SMP_global_20160122_005
fig2c: soil-moisture-pm_SPL3SMP_global_20160122_005
figure3: soil-moisture-avg_SPL3SMP_global_2016009_005
movie1: soil-moisture-avg_SPL3SMP_global_2015121-2018345_005
movie2: soil-moisture-avg_SPL3SMP_global_2015-2018@16D_005


SMAP-0100_search-daac_20150331-20150807: SMAP-0100_search-daac_20150331-20150807

---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>

## Introduction

DEM

## Accuracy evaluation


### Public hydrographic data

#### Sweden

For Sweden, publicly available (see [Licence](https://www.smhi.se/data/oppna-data/villkor-for-anvandning-1.30622)) hydrogaphic data from the [Swedish Water Archive (SVAR), version 2016_3](https://www.smhi.se/data/hydrologi/sjoar-och-vattendrag/ladda-ner-data-fran-svenskt-vattenarkiv-1.20127) include:

- [Main River Basins](https://www.smhi.se/polopoly_fs/1.126762!/Huvudavrinningsomraden_haro_y_2016_3.zip)
- [Sub basins](https://www.smhi.se/polopoly_fs/1.126764!/avrinningsomraden_aro_y_2016_3.zip)
- [Water surfaces](https://www.smhi.se/polopoly_fs/1.126766!/Vattenytor_vy_y_2016_3.zip)
- [Water courses](https://www.smhi.se/polopoly_fs/1.126768!/flodeslinjer_vd_l_2016_3.zip)
- [Sea regions](https://www.smhi.se/polopoly_fs/1.126770!/havsomraden_2016_3.zip)
- [Lakes as points](https://www.smhi.se/polopoly_fs/1.126775!/Sj%C3%B6punkter_2016_3.zip)
- [Upstream water conditions for lakes and rivers](https://www.smhi.se/polopoly_fs/1.134092!/RW_LW_VARO_2016_3c.zip)
- [Upstream water conditions for coastal regions](https://www.smhi.se/polopoly_fs/1.134094!/CW_VARO_2016_3c.zip)

[Karttur´s GeoImagine Framework](https://karttur.github.io/setup-ide/)

[the EASE-Grid Projection](https://nsidc.org/ease/clone-ease-grid-projection-gt) by NSIDC

[hdf5_to_geotiff](https://github.com/Zepy1/satellite_analysis/blob/master/hdf5_2_geotiff.py) GitHub script for projecting SMAP layers in EASE-Grid 2
