---
layout: post
title: Digital Elevation Models (DEMs)
categories: blog
datasource: dem
biophysical: geomorphology
excerpt: "Introduction and access to global Digital Elevation Models (DEMs)"
tags:
  - DEM
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2021-06-25 T18:17:25.000Z'
modified: '2021-06-25 T18:17:25.000Z'
comments: true
share: true
---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>

## Introduction

The term _Digital Elevation Model_ (DEM) is a generic, or superset, class of datasets depicting heights or elevations. Typically these heights can represent i) the Earth's (or any other sphere's) natural surface, ii) the height including objects on top of the surface, or iii) just the objects. The basic surface, without any objects is usually referred to as a _Digital Terrain Model_ (DTM), whereas height data including objects (whether natural objects like trees or man made like buildings) is usually called a _Digital Surface Model_ (DSM). Note, however, that the terminology I have used here is not universal. As long as you know what you want to use the DEM (as a generic term) for, the terms provide a hint, but better look in the metadata.

## Amazon Web Services Access

Different DEMs are of course available via different servers and connections. but at least some are available as Amazon Web Services (AWS) Open Data. To access registries on AWS Open Data I use the free [Amazon Web Services Command Line Interface 2 (AWSCLIV2)](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html). To install AWSCLIV2 on your machine you can check out [Installing, updating, and uninstalling the AWS CLI version 2](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html). Here is a summary of the steps needed for installation on MacOS:

1. start a <span class='app'>Terminal</span> session.

2. <span class='terminal'>$ curl \"https://awscli.amazonaws.com/AWSCLIV2.pkg\" -o \"AWSCLIV2.pkg\"</span>

3. <span class='terminal'>$ sudo installer -pkg AWSCLIV2.pkg -target /</span>

Give your machine password and the AWSCLIV2.pkg package should install and report back:

```
installer: Package name is AWS Command Line Interface
installer: Installing at base path /
installer: The install was successful.
```

## Global DEMs

