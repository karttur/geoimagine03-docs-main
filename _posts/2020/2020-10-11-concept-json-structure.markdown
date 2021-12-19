---
layout: article
title: Json elements, variables and objects
categories: concept
tutorial: null
excerpt: "Json command file structure."
tags:
  - processes
  - compositions
  - json
  - parameters
  - srcpath
  - dstpath
  - srccomp
  - dstcomp
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2020-10-01 T18:17:25.000Z'
modified: '2020-11-01 T18:17:25.000Z'
comments: true
share: true
---

## Introduction

Karttur's GeoImagine Framework is built with object oriented classes and methods. The object oriented concept in programming means that all items belong to a class. Items belonging to a certain class have both properties (or attributes) and methods (processes or functions) associated with that class. In the Framework the most important objects are functions (called **processes**) and spatial data collections (called **compositions**).  The parameterization of processes and compositions is encoded in JavaScript Object Notation (json) files. This post first summarizes the concepts of **processes** and **compositions** and then explains how this is translated to json structured codes.

## Default vs Custom


## Json elements

### Database

###

All functionalities of the Framework are encoded in object oriented processes. Most processes operate on spatial data, but not all; processes are also used for building and managing the database and setting up the processes themselves.

Most processes, however, do use spatial data either as input (or source [src] data) and/or output (or destination [dst] data). Source data is usually denoted with the abbreviation _src_ and destination data with _dst_. All data, regardless of type, belong to a composition.

## Processes

There are hundreds of different processes defined within the Framework. You can get a list of all available processes from the top menu item [sub processes](../../subprocesses/).

Processes can be regarded as high level Geographic Information System (GIS) functions. The more basic processes are in fact nothing else than interfaces to standard GIS functions. Other processes represent sequences of standard GIS functions. And then there are functions, including for modeling and machine learning, that can not be found in standard GIS software packages. Compared to an ordinary GIS software package (e.g. ArcGIS, SAGA, QGIS, GRASS etc), Karttur´s GeoImagine Framework is much more demanding to learn and operate when starting,. But once you understand the Framework and have gained knowledge about the Python packages you use, you can add any spatial process you can think of. Another advantage with the Framework is that you can combine any number of processes and then run them for data over any region, or the entire Earth, in one go.

## Compositions

A composition can be a single file, like the map of global countries, or thousands of files, like the red reflectance of tiles from the Moderate Resolution Imaging Spectroradiometer (MODIS) satellite sensor. When asking the Framework to do processes that involve data, the composition(s) to use must be stated. The processing will be done for all compositions falling within the defined spatial and temporal domain (this will become clear further down).

All compositions have an _id_ that is composed of two parts, a thematic part and a content part, separated by an underscore:

**theme_content**

Neither the theme, nor the content are allowed to contain any underscore themselves.  Each composition _id_ is linked to a scale factor (_scalefac_), an offset add factor (_offsetadd_)   a pre-defined numeric type (_celltype_ [.e.g  Byte, Int16, UInt16 etc]) a nodata value (_cellnull_), a data unit (_dataunit_), and must have a scale _measure_ (_n_[ominal], _o_[rdinal], _i_[nterval)] or _r_[atio]).

A composition can contain different products as long as the _scalefac_, _offsetadd_, _celltype_, _cellnull_, _dataunit_  and _measure_ are identical. This means that two versions of the same data, for example derived with a slightly different algorithmic definition, can belong to the same composition. Also reflectance bands from different sensors can share the same composition, as can rainfall data from different sources. But normally data from different origins or sensors are also represented as different compositions. All compositions are identified by six (6) different attributes (these properties then define the folder hierarchy and dataset file naming - explained further down):

- source
- product
- theme
- layerid
- prefix
- suffix

The _source_ is the origin of the dataset from which the composition is derived or extracted (e.g. the satellite platform, the organization or individual behind the data), _product_ is usually a coded product identifier or the producer, _theme_ is a thematic identifier (the "theme" part of the compid introduced above), _layerid_ is a content identifier with _prefix_ usually identical to _layerid_ but can be set differently, and _suffix_ is a more loose part that can be freely set but usually represents a version identifier.

Compositions as such do not relate to any spatial extent or temporal validity.

## Composition datasets

While the composition as such does not entail any spatial data, all spatial data must belong to one, and only one, composition. All datasets that belong to a specific composition follow an absolutely strict naming convention. This means that all data that is either imported to, or produced as part of, the Framework are either fully or semi-automatically named. Alongside the strict file naming, also the hierarchical folder structure is strictly defined.

### File naming conventing

All data file names are composed of five (5) parts of which three relate to the composition, and the remaining two to location and timestamp. In the filename, the parts are separated by underscore, ("\_"), and the parts are not allowed to contain any underscore themselves:

1. prefix of layer identifier (composition prefix)
2. product or producer (composition product)
3. location
4. timestamp
5. suffix (composition suffix)

All files in the Framework thus have the following general format:

prefix_product_location_timestamp_suffix.extension

