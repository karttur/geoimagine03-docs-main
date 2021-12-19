---
layout: article
title: "Karttur's GeoImagine Framework:<br />Setup processes (setup_processes)<br />Part 1 Setup processes"
categories: setup
excerpt: "Setup the processes for Karttur's GeoImagine Framework"
previousurl: setup/setup-setup-db
nexturl: setup/setup-custom-system
tags:
 - addsubproc
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2020-12-02 T18:17:25.000Z'
modified: '2021-10-10 T18:17:25.000Z'
comments: true
share: true
---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>

## Introduction

This post demonstrates how to add the definition of processes to Karttur's GeoImagine Framework. The processes as such are not added, only the parameters required for running the processes are added to the database. Instead of running the setup described in this post, you can restore the complete Framework database, including process definitions, by [restoring or importing the default version of the postgres database](../setup-db-processes).

## Prerequisites

You must have the complete Spatial Data Integrated Development Environment (SPIDE) installed as described in the blog [Install and setup spatial data IDE](https://karttur.github.io/setup-ide/). Then you must also have [imported the Framework to <span class='app'>Eclipse</span>](../../putinplace/), or another Integrated Development Environment (IDE). You must also have [prepared a solution for how to link the Framework processes and the postgres database](../../prep/prep-dblink/).

## Framework processes

All functionalities of Karttur's GeoImagine Framework are called processes and operate based on parameters defined in the Framework database. Thus a process must be defined in the database before it can be used. Processes are grouped in roots, where a root is usually associated either with a typical class of functions (e.g. overlay, scalar, export), data sources (e.g Landsat, Sentinel, MODIS etc) or projection system.

If you followed the tutorial on how to [set up the database](../setup-setup-db/) one root group ([_manageprocess_](../../rootproc-manageprocess/)) and one process ([_addsubproc_](../../subprocess/subproc-addsubproc/)) were inserted in the database. This added the capability of defining all other processes.

Access to complete lists of both [root processes](../../rootprocesses/) and [sub processes](../../subprocesses/), or via the top menu.

## Python package setup_processes

The setup of processes is done from the special package [<span class='package'>setup_processes</span>](https://github.com/karttur/geoimagine03-setup_processes/). This package contains four <span class='file'>.py</span> files, the standard modules <span class='package'>\_\_init\_\_.py</span> and <span class='package'>version.py</span>, plus one main module and one process module:

- setup_process_main.py
- setup_process_process.py

The package also contains several subfolders. The package subfolder [<span class='file'>dbdoc</span>](https://github.com/karttur/geoimagine03-setup_processes/tree/main/dbdoc) contains all the core processes, whereas the other sub-folders (landsatdoc, modisdoc, regiondoc etc) contain thematic processes and default or template data related to different data source systems.

### Get the package

If you [cloned or imported the complete Framework](../../putinplace), you already have the <span class='package'>setup_processes</span> package in your <span class='app'>Eclipse</span> PyDev project. If you need to add the package, follow the instruction in the previous post on [setup_db](../setup-setup-db), download <span class='package'>setup_processes</span> package and create a sub-package also called <span class='package'>setup_processes</span> and drag the complete content of the download into that sub-package.

## setup_processes_main.py

From the module <span class='module'>setup\_process\_main.py</span> you install all the processes and also the projection systems and data required to run the Framework.

```
if __name__ == "__main__":

    '''
    This module should be run after the module setup_db when building the Karttur GeoImagine Framework.
    '''

    # Set the name of the productions db cluster
    # prodDB = 'YourProdDB' #'e.g. postgres or geoimagine
    prodDB = 'geoimagine'

    # Setupprocesses links to a text file defining Framework processes to define
    SetupProcesses(prodDB)

    # SetupDefaultRegions starts a subroutine with different region processing
    SetupDefaultRegions(prodDB)

    # To setup custom projection and tiling systems, remove the comment
    #SetupCustomGrids(prodDB)

    # BackupDatabase creates a backup of the entire db in different formats
    #BackupDatabase(prodDB)

    exit(' REACHED THE END! ')
```

### Setup processes

In the main module, <span class='module'>setup\_process\_main.py</span>, you need to set the name of the production database that you created when you did [setup db](../setup-setup-db).

```
if __name__ == "__main__":

    ...

    # Set the name of the productions db cluster
    # prodDB = 'YourProdDB' #'e.g. postgres or geoimagine
    prodDB = 'geoimagine'

    ...

```

In the subroutine _SetupProcesses_ the path to the actual text file (<span class='file'>process\_karttur\_setup\_YYYYMMDD.txt</span>.) listing the json command files to execute is given. Edit the link if you created a new version of this text file.

```
def SetupProcesses(prodDB):
    ''' Setupprocesses links to a text file defining Framework processes to define
    '''

    relativepath = 'dbdoc'

    txtfilename = 'process_karttur_setup_20211108.txt'

    SetupProcessesRegions(relativepath, txtfilename, prodDB)
```

The json commands for setting up the Framework processes are linked via the text file <span class='file'>process_karttur_setup-ease-grid_YYYYMMDD.txt</span>. It contains a single json command file for setting up the tables for the systems _ease2n_ and _ease2s_.

The linked command files all have the element \"_overwrite_\" set to _false_ (see the post on [Json elements, variables and objects](../concept/concept-json-structure)). This means that no existing data or database record will be overwritten if it exists. You can thus rerun the command files without anything happening. Only if you make changes in the json commands and change \"_overwrite_\" to _true_ will any changes take effect.

<button id= "toggleprocesschain" onclick="hiddencode('processchain')">Hide/Show process_karttur_setup_YYYYMMDD.txt</button>

<div id="processchain" style="display:none">

{% capture text-capture %}
{% raw %}

\# Install periodicity processing used in all scripts handling actual spatial data
[periodicity_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-periodicity/)

\# Install user management processes
[manageuser_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-manageuser/)

\# Install project management processes
[manage_project_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-manage_project/)

\# Install region root and categories processes
[regions-root+categories_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-regions-root+categories/)

\# Install sub process DefaultRegionFromLonLat
[regions-DefaultRegionFromCoords_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-regions-DefaultRegionFromCoords/)

\# Install sub process TractFromVector & SiteFromVector
[regions_Tract+Site_FromVector_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-regions_Tract+Site_FromVector/)

\# Install sub process DefaultRegionFromVector
[regions_DefaultRegionFromVector_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-regions_DefaultRegionFromVector/)

\# Install processes for extracing tile corners
[regions_extract-tiles_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-regions_extract-tiles/)

\# Install processes for linking regions to tiles
[regions_links_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-regions_links/)

\# Install process for defining custom region
[regions_custom-define_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-regions_custom-define/)

\# Install ancillary root + OrganizeAncillary processing
[ancillary_root+organize_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-ancillary_root+organize/)

\# Install download processes for Tandem X data
[ancillary_tandemX-download_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-ancillary_tandemX-download/)

\# Install processes for mosaicking ancillary tile data
[ancillary_mosaic_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-ancillary_mosaic/)

\# Install processes mosaicking tiles
[mosaic_process_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-mosaic_process/)

\# Install processes for reproject between projection systems
[reproject_systemregion_process_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-reproject_systemregion_process/)

\# Install processes for DEM data using GDAL
[DEMGDALproc_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-DEMGDALproc/)

\# Install processes for DEM data using numpy
[DEMnumpyProc_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-DEMnumpyProc/)

\# Install processes for DEM data using GRASS GIS
[DEMgrassProc_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-DEMgrassProc/)

\# Install processes for retrieving hydrological basins from DEM
[BasinProcess_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-BasinProcess/)

\# Install process for extracting raster stats under vector data
[Extract_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-Extract/)

\# Install time series processing root and resample
[timeseriesprocesses_root-resample_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-timeseriesprocesses_root-resample/)

\# Install process for index time series cross trend analysis
[timeseriesprocesses_indexcrosstrend_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-timeseriesprocesses_indexcrosstrend/)

\# Install process for image time series cross trend analysis
[timeseriesprocesses_imagecrosstrend_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-timeseriesprocesses_imagecrosstrend/)

\# Install processes for filling gaps in time series data
[timeseriesprocesses_image-mend_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-timeseriesprocesses_image-mend/)

\# Install processes for extracting seasonal signals from time series data
[timeseriesprocesses_extractseason_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-timeseriesprocesses_extractseason/)

\# Installs processes for extracting min and max from time series data
[timeseriesprocesses_extract-min-max_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-timeseriesprocesses_extract-min-max/)

\# Install processes for time series decompositon
[timeseriesprocesses_decompose_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-timeseriesprocesses_decompose/)

\# Install processes for correlating lag times
[timeseriesprocesses_correlate-lags_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-timeseriesprocesses_correlate-lags/)

\# Install processes for time series autocorrelation
[timeseriesprocesses_autocorr_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-timeseriesprocesses_autocorr/)

\# Install processes for time series assimilation
[timeseriesprocesses_assimilate_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-timeseriesprocesses_assimilate/)

\# Installs processes for map layout
[layoutprocess_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-layoutprocess/)

\# Install root process for overlay
[overlay_root_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-overlay_root/)

\# Install process for averaging multiple images
[overlay_average_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-overlay_average/)

\# Install processes for bundling to GRASS GIS
[grassProcess_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-grassProcess/)

\# Install processes binding to GDAL translate
[translate_process_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-translate_process/)

\# Install processes for updating the database
[updateLayer_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-updateLayer/)

\# Install processes for exporting data as color byte binary images
[ExportToByte_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-ExportToByte/)

\#\# Install export processes for Zip backup
[ExportZip_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-ExportZip/)

\#\#  Install processes for exporting copies of data layers
[ExportCopy_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-ExportCopy/)

\# Install processes for searching, downloading and organising USGS data
[usgsProcess_root+search+download_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-usgsProcess_root+search+download/)

\# Install processes for searching, downloading and organising Copernicus data
[CopernicusProcess_root+search+download_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-CopernicusProcess_root+search+download/)

\# Install GRACE specific processing
[graceProcess_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-graceProcess/)

\# Install MODIS root process and the subprocesses for searching and downloading MODIS tiles
[modisProcess_root+search+download_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-modisProcess_root+search+download/)

\# Install MODIS specific processing
[modisProcess_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-modisProcess/)

\# Install search, download and organize processes for NSIDC MODIS data holdings
[modis_Polar_Process_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-modis_Polar_Process/)

\# Install MODIS processes for checking and updating the db and the local disk catalogue of MODIS data
[modisProcess_checkups_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-modisProcess_checkups/)

\# Install SMAP specific processing
[smapProcess_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-smapProcess/)

\# Install specific processes for sentinel data
[sentinelProcess_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-sentinelProcess/)

\# Install Database processes (export, import, dump etc )
[DbProc_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-DbProc/)

{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html toggle-text=text-capture  %}
</div>

### Setup regions

The [next post](../setup-custom-system/) deals with setting up the projection systems and defining regional extents.