There are a few different options if you are looking for a global DEM. Writing this post and working my way through different DEMs I came across [opentopography.org](https://opentopography.org/); an excellent source of both data and processing algorithms. But there are more alternatives available. The DEMs I retrieved and tested in March 2021 included the following:

- GMTED2010 (~250m or 7.5 arc-seconds)
- SRTM (90 m)
- TanDEM-X (90 m for free version)
- Copernicus DEM (30 or 90 m)
- ASTER DEM (30 m)
- ALOS DEM (30 m)
- Arctic DEM (2 m)
- PanArctic DEM (90 m)

[United Stated Naval Academy (USNA)](https://www.usna.edu) maintains an [up-to-date list of global DEMs](https://www.usna.edu/Users/oceano/pguth/md_help/html/global_dems.html). It contains some additional datasets not tested in this post.

### GMTED2010

The Global Multi-resolution Terrain Elevation Data (GMTED2010) was released in 2010 as a replacement for GTOPO30/HYDRO1K. It was jointly produced by the United Sates Geological Survey (USGS) and the National Geospatial-Intelligence Agency (NGA). GMTED2010 is not truly global in any other sense than all pixels having a valid number - but Greenland is then completely sunken below the sea surface. I do not know if other regions are similarly missing. GMTED2010 contains several estimates, including for mean, median, minimum and maximum elevation. GMTED2010 is freely available as tiles from [USGS](https://www.usgs.gov/core-science-systems/eros/coastal-changes-and-impacts/gmted2010?qt-science_support_page_related_con=0#qt-science_support_page_related_con), or as [global grids](https://topotools.cr.usgs.gov/gmted_viewer/gmted2010_global_grids.php). It is a bit easier to use Karttur's GeoImagine Framework (but not required). To use the Framework, first create a text file with the urls to the tiles of GMTED that you want to download, then call the process _DownloadAncillary_ with the parameter _downloadcode_ set to _filelist_ and the _path_ set to the actual file listing the tiles (under the _volume_ defined under _srcpath_).

<button id= "togglegmteddownload" onclick="hiddencode('gmteddownload')">Hide/Show GMTED download commands (json)</button>

<div id="gmteddownload" style="display:none">

{% capture text-capture %}
{% raw %}

```
{
  "userproject": {
    "userid": "karttur",
    "projectid": "karttur",
    "tractid": "karttur",
    "siteid": "*",
    "plotid": "*",
    "system": "ancillary"
  },
  "period": {
    "timestep": "static"
  },
  "process": [
    {
      "processid": "DownloadAncillary",
      "overwrite": false,
      "parameters": {
        "downloadcode": "filelist",
        "path": "GMTED2010/GMTED2010_tilelist.txt",
        "datadir": "RAWAUXILIARY/GMTED2010"
      },
      "srcpath": {
        "volume": "karttur"
      },
      "dstpath": {
        "volume": "karttur"
      }
    }
  ]
}
```
{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html  toggle-text=text-capture  %}
</div>

### TanDEM-X

[TanDEM-X](https://tandemx-science.dlr.de) (TerraSAR-X add-on for Digital Elevation Measurements) is an Earth observation radar mission that consists of a SAR interferometer built by two almost identical satellites flying in close formation. It is a product from the [Deutsches Zentrum für Luft- und Raumfahrt (DLR)](https://www.dlr.de/DE/Home/home_node.html). The original product at 12 m spatial resolution is not freely available. You can find a free 90 m [ellipsoid version with DLR](https://geoservice.dlr.de/web/dataguide/tdm90/) or [orthometric version in 30 or 90 m from the European Copernicus program](https://un-spider.org/news-and-events/news/copernicus-releases-30m-digital-elevation-model) or via [Amazon Web Services](https://registry.opendata.aws/copernicus-dem/). DLR also offers [other products derived from TanDEM-X](https://tandemx-science.dlr.de).

#### Accessing the DLR 90 TanDEM-X product

This product is a more raw ellipsoid of limited interest as cleaned up products are available via the [Copernicus program](https://www.copernicus.eu/en) (see next section). If you want to access the DLR 90 m ellipsoid product you first need to [register with DLR self service](https://sso.eoc.dlr.de/tdm90/selfservice/). I opted for using [aria2](https://aria2.github.io) that I installed for MacOS using [Homebrew](https://formulae.brew.sh/formula/aria2):

<span class='terminal'>$ brew install aria2</span>

I got the list of all available TanDEM-X tiles from [https://github.com/justinelliotmeyers/TanDEM-X_GRID_INDEX](https://github.com/justinelliotmeyers/TanDEM-X_GRID_INDEX). I then extracted the url's of all the tiles I wanted to a simple list:

```
https://download.geoservice.dlr.de/TDM90/files/N14/E020/TDM1_DEM__30_N14E028.zip
https://download.geoservice.dlr.de/TDM90/files/N14/E020/TDM1_DEM__30_N14E026.zip
https://download.geoservice.dlr.de/TDM90/files/N14/E020/TDM1_DEM__30_N14E029.zip
...
```

The list above can be constructed from the json file available at [https://github.com/justinelliotmeyers/TanDEM-X_GRID_INDEX](https://github.com/justinelliotmeyers/TanDEM-X_GRID_INDEX), and I added a process, _SearchJsonTandemX_, to the Framework that does this automatically.

<button id= "toggletandemxjsonsearch" onclick="hiddencode('tandemxjson')">Hide/Show TanDEM-X download url search (json)</button>

<div id="tandemxjson" style="display:none">

{% capture text-capture %}
{% raw %}

```
{
  "userproject": {
    "userid": "karttur",
    "projectid": "karttur",
    "tractid": "karttur",
    "siteid": "*",
    "plotid": "*",
    "system": "ancillary"
  },
  "period": {
    "timestep": "static"
  },
  "process": [
    {
      "processid": "SearchJsonTandemX",
      "dsversion": "1.3",
      "parameters": {
        "path": "/Volumes/Ancillary/DOWNLOADS/tdm90/tandem-X_grid.json",
        "datadir": "RAWAUXILIARY/TDM90",
        "username": "username",
        "password": "password",
        "minlon": -180,
        "maxlon": 180,
        "minlat": -90,
        "maxlat": 90
      },
      "srcpath": {
        "volume": "Ancillary"
      },
      "dstpath": {
        "volume": "Ancillary"
      }
    }
  ]
}
```
{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html  toggle-text=text-capture  %}
</div>

Then just add the file with listed url's and your credentials, start a <span class='app'>Terminal</span> session, <span class='terminalapp'>cd</span> to the folder with the <span class='file'>listfile.txt</span>, and [aria2](https://aria2.github.io) will get all the tiles downloaded really quick:

<span class='terminal'>$ aria2c -i \"listfile.txt\" --http-user \"username\" --http-passwd \"password\"</span>

The downloaded tiles are zip files with quite a lot more content than the DEM tiles. You can use the Framework process _UnZipTandemX_ to explode only the DEM data.

<button id= "toggletandemxunzip" onclick="hiddencode('tandemxunzip')">Hide/Show TanDEM-X unzip command (json)</button>

<div id="tandemxunzip" style="display:none">

{% capture text-capture %}
{% raw %}

```
{
  "userproject": {
    "userid": "karttur",
    "projectid": "karttur",
    "tractid": "karttur",
    "siteid": "*",
    "plotid": "*",
    "system": "ancillary"
  },
  "period": {
    "timestep": "static"
  },
  "process": [
    {
      "processid": "UnZipTandemX",
      "dsversion": "1.3",
      "parameters": {
        "path": "/Volumes/Ancillary/DOWNLOADS/tdm90/tandem-X_grid.json",
        "datadir": "RAWAUXILIARY/TDM90",
        "minlon": -180,
        "maxlon": 180,
        "minlat": -90,
        "maxlat": 90
      },
      "srcpath": {
        "volume": "Ancillary"
      },
      "dstpath": {
        "volume": "Ancillary"
      }
    }
  ]
}
```
{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html  toggle-text=text-capture  %}
</div>

#### Accessing the Copernicus DEM

Copernicus DEM is based on TanDEM-X and then infilled on a local basis with the following DEMs: ASTER, SRTM90, SRTM30, SRTM30plus, GMTED2010, TerraSAR-X Radargrammetric DEM, ALOS World 3D-30m. Copernicus DEM is available in two versions: COPERNICUS_30 and COPERNICUS_90.

The 90 m Copernicus DEM product is freely available at [https://gisco-services.ec.europa.eu/dem/copernicus/outD/](https://gisco-services.ec.europa.eu/dem/copernicus/outD/) or with [Amazon Web Services (AWS)](https://registry.opendata.aws/copernicus-dem/). Downloading from the former is more complicated and is done using a file listing urls and [aria2](https://aria2.github.io) as described in the previous section. The post on [Mosaic, import and tile CopDEM](../blog-COPDemMosaicRaw) covers the details on how to access this particular version of Copernicus DEM.

Access via AWS is easier. If you installed [Amazon Web Services Command Line Interface 2 (AWSCLIV2)](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html) as outlined above, the access point [Open Data AWS Copernicus Digital Elevation Model (DEM)](https://registry.opendata.aws/copernicus-dem/) describes the data access. To download the complete global dataset all you need to do is to execute the following command:

<span class='terminal'>$ aws s3 cp s3://copernicus-dem-90m/ . --recursive --no-sign-request</span>

Also the Copernicus DEM 30 m product is freely accessible via [AWS Open Data](https://registry.opendata.aws/copernicus-dem/), with the following "one-liner" downloading the complete global dataset:

<span class='terminal'>$ aws s3 cp s3://copernicus-dem-30m/ . --recursive --no-sign-request</span>

Alternatively you can register with [Copernicus PANDA](https://panda.copernicus.eu). When writing this, the services had had a major crash and was not available for registering. Thus I did not test that alternative.

### ASTER DEM

[ASTER Global Digital Elevation Map (DEM) - ASTERDEM](https://asterweb.jpl.nasa.gov/gdem.asp) is produced from stereo pairs of optical images over the same area but taken at different angles. At the time of writing this in March 2021, the latest version is the ASTER Global Digital Elevation Model Version 3 released August 5 2019. GDEM V3 adds additional stereo-pairs, improving coverage and reducing the occurrence of artifacts. The refined production algorithm provides improved spatial resolution, increased horizontal and vertical accuracy. The ASTER GDEM V3 has a spatial resolution of 30 m and is available as 1 x 1 degree tiles.

ASTERDEM is available from [NASA Eartdata](https://search.earthdata.nasa.gov/search/granules?p=C1711961296-LPCLOUD&pg[0][gsk]=-start_date&fi=ASTER&tl=1600669251!4!!&m=-0.0703125!0.140625!2!1!0!0%2C2), with the direct link [https://e4ftl01.cr.usgs.gov/ASTER_B/ASTT/](https://e4ftl01.cr.usgs.gov/ASTER_B/ASTT/). For downloading ASTER DEM I use Karttur's GeoImagine Framework. Basically that boils down to exactly the same procedure with a file listing the url's of all tiles you want to download and executing an <span class='terminalapp'>araia2</span> command, as described for accessing the DLR 90 TanDEM-X product. But instead of searching a local file for urls, you need to go online to the server holding the ASTER DEM. You have to have a registered user with [Earthdata](https://urs.earthdata.nasa.gov), then you can run the Framework processes _SearchUSGSProducts_ and _DownloadUSGS_ to create the list of urls to download. Once you have the lists, just use <span class='terminalapp'>araia2</span> (even if this can be done via the Framework it is better to just run <span class='terminalapp'>araia2</span>).

<button id= "toggleaseterdemsearch" onclick="hiddencode('asterdemsearch')">Hide/Show Search online ASTER DEM tiles (json)</button>

<div id="asterdemsearch" style="display:none">

{% capture text-capture %}
{% raw %}

```
{
  "userproject": {
    "userid": "karttur",
    "projectid": "karttur",
    "tractid": "karttur",
    "siteid": "*",
    "plotid": "*",
    "system": "system"
  },
  "period": {
    "startyear": 2000,
    "endyear": 2000,
    "startmonth": 3,
    "endmonth": 3,
    "startday": 1,
    "endday": 1,
    "timestep": "singledate"
  },
  "process": [
    {
      "processid": "SearchUSGSProducts",
      "dsversion": "1.3",
      "parameters": {
        "remoteuser": "username",
        "product": "ASTGTM",
        "version": "003",
        "doneserach": true,
        "serverurl": "https://e4ftl01.cr.usgs.gov"
      },
      "srcpath": {
        "volume": "karttur"
      },
      "dstpath": {
        "volume": "karttur"
      }
    }
  ]
}
```
{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html  toggle-text=text-capture  %}
</div>


<button id= "toggleasterdemdoenload" onclick="hiddencode('asterdemdownload')">Hide/Show Crete download list for ASTER DEM (json)</button>

<div id="asterdemdownload" style="display:none">

{% capture text-capture %}
{% raw %}
{
  "userproject": {
    "userid": "karttur",
    "projectid": "karttur",
    "tractid": "karttur",
    "siteid": "*",
    "plotid": "*",
    "system": "system"
  },
  "period": {
    "startyear": 2000,
    "endyear": 2000,
    "startmonth": 3,
    "endmonth": 3,
    "startday": 1,
    "endday": 1,
    "timestep": "singledate"
  },
  "process": [
    {
      "processid": "DownloadUSGS",
      "dsversion": "1.3",
      "parameters": {
        "remoteuser": "remoteuser",
        "password": "password",
        "product": "ASTGTM",
        "version": "003",
        "doneserach": true,
        "serverurl": "https://e4ftl01.cr.usgs.gov"
      },
      "srcpath": {
        "volume": "Ancillary"
      },
      "dstpath": {
        "volume": "Ancillary"
      }
    }
  ]
}
{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html  toggle-text=text-capture  %}
</div>

### ALOS World 3D - 30m (AW3D30)

The Japan Aerospace Exploration Agency(JAXA) Advanced Land Observing Satellite (ALOS) Global Digital Surface Model ["ALOS World 3D - 30m (AW3D30)"](https://www.eorc.jaxa.jp/ALOS/en/aw3d30/index.htm) is a 30 m global DEM that is freely available both from [JAXA](https://www.eorc.jaxa.jp/ALOS/en/aw3d30/data/index.htm) and [opentopography.org](https://opentopography.org/).

To access AW3D30 from Japan you must first to [register with JAXA](https://www.eorc.jaxa.jp/ALOS/en/aw3d30/registration.htm). With [opentopography.org](https://opentopography.org/) you can bulk download the complete world using [Amazon Web Services Command Line Interface 2 (AWSCLIV2)](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-mac.html#cliv2-mac-install-cmd) without registering. The latter alternative is outlined in the next section (see the article [Experiments with the global JAXA ALOS World 30m elevation model on AWS S3](https://kokoalberti.com/articles/experiments-with-the-global-jaxa-alos-world-30m-dem-on-aws-s3/) by @kokoalberti).

#### Bulk access AW3D30 via OpenTopography

Navigate to[OpenTopography ALOS World 3D - 30m](https://portal.opentopography.org/raster?opentopoID=OTALOS.112016.4326.2) to get basin metadata and download instructions for AW3D30. If you just want to get the data you can also follow the cheat-sheet outlined here.

List all the tiles:

<span class='terminal'>$ aws s3 ls s3://raster/AW3D30/ --recursive --endpoint-url https://opentopography.s3.sdsc.edu --no-sign-request</span>

Pipe tiles to csv file:

<span class='terminal'>$ aws s3 ls s3://raster/AW3D30/ --recursive --endpoint-url https://opentopography.s3.sdsc.edu --no-sign-request \> AW3D30_tiles.csv</span>

Download all the tiles (to the present directory):

<span class='terminal'>aws s3 cp s3://raster/AW3D30/ . --recursive --endpoint-url https://opentopography.s3.sdsc.edu --no-sign-request</span>

### Regional DEM

### Shuttle Radar Topography Mission (SRTM)

The Shuttle Radar Topography Mission (SRTM) obtained elevation data on a near-global scale to generate the most complete high-resolution digital topographic database of Earth. SRTM consisted of a specially modified radar system that flew onboard the Space Shuttle Endeavour during an 11-day mission in February of 2000. SRTM is an international project spearheaded by the National Geospatial-Intelligence Agency (NGA) and the National Aeronautics and Space Administration (NASA).

SRTM is available in (at least) 30, 90 at 500 m spatial resolution. The SRTM data al stem from a Space Shuttle flight in 2000.

#### SRTM GL1 and GL3

The 1 arc sec (~30 m) product is available in two version; 1 and 3. In version 3 voids are filled in using primarily ASTERDEM. SRTMGL1v003 is available both from [USGS](https://lpdaac.usgs.gov/products/srtmgl1v003/) and [OpenTopography](https://portal.opentopography.org/datasetMetadata?otCollectionID=OT.042013.4326.1). The download procedures for data holding on both USGS servers and the OpenTopography are outlined above. SRTM does not cover regions above 60 degrees latitude.

#### SRTM15Plus

[SRTM15Plus](https://topex.ucsd.edu/WWW_html/srtm15_plus.html) is a global topography and bathymetry grid at 15 Arc Sec (~500 m) spatial resolution. The dataset was published in March 2019.

SRTM15Plus is available from  [OpenTopography](https://portal.opentopography.org/datasetMetadata?otCollectionID=OT.122019.4326.1).

### Arctic DEM

[ArcticDEM](https://www.pgc.umn.edu/data/arcticdem/) is an incomplete attempt to create a very high resolution (2 m spatial resolution) circumpolar DEM over the Arctic region. The work has been led by the United States National Geospatial-Intelligence Agency (NGA) and the National Science Foundation (NSF). The DEM is created from optical stereo imagery and open source photogrammetry software. It covers all land areas north of 60 degrees, all territory of Greenland, the State of Alaska in entirety, and the Kamchatka Peninsula of the Russian Federation. [ArticDEM](https://www.pgc.umn.edu/data/arcticdem/) is freely available from [GRACE TELLUS](http://data.pgc.umn.edu/elev/dem/setsm/ArcticDEM).

### PanArctic DEM

PanarcticDEM is a circumpolar digital elevation models > 55° N, available from [PANGEA](https://doi.pangaea.de/10.1594/PANGAEA.779748). It is in 90 m spatial resolution and compiled from different sources over different regions, including topographic contours over large parts of Russia. It is freely available and can be downloaded in 3 pieces. PanarcticDEM is not complete.
