---
layout: post
title: GRACE
categories: blog
datasource: grace
biophysical: soilwater
index:
  - gravity
  - soil moisture content
  - glacier ice mass
excerpt: "Processing GRACE data using Karttur's GeoImagine Framework"
tags:
  - GRACE
  - process chain
  - organizegrace
  - mendancillarytimeseries
  - average3ancillarytimeseries
  - monthdaytomonth
  - extractseasonancillary
  - resampletsancillary
  - trendtsancillary
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2021-06-01 T18:17:25.000Z'
modified: '2021-06-01 T18:17:25.000Z'
comments: true
share: true

figure1: avg-grace-ave_cmwater_global_2003-2016_RL05-f-A

GRACE-0101_organize: GRACE-0101_organize
GRACE-0111_mendts: GRACE-0111_mendts
GRACE-0115_average: GRACE-0115_average
GRACE-0120_monthdaytomonth: GRACE-0120_monthdaytomonth
GRACE-0190_updatedb: GRACE-0190_updatedb
GRACE-0231_extract-season: GRACE-0231_extract-season
GRACE-0290_resample-2-annual: GRACE-0290_resample-2-annual
GRACE-0310_trend_A_2003-2016: GRACE-0310_trend_A_2003-2016
GRACE-0320_changes_A_2003-2016: GRACE-0320_changes_A_2003-2016
---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>

# Introduction