Within each part, a hyphen ("-") is used for separating different codes or labels. A hyphen in the timespan part, for example, denotes that the data in the file represent aggregated data for the period between two dates.

### Hierarchical folder structure

All the data files are organized in a hierarchical folder structure with the following levels:

- system
- source (composition source)
- division (tiles, region or mosaic)
- theme (composition theme)
- location
- timestamp

The two lowest hierarchical levels, _location_ and _timestamp_, are identical to the _location_ and _timestamp_ in the file name. The _theme_ can be anything like "rainfall", "elevation", "landform" or other thematic identifier. _division_ can only take three different values "tiles", "region" or "mosaic". The user can not set which of the three to use; that is linked to each process and coded in the database (put differently, the _division_ is a fixed attribute of the process object). The _source_ level identifies the source or origin of the data and is equal to the composition _source_, for instance "TRMM" for TRMM rainfall data. The top _system_ level relate to the different projection and tiling systems for representing data that is included in the Framework (e.g. _ancillary_, _modis_, _sentinel_, _ease2t_, _ease2s_, _seas2n_, _mgrs_), plus one system (_system_) for some default data.

# json coded parameterization

All Framework processes are initiated and parameterized using json coded instructions. All processes require some basic (common) instructions, and then also process specific instruction.

## json project definition

Framework processes are only accessible from within a project. A project is defined by a user (_userid_), an id (_projectid_), a geographical region (_tractid_), that can be further subdivided at two more levels (_siteid_ and _plotid_), and a projection system (_system_). All variables given must be predefined in the Framework database. The Framework spatial definitions are explained in further detail in [this](../setup-regions) post.

In addition, a temporal period must be specified; for non-spatial data and for spatial data that can be regarded as static on human time scales (e.g. topography) the timestep is set to _static_, as in the example below. Also the postgres database to use must be defined.

```
{
  "postgresdb": {
    "db": "geoimagine"
  },
  "userproject": {
    "userid": "karttur",
    "projectid": "karttur-northlandease2n",
    "tractid": "karttur-northlandease2n",
    "siteid": "*",
    "plotid": "*",
    "system": "ease2n"
  },
  "period": {
    "timestep": "static"
  },
  "process": [
    {
      "processid": "processid",  
    }
  ]
}
```

In the above example, the _userid_ is set to the system default superuser _karttur_. All project id's (_projectid_) are forced to 2-part names separated with a hyphen. In the example, the second part (_northlandease2n_) denotes that the geographic region is the land mass of the northern hemisphere and that the system projection is _ease2n_ (Equal-Area Scalable Earth (EASE) Grids, version 2, for the northern hemisphere). The system is thus also _ease2n_.

All the processes defined (under the _process_ list clause "\[\]") will be run for the geographical region (_tractid_) and temporal period (_static_) defined for the _userproject_, given that the identified user has these rights.



### Defining the Framework superuser

The Framework default superuser is by default called _karttur_. The user _karttur_ is also by default given a _project_ that is also called _karttur_ and that include a _tractid_ that is also called _karttur_. _karttur_ is thus the name of a _user_, a _project_ and a global region (or tract). Thus defined, the user _karttur_ has the rights to perform all processes available within the Framework.

The combination of _user_, _project_ and _tractid_ must be predefined in the postgres database. You can define any number of users, projects and tracts, but they must be linked. When you setup the complete Framework you can also change the name of the _user_, _project_ and _tractid_ for your superuser. That is done when you setup the links to database in one of the [following](../setup-dblink/) posts and then run the database installation as described in [yet another](../setup-db/) post. To change the name of the superuser, and the associated project and tract you need to edit the json files used for setting up the Framework database.

## period

The period tag is used for defining the temporal setting of the processes. The tag is set up as its own process called [<span class='package'>periodicity</span>](../../subprocess/subproc-periodicity/). Some processes are not associated with any temporal resolution, including the setting up of processes itself. The period tag is thus not strictly needed for all processes.

All the period parameters that are expected have a default value. If no parameters are given, the _periodicity_ process expects a single static file with no date. If only startyear is given, startmonth and startday are both set to 1 (i.e. to 1 January). If only endyear is given, the endmonth is set to 12 and endday to 31 (i.e. to 31 December).