This post presents a processing chain for organizing, analyzing and presenting data from [Gravity Recovery and Climate Experiment (GRACE)](https://grace.jpl.nasa.gov) mission in Karttur's GeoImagine Framework.

<figure>
<img src="{{ site.commonurl }}/images/{{ site.data.images[page.figure1].file }}">
<figcaption> {{ site.data.images[page.figure1].caption }} </figcaption>
</figure>

# Prerequisites

You must have the complete SPIDE installed as described in the blog [Install and setup spatial data IDE](https://karttur.github.io/setup-ide/). You must have [imported Karttur's GeoImagine Framework](../../putinplace/). The Framework [postgres database must be setup](../../setup/setup-setup-db/) and the [processes defined](../../setup/setup-setup-processes/).

# GRACE

GRACE was built around two identical satellites orbiting the Earth and was operational from 2003 to 2017. Traveling with a fixed distance in between them the gravitational pull caused minute changes in the vertical elevation difference between the two satellites. This change can be used for estimating the gravitational pull. Short term (days to months) changes in the gravitation over land is primarily related to the Earth's water reservoirs, earthquakes and crustal deformations.

This tutorial makes use of GRACE TELLUS [Level-3 data grids of monthly surface mass changes](https://grace.jpl.nasa.gov/data/monthly-mass-grids/) to detect trends in water storage on land. This GRACE data represent the changes in equivalent water thickness relative to a (time-mean) baseline. There are three different solutions for the calculations of equivalent water thickness, respectively produced by CSR (Center for Space Research at University of Texas, Austin), GFZ (GeoforschungsZentrum Potsdam) and JPL (Jet Propulsion Laboratory). You can use any of these solutions, but the official recommendation is that [users obtain all three data center's solutions (JPL, CSR, GFZ) and simply average them](https://grace.jpl.nasa.gov/data/choosing-a-solution/).

## Python Package

The GeoImagine Framework includes a specific package for GRACE processing: <span class='package'>[grace](https://github.com/karttur/grace/)</span>. Note that also several other packages in the Framework are needed for repeating the steps below.

## Project module

The project module file (<span class='file'>projGRACE.py</span>) is available in the <span class='package'>Project</span> package [projects](https://github.com/karttur/geoimagine-projects/).

<button id= "toggleprojfile" onclick="hiddencode('projfile')">Hide/Show projGRACE.py</button>

<div id="projfile" style="display:none">

{% capture text-capture %}
{% raw %}

```
from geoimagine.kartturmain.readXMLprocesses import ReadXMLProcesses, RunProcesses

if __name__ == "__main__":

    verbose = True

    projFN ='doc/GRACE/grace_YYYYMMDD.txt'

    procLL = ReadXMLProcesses(projFN,verbose)

    RunProcesses(procLL,verbose)
```

{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html  toggle-text=text-capture  %}
</div>

### Process chain

The project file links to an ASCII text file that contains a list of the xml files to execute.

```
projFN ='doc/GRACE/grace_20181018_0.txt'
```

As the path to the project file does **not** start with a slash "/", the path must be relative to the project module itself. The [project package available on Karttur's GitHub page](../../../geoimagine-projects) contains the path and the files required for running the process chain. Both the text file and the xml files are available under the subfolder [<span class='file'>doc/GRACE</span>](../../../geoimagine-projects/doc/GRACE).

<button id= "toggleProcessChain" onclick="hiddencode('ProcessChain')">Hide/Show grace_YYYYMMDD.txt</button>

<div id="ProcessChain" style="display:none">
{% capture text-capture %}
{% raw %}

```
###################################
###################################
###            GRACE            ###
###################################
###################################

###################################
###     Download & organize     ###
###################################

## The GRACE mission is finished and the data must be
## manually searched and downloaded as described in the
## SMAP blogpost: https://karttur.github.io/geoimagine/blog/blog-SMAP/

## Organize the downloaded GRACE data ##
#GRACE-0101_organize.xml

## Mend GRACE by interpolating missing dates ##
#GRACE-0111_mendts.xml

## Average the three GRACE solutions ##
#GRACE-0115_average.xml

## Convert month format to karttur standard ##
#GRACE-0120_monthdaytomonth.xml

## Alternative import pre-processed GRACE data and update db ##
#GRACE-0190_updatedb.xml

###################################
###   Time series processing    ###
###################################

## Extract GRACE seasonal signal ##
#GRACE-0231_extract-season.xml

## Resample Grace to Annual ##
GRACE-0290_resample-2-annual.xml

## Estimate trend from annual timestep ##
#GRACE-0310_trend_A_2003-2016.xml

## Calculate annual changes 2003 t0 2016 ##
#GRACE-0320_changes_A_2003-2016.xml

```
{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html  toggle-text=text-capture  %}
</div>

#### Python package

https://pypi.org/project/ggtools/

conda install cartopy netcdf4 h5py
pip install ggtools


Upgrade to latest version:

pip install ggtools --upgrade.

#### Import pre-processed GRACE data and update db

If you already got access to GRACE data produced with Karttur´s GeoImagine Framework you can use the process <span class='package'>updatedb</span> to import the data to your Framework.

{% capture foo %}{{page.GRACE-0190_updatedb}}{% endcapture %}
{% include xml/GRACE-0190_updatedb.html foo=foo %}

In the example above the imported layers represent the nodata-filled and averages solution for mm water pillar. The next step with this import would then be the time series processing.

## Download & organize

THe GRACE data is freely available from [GRACE TELLUS](https://grace.jpl.nasa.gov/data/get-data/). The data are available through ftp, and the dataset is small and the experiment finished. The easiest way to download the data is to use an FTP client (for example [Filezilla](https://filezilla-project.org)).

The data can be downloaded as NetCDF files, as GeoTIFF images and as ASCII text files. Karttur's GeoImagine Framework can import any of these formats, but the specific GRACE importer that solves the projection of the GRACE data on the fly use the ASCII data as input. When downloading the data, make sure to keep the same folder structure as the online resource (this is how the import process expects the data).

### New system

Attempting to download the data in February 2021, there are several options, but none as easy and straight forward as the old system. The options available include:

- https://podaac-tools.jpl.nasa.gov
-

Tools for accessing inlcude

- https://github.com/jgte/grace-data
- ggtols (python package) https://pypi.org/project/ggtools/


https://github.com/jgte/grace-data

#### podaac

Requires that you have an Earthdata account. Note, however, that your password for poddac is automatically genreated for you and differs from your ordinary Earthdata login password.


### Suggested datasets

Go to https://grace.jpl.nasa.gov/data/get-data/

[Monthly Mass Grids - Global mascons (JPL RL06_v02)](https://grace.jpl.nasa.gov/data/get-data/jpl_global_mascons/) The best option direct [Direct data access](https://podaac-opendap.jpl.nasa.gov/opendap/allData/tellus/L3/mascon/RL06/JPL/v02/CRI/netcdf/).

[GRACE Monthly Mass Grids - Land](#)

The three solutions, datasets February 2021:
[RL05.DSTvSCS1409] for GFZ, CSR; [RL05.DSTvSCS1411] for JPL;


The three solutions

https://podaac-tools.jpl.nasa.gov/drive/files/allData/tellus/L3/grace/land_mass/RL06/v03

 JPL

https://podaac-tools.jpl.nasa.gov/drive/files/allData/tellus/L3/grace/land_mass/RL06/v03/CSR

 https://podaac-opendap.jpl.nasa.gov/opendap/allData/tellus/L3/grace/land_mass/RL06/v03/CSR/


 #### The most complete?

 https://podaac-opendap.jpl.nasa.gov/opendap/allData/tellus/L3/mascon/RL06/JPL/v02/non-CRI/netcdf/GRCTellus.JPL.200204_202011.GLO.RL06M.MSCNv02.nc.html

 GRCTellus.JPL.200204_202011.GLO.RL06M.MSCNv02.nc

### Download using macos and Finder

PO.DAAC Drive supports Mac OS X 10.9 and higher.

From the <span class='app'>Finder</span>, click Go/Connect to Server, or press ⌘-K. In the window that appears, enter the following under Server Address: https://podaac-tools.jpl.nasa.gov/drive/files

Click Connect.

When prompted to log in, use your URS _username_ and WebDAV _password_.

You can now browse PODAAC files with the <span class='app'>Finder</span> and copy them to your computer just as you would with a local hard drive. It's best to copy a file to your computer before opening it.

To disconnect, drag the drive into the Trash or right-click it and select Eject.

Similar connection options also exist for Windows and Linux platforms.

### Organizing the dataset

The GRACE dataset available online is not projected in the usual manner; the left edge starts at the Greenwich Meridian and then extends eastwards. It wraps the dateline and the last column again ends at the Greenwich Meridian. To solve the projection on the fly when organizing GRACE data, use the process [<span class='package'>OrganizeGrace</span>](../../subprocess/subproc-organizegrace/) (only works on the ASCII data). This process is a subclass to [<span class='package'>OrganizeAncillary</span>](../../subprocess/subproc-organizeancillary/), and uses the same xml structure:

{% capture foo %}{{page.GRACE-0101_organize}}{% endcapture %}
{% include xml/GRACE-0101_organize.html foo=foo %}

The process [<span class='package'>OrganizeGrace</span>](../../subprocess/subproc-organizegrace/) translates the raw GRACE data to organized and projected GeoTIFF layers. The xml does not define the layers explicitly. Like for all processes, the spatial data is defined by a _compositon_ object, a region (_tract_, _site_ or _plot_) and a time span inculding a temporal resolution. When the process is exectuted the layers are constructed from a compostion, a loaction and a time stamp.

In the xml above, the region is defined by the _tract_:

```
tractid= 'karttur'
```

Where the _tractid_ _karttur_ is the default superuser owned tract representing global extent (see [this](../setup-xml/) post for details).

The time span and the temporal resolution is defined in the \<period\> tag:

```
<period timestep='allscenes'></period>
```

The _timestep_ parameter _allscenes_ only works for some processes; for GRACE data it searches the source data for all available data found under the import path.

The composition is completely defined by the following tag:

```
source = "NASA-GRACE" product = "jpl-cmwater" folder = "cmwater" band = "grace-jpl" prefix = "grace-jpl" suffix = "RL05" scalefac = "1" offsetadd = "0" dataunit = "cm" celltype = 'Float32' cellnull = '32767' measure ='R' masked='Y'
```

You can change the composition definition to anything you want, but you must define all parameters.

If you want to use all the solutions for equivalent water thickness (CST, GFZ and JPL) you have to define three import processes (can be done in the same xml file).

### Filling missing data

The GRACE monthly dataset of equivalent water thickness has some gaps. The process [<span class='package'>mendancillarytimeseries</span>](../../subprocess/subproc-mendancillarytimeseries/) fills the gaps. The default method for filling data is linear interpolation. Note that the \<srccomp\> tag in the xml below is identical to the  \<dstcomp\> tag in the xml defining the import (above). In the xml file below also the time period and the temporal resolution are explicitly defined.

{% capture foo %}{{page.GRACE-0111_mendts}}{% endcapture %}
{% include xml/GRACE-0111_mendts.html foo=foo %}

### Average solutions

As note above, the recommendation is to use the average of the three solutions for the monthly equivalent water depth (CSR, GFZ and JPL). The process [<span class='package'>average3ancillarytimeseries</span>](../../subprocess/subproc-average3ancillarytimeseries/) will do this for you. You must have imported and filled all three solutions (the process source datasets).

{% capture foo %}{{page.GRACE-0115_average}}{% endcapture %}
{% include xml/GRACE-0115_average.html foo=foo %}

### Convert date format

The date format of the downloaded GRACE data is YYYYMM01, where YYYY is the year and MM the month. The data, however, does not represent the 1st day of the denoted month but the average for the whole month. In Karttur´s GeoImagine Framework, data representing a month is given as YYYYMM ([see this post](https://karttur.github.io/geoimagine/blog/blog-xml/)). The process [<span class='package'>monthdaytomonth</span>](../../subprocess/subproc-monthdaytomonth/) converts the GRACE data date format to the Framework standard.

{% capture foo %}{{page.GRACE-0120_monthdaytomonth}}{% endcapture %}
{% include xml/GRACE-0120_monthdaytomonth.html foo=foo %}

## Time series proessing

### Seasonal signal extraction

The process [<span class='package'>extractseasonancillary</span>](../../subprocess/subproc-extractseasonancillary/) extracts the seasonal mean for each season in the dataset (monthly periods for the GRACE data). This process is not needed for the analysis of the GRACE data as done in this post.

{% capture foo %}{{page.GRACE-0231_extract-season}}{% endcapture %}
{% include xml/GRACE-0231_extract-season.html foo=foo %}

### Resample temporal resolution

In this example we are just going to look at the annual changes in water equivalent depth using the GRACE data. To do that you must resample the monthly data to an annual signal. The process for this is [<span class='package'>resampletsancillary</span>](../../subprocess/subproc-resampletsancillary/)

For the GRACE data, that describes the relative change, it does not really matter if you resample using the average annual signal or sum up the monthly signals to an annual sum. In the example I have resampled to annual average.

{% capture foo %}{{page.GRACE-0290_resample-2-annual}}{% endcapture %}
{% include xml/GRACE-0290_resample-2-annual.html foo=foo %}

### Trend estimation

In this example the trend of the changes in equivalent water thickness will be done using the annual average GRACE data. The process for this is [<span class='package'>trendtsancillary</span>](../../subprocess/subproc-trendtsancillary/). At time of writing, it can use two different linear methods for estimating the trend: Ordinarly Least Sqaure (OLS) and Theil-Sen (TS). For determining the significance of the change in the linear trend the process uses the Mann-Kendall (MK) test. The script is set up so that you just state _ols_ or _mk_ (or both), the additional analysis follow along. With _ols_ given you also get the random mean square error ('rmse') and the correlations coefficient ('r2'), and with _mk_ you get the TS regression (median and at 95 % confidence limits for upper and lower change). The script can also calculate the long term average and standard deviations. The xml parameters below generate all the output options presently available:

{% capture foo %}{{page.GRACE-0310_trend_A_2003-2016}}{% endcapture %}
{% include xml/GRACE-0310_trend_A_2003-2016.html foo=foo %}

### Significant changes and trends

The process [<span class='package'>signiftrendsancillary</span>](../../subprocess/subproc-signiftrendsancillary/) combines the MK test with the TS slope and estimates the absolute changes over the defined period. Two layers are produced, one showing the changes for all areas, and one showing only areas with statistically significant changes.

{% capture foo %}{{page.GRACE-0320_changes_A_2003-2016}}{% endcapture %}
{% include xml/GRACE-0320_changes_A_2003-2016.html foo=foo %}

The [next](../blog-GRACE-layout) post covers how to define palettes and scaling for the GRACE data and then export the data as media files.

# Resources

[GRACE data on Planet OS](https://data.planetos.com/datasets/nasa_grctellus_land)

[Gravity Recovery and Climate Experiment (GRACE)](https://podaac.jpl.nasa.gov/GRACE?tab=mission-objectives&sections=about%2Bdata) at Jet Propulsion Laboratory, including listing all valauilable datasets.

[PO.DAAC Drive](https://podaac-tools.jpl.nasa.gov/drive/files/allData/tellus/L3/grace/land_mass/RL06/v03/CSR)
[Monthly Mass Grids - Land](https://grace.jpl.nasa.gov/data/get-data/monthly-mass-grids-land/)

[
JPL GRACE and GRACE-FO Mascon Ocean, Ice, and Hydrology Equivalent Water Height JPL Release 06 Version 02][https://podaac.jpl.nasa.gov/dataset/TELLUS_GRAC-GRFO_MASCON_GRID_RL06_V2]