Apart from setting the correct start and end dates, the temporal interval must also be set. The coding of the intervals largely follows the [Python Data Analysis Library, <span class='package'>pandas</span>](https://pandas.pydata.org/). <span class='package'>pandas</span> should be part of your <span class='app'>Anaconda</span> installation. If not, installation instructions are directly on top of [<span class='package'>pandas</span> home page](https://pandas.pydata.org/).

In Karttur´s GeoImagine Framework the attribute _timestep_ is used for defining the temporal interval, and loosely corresponds to the [_offset aliases_](http://pandas.pydata.org/pandas-docs/version/0.9.1/timeseries.html#offset-aliases) defined in <span class='package'>pandas</span>. The table below summarises the _timestep_ or _offset aliases_ that are used in the Framework:

| Karttur | Pandas | string code | date code | Description  |
|:--------|:-------|:------------|:----------|:-------------|
| D       | D      | "yyyymmdd"  | yyyymmdd  | daily        |
| M       | MS     | "yyyymm"    | yyyymm01  | monthly      |
| Q       | Q      | "yyyyq"     | yyyymm01  | quarterly    |
| A       | AS     | "yyyy"      | yyyy0101  | annual       |
| XD      | --     | "yyyydoy"   | yyyymmdd  | day interval |


While the pandas _offset aliases_ "M" represents month end frequency, in Karttur's coding it means monthly aggregated value. In the file naming convention, monthly data is represented as "YYYYMM". In the database the datetime object for any "M" is represented by the first day of that month. Strictly speaking this corresponds to Pandas _offset alias_ "MS". Quarterly ("Q") and Annual ("A") _timesteps_ are constructed in a similar manner. Karttur does not use Pandas _offset alias_ weekly ("W"). Instead Karttur includes a day-interval _timestep_ that can be set to any interval. "7D" would then correspond to a weekly _timestep_.

In the GeoImagine Framework, data representing statistical or aggregated conditions over a timespan are given derived temporal codings. These derived codes do not have any datetime code, only a string code.

| Karttur     | string code         | Description                   |
|:------------|:--------------------|:------------------------------|
| timespan-D  | "yyyymmdd-yyyymmdd" | aggregate daily data          |
| timespan-M  | "yyyymm-yyyymm"     | aggregate monthly data        |
| timespan-Q  | "yyyyq-yyyyq"       | aggregate quarterly data      |
| timespan-A  | "yyyy-yyyy"         | aggregate annual data         |
| timespan-XD | "yyyydoy-yyyydoy"   | aggregate day interval data   |
| seasonal-D  | "yyyy-yyyy@Ddoy"    | daily seasonal average        |
| seasonal-M  | "yyyy-yyyy@Mmm"     | monthly seasonal average      |
| seasonal-Q  | "yyyy-yyyy@MQq"     | quarterly seasonal average    |
| seasonal-XD | "yyyy-yyyy@XDdoy"   | day interval seasonal average |


See the [<span class='package'>periodicity</span>](../../subprocess/subproc-periodicity/) process page for more details.

## json process definition

Once the _userproject_ and _period_ are defined, any number of processes relating to the geographical region (that can also be None) and temporal period (that can also be None) can be joined together under the _process_ list clause "\[\]"). Each _process_ typically requires a specific set of parameters.

Processes can be both spatial and non-spatial (e.g. including the definition of the processes themselves), or for instance start with text data as input and generate a spatial layer as output (or vice-versa).

### Common parameters

All processes have some parameters in common:

 - processid [text]
 - verbose [integer]
 - overwrite [boolean]
 - delete [boolean]
 - acceptmissing [boolean]
 - dryrun [boolean]

```
  "process": [
    {
      "processid": "processid",
      "verbose": 2,
      "overwrite": false,
      "delete": false,
      "acceptmissing": true,
      "dryrun":false
    }
  ]
```

### Specific parameters

You need to check each process specifically to get information on the parameters to set. Some parameters are defaulted and need not be stated, whereas other parameters are mandatory. If you forget to set mandatory parameters, the process will halt and report the missing parameter.

#### srcpath and dstpath

If the process requires source (src) data stored in files as input, the tag srcpath is required for identifying the volume and the filetype. Similarly, if the process produces data stored in files the tag dstpath is required. For most processes the filetype attribute is not required. By default all spatial raster data is represented as GeoTiff files (<span class='file'>.tif</span>), and all spatial vector data as ESRI shape files (<span class='file'>.shp</span>).

### \<srccomp\> and \<dstcomp\>

\<srccomp\> must be given if the processes expects source data on file. The source data must state the composition parts as attributes:
- source
- product
- folder
- band
- prefix
- suffix

Not all processes that produce destination data on file require that the \<dstcomp\> is given. Some processes include hardcoded definitions of both the destination composition, the file name and the hierarchical folder structure. Different time series analysis typically produces destination compositions with the folder hierarchy and the file name derived from the source composition, with no possibility for user changes. Other processes does allow some restricted user changes, whereas the majority of processes require that the user give the full definitions of the destination composition(s). Apart from the components listed above, destination compositions must also include attributes for:
- scalefac
- offsetadd
- celltype
- cellnull
- dataunit
- measure

If the Framework detects any conflicts with existing compositions, the process will not proceed until this is corrected.

### Other tags

A few other child tags under \<process\> are used in specific processes, including:

- \<node\> (in e.g. [<span class='package'>addsubproc</span>](../../subprocess/subproc-addsubproc/) for defining process parameters)
- \<stats\> (in e.g. [<span class='package'>trendtcancillary</span>](../../subprocess/subproc-trendtcancillary/) for defining statistical measure to produce)
- \<comps\> (in e.g. [<span class='package'>createscaling</span>](../../subprocess/subproc-createscaling/) for defining scaling when exporting data)

The pages for each [individual process](../../subprocesses/) lists all the tags and attributes required.
