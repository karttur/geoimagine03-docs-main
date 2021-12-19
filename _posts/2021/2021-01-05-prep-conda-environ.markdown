---
layout: article
title: Python virtual environment
categories: prep
tutorial: null
excerpt: "Create Conda Python environment for Karttur's GeoImagaine project"
previousurl: null
nexturl: putinplace
tags:
  - Conda environment
  - Python
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2021-01-05 T18:17:25.000Z'
modified: '2021-01-05 T18:17:25.000Z'
comments: true
share: true
figure1: eclipse_select_import
figure2: eclipse_import_project_from_file_system_or_archive
---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>

# Introduction

This post is an extended version of the [post on Conda virtual environments in the blog on setting up the Spatial Data Integrated Development Environment (SPIDE)](https://karttur.github.io/setup-ide/setup-ide/conda-environ/).

With conda, you can create, update, export and import virtual Python environments that have different versions of Python and/or packages installed in them. If you use <span class='app'>Eclipe</span> as your Integrated Development Environment (IDE) you can easily reset your Python source to a virtual version created in conda. You can also share an environment by first exporting and then importing it.

# Prerequisites

Anaconda/conda must be installed as described in [this](https://karttur.github.io/setup-ide/setup-ide/install-anaconda/) post. If you [created a conda virtual environment when setting up the SPIDE](https://karttur.github.io/setup-ide/setup-ide/conda-environ/) you can skip to the section "Install additional packages in your environments".

# Conda virtual environments

Karttur's GeoImagine Framework requires a large set of Python packages to work. You have to install these packages and then link them to the SPIDE. Many high level packages depend on other, more basic, packages. When installing many packages there is a large risk of forcing conflicting requirements regarding the versions of shared (i.e. more basic) packages. Sequentially installing (high level) packages can easily lead to a corrupt system due to conflicting requirements regarding shared packages.

To avoid having your complete system corrupted, it is recommended that you build the Python system and packages using a "virtual" environment. In essence this means that you build a system that is working as a stand-alone solution not affecting the core (or 'base') system. This is easily done in conda. This tutorial will take you through the steps of creating a virtual python environment in conda.

## Check your conda installation and environment

Open a <span class='app'>Terminal</span> window, and confirm that Anaconda is installed by typing at the prompt:

<span class='terminal'>$ conda -V</span>

By default, the active environment---the one you are currently using---is shown in parentheses () or brackets [] at the beginning of your command prompt. If you have not installed any virtual environments, the _default_ environment is _base_:

<span class='terminal'>(base) $</span>,

if you have defined, and activated, a virtual environment it will be shown instead:

<span class='terminal'>(myenv) $</span>.

If you do not see this, run:

<span class='terminal'>conda info</span>

and the first returned line should tell which environment that is active.

To update or manage your conda installation you need to deactivate any customized environment and return to the base environment. The best way to do that is to use the _activate_ command with no environment specified:

<span class='terminal'>$ conda activate</span>

Alternatively you can _deactivate_ the present environment, but if you do that while in _base_, it might crash your conda setup. Thus I do not write out the command for that.

When in the _base_ environment the terminal prompts should look like this:

<span class='terminal'>(base) $</span>

To update your Anaconda distribution, type:

<span class='terminal'>$ conda update conda</span>

<span class='terminal'>$ conda update anaconda</span>

## .condarc

To create a virtual environment from scratch you need to have a <span class='file'>.condarc</span> configuration file in you personal folder.

<span class='file'>.condarc</span> is not included by default when you [install conda](../install-anaconda/). To find out if you have a <span class='file'>.condarc</span> file open a <span class='app'>terminal</span> window and type:
 <span class='terminal'>$ conda info</span>

Look for the line <span class='terminal'>user config file:</span> in the results.

If you do not have a <span class='file'>.condarc</span> file, you can create it by using a text editor (e.g. [<span class='app'>Atom</span>](https://karttur.github.io/setup-blog/2017/12/21/setup-blog-tools.html)), directly from the command line ( <span class='terminal'>~$ pico .condarc</span>) or by running the command:

<span class='terminal'>$ conda config</span>

You can set a lot of parameters and functions in <span class='file'>.condarc</span> (as described in the conda document [Using the .condarc conda configuration file](https://docs.conda.io/projects/conda/en/latest/user-guide/configuration/use-condarc.html)), but for now you will only use it for defining a set of default packages that by default will be included when creating a new environment (but you can omit this default if required).

### Default packages

The manual for setting default packages to install with every new environment is also described in the conda document [Using the .condarc conda configuration file](https://docs.conda.io/projects/conda/en/latest/user-guide/configuration/use-condarc.html#config-add-default-pkgs). Consult the conda document [Anaconda package lists](https://docs.anaconda.com/anaconda/packages/pkg-docs/) to see available packages for different conda distributions.

For creating virtual conda python environments for Karttur's GeoImagine Framework, add the following lines to your <span class='file'>.condarc</span> file:

```
create_default_packages:
  - cartopy
  - fiona
  - gdal
  - geopandas
  - h5py
  - matplotlib
  - netcdf4
  - numba
  - numpy
  - pandas
  - pip
  - psycopg2
  - rasterio
  - scipy
  - statsmodels
  - xmltodict
```


The above list will also install several other packages that are required by the Framework, including for instance <span class='package'>GDAL</span>, <span class='package'>fiona</span> and <span class='package'>shapely</span>, that are packages for geographic data processing and topology.

The advantage with installing the core components in a single command is that conda will solve conflicts among dependencies. In other words, it is best to install all packages at once, so that all of the dependencies are installed at the same time.

## Create a new environment

If you now create a new environment:

<span class='terminal'>$ conda create ----name geoimagineXYZ</span>,

the rather short list of default packages will create a rather long list of package to install.

<button id= "togglecondacreate" onclick="hiddencode('condacreate')">Hide/Show conda create command and response</button>

<div id="condacreate" style="display:none">

{% capture text-capture %}
{% raw %}

```
$ conda create --name geoimagine001
Collecting package metadata: done
Solving environment: done

## Package Plan ##

  environment location: /Applications/anaconda3/envs/geoimagine001

  added / updated specs:
    - geopandas
    - numba
    - numpy
    - pandas
    - pip
    - psycopg2
    - scipy
    - statsmodels
    - xmltodict

The following packages will be downloaded:
...
...

The following NEW packages will be INSTALLED:

  attrs              pkgs/main/osx-64::attrs-19.1.0-py37_1
  blas               pkgs/main/osx-64::blas-1.0-mkl
  bzip2              pkgs/main/osx-64::bzip2-1.0.6-h1de35cc_5
  ca-certificates    pkgs/main/osx-64::ca-certificates-2019.5.15-0
  cairo              pkgs/main/osx-64::cairo-1.14.12-hc4e6be7_4
  certifi            pkgs/main/osx-64::certifi-2019.3.9-py37_0
  click              pkgs/main/osx-64::click-7.0-py37_0
  click-plugins      pkgs/main/noarch::click-plugins-1.1.1-py_0
  cligj              pkgs/main/osx-64::cligj-0.5.0-py37_0
  curl               pkgs/main/osx-64::curl-7.64.1-ha441bb4_0
  cycler             pkgs/main/osx-64::cycler-0.10.0-py37_0
  descartes          pkgs/main/osx-64::descartes-1.1.0-py37_0
  expat              pkgs/main/osx-64::expat-2.2.6-h0a44026_0
  fiona              pkgs/main/osx-64::fiona-1.8.4-py37h9a122fd_0
  fontconfig         pkgs/main/osx-64::fontconfig-2.13.0-h5d5b041_1
  freetype           pkgs/main/osx-64::freetype-2.9.1-hb4e5f40_0
  freexl             pkgs/main/osx-64::freexl-1.0.5-h1de35cc_0
  gdal               pkgs/main/osx-64::gdal-2.3.3-py37hbe65578_0
  geopandas          pkgs/main/noarch::geopandas-0.4.1-py_0
  geos               pkgs/main/osx-64::geos-3.7.1-h0a44026_0
  gettext            pkgs/main/osx-64::gettext-0.19.8.1-h15daf44_3
  giflib             pkgs/main/osx-64::giflib-5.1.4-h1de35cc_1
  glib               pkgs/main/osx-64::glib-2.56.2-hd9629dc_0
  hdf4               pkgs/main/osx-64::hdf4-4.2.13-h39711bb_2
  hdf5               pkgs/main/osx-64::hdf5-1.10.4-hfa1e0ec_0
  icu                pkgs/main/osx-64::icu-58.2-h4b95b61_1
  intel-openmp       pkgs/main/osx-64::intel-openmp-2019.4-233
  jpeg               pkgs/main/osx-64::jpeg-9b-he5867d9_2
  json-c             pkgs/main/osx-64::json-c-0.13.1-h3efe00b_0
  kealib             pkgs/main/osx-64::kealib-1.4.7-hf5ed860_6
  kiwisolver         pkgs/main/osx-64::kiwisolver-1.1.0-py37h0a44026_0
  krb5               pkgs/main/osx-64::krb5-1.16.1-hddcf347_7
  libboost           pkgs/main/osx-64::libboost-1.67.0-hebc422b_4
  libcurl            pkgs/main/osx-64::libcurl-7.64.1-h051b688_0
  libcxx             pkgs/main/osx-64::libcxx-4.0.1-hcfea43d_1
  libcxxabi          pkgs/main/osx-64::libcxxabi-4.0.1-hcfea43d_1
  libdap4            pkgs/main/osx-64::libdap4-3.19.1-h3d3e54a_0
  libedit            pkgs/main/osx-64::libedit-3.1.20181209-hb402a30_0
  libffi             pkgs/main/osx-64::libffi-3.2.1-h475c297_4
  libgdal            pkgs/main/osx-64::libgdal-2.3.3-h0950a36_0
  libgfortran        pkgs/main/osx-64::libgfortran-3.0.1-h93005f0_2
  libiconv           pkgs/main/osx-64::libiconv-1.15-hdd342a3_7
  libkml             pkgs/main/osx-64::libkml-1.3.0-hbe12b63_4
  libnetcdf          pkgs/main/osx-64::libnetcdf-4.6.1-hd5207e6_2
  libpng             pkgs/main/osx-64::libpng-1.6.37-ha441bb4_0
  libpq              pkgs/main/osx-64::libpq-11.2-h051b688_0
  libspatialindex    pkgs/main/osx-64::libspatialindex-1.8.5-h2c08c6b_2
  libspatialite      pkgs/main/osx-64::libspatialite-4.3.0a-h644ec7d_19
  libssh2            pkgs/main/osx-64::libssh2-1.8.2-ha12b0ac_0
  libtiff            pkgs/main/osx-64::libtiff-4.0.10-hcb84e12_2
  libxml2            pkgs/main/osx-64::libxml2-2.9.9-hab757c2_0
  llvmlite           pkgs/main/osx-64::llvmlite-0.28.0-py37h8c7ce04_0
  mapclassify        pkgs/main/noarch::mapclassify-2.0.1-py_0
  matplotlib         pkgs/main/osx-64::matplotlib-3.1.0-py37h54f8f79_0
  mkl                pkgs/main/osx-64::mkl-2019.4-233
  mkl_fft            pkgs/main/osx-64::mkl_fft-1.0.12-py37h5e564d8_0
  mkl_random         pkgs/main/osx-64::mkl_random-1.0.2-py37h27c97d8_0
  munch              pkgs/main/osx-64::munch-2.3.2-py37_0
  ncurses            pkgs/main/osx-64::ncurses-6.1-h0a44026_1
  numba              pkgs/main/osx-64::numba-0.43.1-py37h6440ff4_0
  numpy              pkgs/main/osx-64::numpy-1.16.4-py37hacdab7b_0
  numpy-base         pkgs/main/osx-64::numpy-base-1.16.4-py37h6575580_0
  openjpeg           pkgs/main/osx-64::openjpeg-2.3.0-hb95cd4c_1
  openssl            pkgs/main/osx-64::openssl-1.1.1c-h1de35cc_1
  pandas             pkgs/main/osx-64::pandas-0.24.2-py37h0a44026_0
  patsy              pkgs/main/osx-64::patsy-0.5.1-py37_0
  pcre               pkgs/main/osx-64::pcre-8.43-h0a44026_0
  pip                pkgs/main/osx-64::pip-19.1.1-py37_0
  pixman             pkgs/main/osx-64::pixman-0.38.0-h1de35cc_0
  poppler            pkgs/main/osx-64::poppler-0.65.0-ha097c24_1
  poppler-data       pkgs/main/osx-64::poppler-data-0.4.9-0
  proj4              pkgs/main/osx-64::proj4-5.2.0-h0a44026_1
  psycopg2           pkgs/main/osx-64::psycopg2-2.7.6.1-py37ha12b0ac_0
  pyparsing          pkgs/main/noarch::pyparsing-2.4.0-py_0
  pyproj             pkgs/main/osx-64::pyproj-1.9.6-py37h9c430a6_0
  python             pkgs/main/osx-64::python-3.7.3-h359304d_0
  python-dateutil    pkgs/main/osx-64::python-dateutil-2.8.0-py37_0
  pytz               pkgs/main/noarch::pytz-2019.1-py_0
  readline           pkgs/main/osx-64::readline-7.0-h1de35cc_5
  rtree              pkgs/main/osx-64::rtree-0.8.3-py37_0
  scipy              pkgs/main/osx-64::scipy-1.2.1-py37h1410ff5_0
  setuptools         pkgs/main/osx-64::setuptools-41.0.1-py37_0
  shapely            pkgs/main/osx-64::shapely-1.6.4-py37he8793f5_0
  six                pkgs/main/osx-64::six-1.12.0-py37_0
  sqlalchemy         pkgs/main/osx-64::sqlalchemy-1.3.3-py37h1de35cc_0
  sqlite             pkgs/main/osx-64::sqlite-3.28.0-ha441bb4_0
  statsmodels        pkgs/main/osx-64::statsmodels-0.9.0-py37h1d22016_0
  tk                 pkgs/main/osx-64::tk-8.6.8-ha441bb4_0
  tornado            pkgs/main/osx-64::tornado-6.0.2-py37h1de35cc_0
  wheel              pkgs/main/osx-64::wheel-0.33.4-py37_0
  xerces-c           pkgs/main/osx-64::xerces-c-3.2.2-h44e365a_0
  xmltodict          pkgs/main/noarch::xmltodict-0.12.0-py_0
  xz                 pkgs/main/osx-64::xz-5.2.4-h1de35cc_4
  zlib               pkgs/main/osx-64::zlib-1.2.11-h1de35cc_3
  zstd               pkgs/main/osx-64::zstd-1.3.7-h5bba6e5_0


Proceed ([y]/n)?
```
{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html  toggle-text=text-capture  %}
</div>

Just press <span class='terminal'>y</span> when conda asks <span class='terminal'>Proceed ([y]/n)?</span> and let conda setup your environment. The terminal response should then be like this:

```
Proceed ([y]/n)? y

Preparing transaction: done
Verifying transaction: done
Executing transaction: done
#
# To activate this environment, use
#
#     $ conda activate geoimagine001
#
# To deactivate an active environment, use
#
#     $ conda deactivate
```

If something goes wrong you just simply [remove the virtual environment](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#id17):

<span class='terminal'>$ conda remove ----name geoimagine001 ----all</span>

The conda base setup is not affected by either installing or deleting a virtual environment.

## Activate your environment

To list available environments type:

<span class='terminal'>$ conda info -e</span>

If you want to activate a specific environment (other than 'base' that is now the default) type at the terminal:

<span class='terminal'>$ conda activate geoimagine001</span>

The prompt should change to say

<span class='terminal'>(geoimagine001) ... $</span>

You can now make additional installations to your environment. But first have to locate your virtual environment to learn its path. You need to know that in order to link it as the Python interpreter in <span class='app'>Eclipse</span>.

### Locate your virtual environments

You can tell conda to put your virtual environment under any path, but by default it is put under your <span class='app'>Anaconda</span> installation at:

<span class='file'>../anacondaX/envs</span>, which in my example (for Anaconda3) then becomes
<span class='file'>../anaconda3/envs/geoimagine001</span>.

If you explore that path you can find the packages installed under
<span class='file'>../anaconda3/envs/geoimagine001/lib/python3.7/site-packages</span>. (where python3.7 is the Python version I installed, but can differ if you installed another version).

### Set your Python interpreter in Eclipse

With <span class='app'>Eclipse</span> workbench up and running, select from the top menu:

<span class='menu'>Eclipse : preferences</span>

In the <span class='tab'>Preferences</span> window that opens, click the PyDev expansion icon (\>) in the menu to the left. In the expanded sub-list click the expansion icon for <span class='button'>Interpreters</span> and click <span class='button'>Python interpreter</span>. In the window that opens, click the <span class='button'>Browse for python/pypy exe</span> button in the upper right corner. The dialog window <span class='tab'>Select Interpreters</span> opens.

Click the <span class='button'>Browse</span> button next to the textbox <span class='textbox'>Interpreter Executable</span>.

If you created a virtual environment, navigate to where you stored it and find the Python binary file (e.g. .../anaconda3/envs/geoimagine001/bin/python) and choose that file. Then edit the textbox <span class='textbox'>Interpreter Name</span> to something like 'Python3.x geoimagine001'.

If you did not setup a virtual Python environment you can use the Anaconda default (or 'base') environment as your Python interpreter. Click the <span class='button'>Browse</span> button and navigate to where you [installed Anaconda](https://karttur.github.io/setup-ide/setup-ide/install-anaconda), and drill down to the Python binary:

<span class='file'>.../anaconda3/bin/python</span>

Regardless of which interpreter you selected, click <span class='button'>Finish/OK</span>, and the dialog window <span class='tab'>Selection Needed</span> appears. Accept the default selection (all listed items), and click <span class='button'>Finish/OK</span> again. All the selected Libraries and their associated Packages will be linked to your project, and show up in the lower frame of the <span class='tab'>Preferences</span> window. When finished, click <span class='button'>Apply and Close</span>.

At this stage you can continue with [setting up Karttur's GeoImagine Framework](../../setup). Dependent on how you set it up and what functions you require, you will need to to install additional Python packages to your virtual environment. The topic of the reminder of this post.

### Install additional packages in your environments

There are two main methods for installing additional Python packages to your environment, either using _conda install_ or _pip_. The general recommendaton is to use one of these for individual environments, with _conda install_ being the preferred method. But not all packages are available as default conda installations. All available packages are listed [here](https://docs.anaconda.com/anaconda/packages/pkg-docs/). Some of the packages required by Karttur´s GeoImagaine Framework are only available via _pip_, and you thus have to mix _conda install_ and _pip_ as installations methods when setting up the complete library needed.

#### conda install

You can install new packages into your environment in the usual way that <span class='terminalapp'>conda</span> packages are installed. Just make sure that the terminal prompt points at your environment:

<span class='terminal'>(geoimagine002) ... $ conda install -c omnia svgwrite</span>

or tell <span class='terminalapp'>conda</span> under which environment to install the packages:

<span class='terminal'>$ conda install --name geoimagine002 -c omnia svgwrite</span>

Once the installation is finished you should see the installed packages under the <span class='file'>site-packages</span> path and with the <span class='terminal'>$ conda list</span>

#### Install non-listed conda packages

If you want to install a package that is not listed as an available package for your conda distribution (see above) you should first search for it as it might have been a recent addition.

<span class='terminal'>$ conda search plotnine</span>

If the search identifies the package just go ahead and install it. If the package is not found you might still find it by looking for it using your web-browser, as also suggested by a non-successful search:

```
To search for alternate channels that may provide the conda package you're
looking for, navigate to

    https://anaconda.org

and use the search bar at the top of the page.
```

For the example with _plotnine_, it is available for installation from a conda -forge channel, e.g.:

<span class='terminal'>$ conda install -c conda-forge plotnine</span>

If your package is available, it is likely that it is listed under a "-forge" command. This means that when <span class='terminal'>conda install</span> tries to solve the environment it will first report any conflicts with existing packages, and then forge conflicts. There are three alternative conflicts:

- SUPERSEED
- UPGRADE
- DOWNGRADE

**Superseed** means that the new package comes with a dependency that is already installed, but that the dependency will be replaced by the alternative found with the new package. It _should_ be exactly the same package with the same content as the existing dependency, but it will nevertheless be replaces. For all cases I have encountered it has worked out fine to accept the **superseed**. Otherwise this is the reason you are using a (virtual) environment. You just repeat the setup until the point where it went wrong, and then try another solution.

If the <span class='terminal'>-forge</span> installation reports that a package is to be **upgrade(d)** that _might_ work. If it reports that a package is in for a **downgrade** then proceeding with the installation is likely to cause problems with other packages. One solution is then to export your environment and try other versions or alternatives. Change the conflicting packages to use the same version of the common dependency (you have to look in the documentation to find versions that can go together).

#### Install using pip

If the package you want to install is neither available with <span class='terminal'>$ conda install</span>, nor available as a <span class='terminal'>$ conda -forge</span> installation, you need to use an alternative package manager (as described [here](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-pkgs.html#installing-non-conda-packages)). This more or less always boils down to <span class='terminalapp'>pip</span>.

The package _sentinelsat_, used for searching and downloading satellte data from the European Space Agency (ESA) is only avalailable suing <span class='terminalapp'>pip</span>:

<span class='terminal'>(geoimagine0) ... $ pip install sentinelsat</span>

Again you can check that the package was installed in the correct place by exploring the <span class='file'>site-packages</span> path.

#### Additional installations

The complete GeoImagine Framework requires a handful of additional installations:

- landsatexplore
- plotnine
- seasonal
- sentinelsat
- svgis
- svgwrite

##### landsatxplore

[Landsatxplore](https://pypi.org/project/landsatxplore/) is a package for searching and downloading Landsat satellite image scenes from [EarthExplorer](https://earthexplorer.usgs.gov). There are alternative packages that can be used for the same task, but Karttur's GeoImagine Framework is set up for using Landsatxplore. If you want to use Landsat data from EarthExplorer you need to register as an EarthExplorer user.

[Landsatxplore](https://pypi.org/project/landsatxplore/) is not available at any conda channel and you need to use the <span class='terminalapp'>pip</span> installation manager.

<span class='terminal'>$ pip install landsatxplore</span>

#### plotnine

[plotnine](https://plotnine.readthedocs.io/en/stable/) is a powerful graphics editor that you can use for composing maps and layouts in Python. It is like a Python version of the popular "Grammar of graphics" concept used by _ggplot_. The grammar allows users to compose plots by explicitly mapping data to the visual objects that make up the plot. plotnine is available on several conda channels, and can for instance be installed using the command:

<span class='terminal'>$ conda install -c conda-forge plotnine</span>

#### seasonal

The seasonal package estimate and remove trend and periodicity in time-series. In the Framework it is used for time-series decomposition and trend estimations.

**NOTE** that in the Framework __the seasonal package is edited to include more options and with altered default settings__.

The seasonal package is installed with [<span class='terminalapp'>pip install</span>](https://pypi.org/project/seasonal/)

<span class='terminal'>$ pip install seasonal</span>

#### sentinelsat

In the Framework Sentinelsat is used for searching, downloading and retrieving the metadata and the actual data of Sentinel satellite images from the Copernicus Open Access Hub.

Sentinelsat is preferably installed via [conda-forge](https://anaconda.org/conda-forge/sentinelsat)

<span class='terminal'>$ conda install -c conda-forge sentinelsat</span>.

Sentinelsat can also be installed with [<span class='terminalapp'>pip install</span>](https://pypi.org/project/sentinelsat/):

<span class='terminal'>$ pip install sentinelsat</span>.

#### svgis

SVGIS converts vector geodata to Scalable Vector Graphics (SVG). SVG can be styled using Cascaded Style Sheets (CSS) and also read and manipulated by drawing programs. In the Framework SVGIS is primarily used for exporting vector data to use as overlays in map layouts.

SVGIS is installed with [<span class='terminalapp'>pip install</span>](https://pypi.org/project/svgis/)

<span class='terminal'>$ pip install svgis</span>

#### svgwrite

SVGwrite is a more general library for writing SVG formated vector graphics. It is used for creating legends and other layout items for maps. The preferred installation is using [<span class='terminalapp'>conda</span>](https://anaconda.org/conda-forge/svgwrite):

<span class='terminal'>$ conda install -c conda-forge svgwrite</span>

svgwrite is also available as [<span class='terminalapp'>pip install</span>](https://pypi.org/project/svgwrite/)

<span class='terminal'>$ pip install svgwrite</span>

#### ggtools

[GRACE & GLDAS Tools (ggtools)](https://pypi.org/project/ggtools/) is a library for GRACE(Gravity Recovery and Climate Experiment) and GRACE-FO(Follow-on) GSM data(RL06 Level-2 monthly solutions) and GLDAS grid data. The package itself is installed using []<span class='terminalapp'>pip</span>](https://pypi.org/project/ggtools/). It is dependent on _cartopy_, _netcdf4_ and _h5py_; all included as default packages (listed in <span class='file'>.condarc</span>).

<span class='terminal'>$ pip install ggtools</span>

#### wget

Wget is a command-line tool for retrieving files using HTTP, HTTPS, FTP and FTPS (the most widely-used Internet protocols). In Karttur´s GeoImagine Framework, wget is used for accessing online available data from e.g.[https://earthdata.nasa.gov](https://earthdata.nasa.gov), including MODIS and SMAP. To install Wget on Mac osx you can use <span class='app'>Homebrew</span>.

<span class='terminal'>$ brew install wget</span>

The installation of <span class='app'>Homebrew</span> itself is covered in the blog post on [ImageMagick](https://karttur.github.io/setup-theme-blog/blog/install-imagemagick/).

### Export and import environments

Once you have created a virtual environment that satisfies your needs, you can export it as <span class='file'>.yml</span> file. You can then use the <span class='file'>.yml</span> file to setup a new virtual environment, or share it to allow others to set up identical environments.

#### Export environment file (yml)

Activate the environment you want export
<span class ='terminal'>$ source activate geoimagine0</span>,

and then export

<span class='terminal'>(geoimagine) ... $ conda env export > geoimagine0.yml</span>.

The exported <span class='file'>.yml</span> file below shows the complete installation of all packages required for Karttur's GeoImagine Framework.

<button id= "toggleexport" onclick="hiddencode('export')">Hide/Show conda exported packages</button>

<div id="export" style="display:none">

{% capture text-capture %}
{% raw %}

```
name: geoimagine_202003_py37a
channels:
  - conda-forge
  - defaults
dependencies:
  - affine=2.3.0=py_0
  - attrs=20.3.0=pyhd3eb1b0_0
  - blas=1.0=mkl
  - brotlipy=0.7.0=py37hf967b71_1001
  - bzip2=1.0.8=h1de35cc_0
  - ca-certificates=2020.12.5=h033912b_0
  - cairo=1.14.12=hc4e6be7_4
  - cartopy=0.18.0=py37hf1ba7ce_1
  - certifi=2020.12.5=py37hf985489_1
  - cffi=1.14.4=py37hbddb872_0
  - cfitsio=3.470=hb33e7b4_2
  - cftime=1.4.1=py37he3068b8_0
  - chardet=4.0.0=py37hf985489_1
  - click=7.1.2=pyhd3eb1b0_0
  - click-plugins=1.1.1=py_0
  - cligj=0.7.1=py37hecd8cb5_0
  - cryptography=3.4.4=py37ha1e1f9f_0
  - curl=7.67.0=ha441bb4_0
  - cycler=0.10.0=py37_0
  - descartes=1.1.0=py_4
  - expat=2.2.10=hb1e8313_2
  - fiona=1.8.13.post1=py37h9c05f0f_0
  - fontconfig=2.13.1=ha9ee91d_0
  - freetype=2.10.4=ha233b18_0
  - freexl=1.0.6=h9ed2024_0
  - gdal=3.0.2=py37hbe65578_0
  - geojson=2.5.0=py_0
  - geomet=0.3.0=pyhd3deb0d_0
  - geopandas=0.8.1=py_0
  - geos=3.8.0=hb1e8313_0
  - geotiff=1.5.1=h0b0f252_0
  - gettext=0.19.8.1=h15daf44_3
  - giflib=5.1.4=h1de35cc_1
  - glib=2.63.1=hd977a24_0
  - h5py=2.10.0=py37h3134771_0
  - hdf4=4.2.13=h39711bb_2
  - hdf5=1.10.4=hfa1e0ec_0
  - html2text=2020.1.16=py_0
  - icu=58.2=h0a44026_3
  - idna=2.10=pyh9f0ad1d_0
  - intel-openmp=2019.4=233
  - jpeg=9b=he5867d9_2
  - json-c=0.13.1=h3efe00b_0
  - kealib=1.4.7=hf5ed860_6
  - kiwisolver=1.3.1=py37h23ab428_0
  - krb5=1.16.4=hddcf347_0
  - lcms2=2.11=h92f6f08_0
  - libboost=1.67.0=hebc422b_4
  - libcurl=7.67.0=h051b688_0
  - libcxx=10.0.0=1
  - libdap4=3.19.1=h3d3e54a_0
  - libedit=3.1.20191231=h1de35cc_1
  - libffi=3.2.1=h0a44026_1007
  - libgdal=3.0.2=h42cfeda_0
  - libgfortran=3.0.1=h93005f0_2
  - libiconv=1.16=h1de35cc_0
  - libkml=1.3.0=hbe12b63_4
  - libllvm10=10.0.1=h76017ad_5
  - libnetcdf=4.6.1=hd5207e6_2
  - libpng=1.6.37=ha441bb4_0
  - libpq=11.2=h051b688_0
  - libspatialindex=1.9.3=h0a44026_0
  - libspatialite=4.3.0a=h5142b36_0
  - libssh2=1.9.0=ha12b0ac_1
  - libtiff=4.1.0=hcb84e12_0
  - libxml2=2.9.10=h7cdb67c_3
  - llvm-openmp=10.0.0=h28b9765_0
  - llvmlite=0.34.0=py37h739e7dc_4
  - lz4-c=1.8.1.2=h1de35cc_0
  - matplotlib=3.3.2=hecd8cb5_0
  - matplotlib-base=3.3.2=py37h181983e_0
  - mizani=0.7.2=pyhd8ed1ab_0
  - mkl=2019.4=233
  - mkl-service=2.3.0=py37h9ed2024_0
  - mkl_fft=1.2.0=py37hc64f4ea_0
  - mkl_random=1.1.1=py37h959d312_0
  - munch=2.5.0=py_0
  - ncurses=6.2=h0a44026_1
  - netcdf4=1.4.2=py37h13743db_0
  - numba=0.51.2=py37h959d312_1
  - olefile=0.46=py37_0
  - openjpeg=2.3.0=hb95cd4c_1
  - openssl=1.1.1i=h35c211d_0
  - palettable=3.3.0=py_0
  - pandas=1.2.1=py37hb2f4e1b_0
  - patsy=0.5.1=py37_0
  - pcre=8.44=hb1e8313_0
  - pillow=8.1.0=py37h5270095_0
  - pip=20.3.3=py37hecd8cb5_0
  - pixman=0.40.0=haf1e3a3_0
  - plotnine=0.7.1=py_0
  - poppler=0.65.0=ha097c24_1
  - poppler-data=0.4.10=hecd8cb5_0
  - postgresql=11.2=h051b688_0
  - proj=6.2.1=hfd5b9e3_0
  - psycopg2=2.8.4=py37ha12b0ac_0
  - pycparser=2.20=pyh9f0ad1d_2
  - pyopenssl=20.0.1=pyhd8ed1ab_0
  - pyparsing=2.4.7=pyhd3eb1b0_0
  - pyproj=2.6.1.post1=py37h6d9c95c_1
  - pyshp=2.1.3=pyhd3eb1b0_0
  - pysocks=1.7.1=py37hf985489_3
  - python=3.7.7=hfe9666f_0_cpython
  - python-dateutil=2.8.1=pyhd3eb1b0_0
  - python_abi=3.7=1_cp37m
  - pytz=2021.1=pyhd3eb1b0_0
  - rasterio=1.1.0=py37heeaa653_0
  - readline=7.0=h1de35cc_5
  - requests=2.25.1=pyhd3deb0d_0
  - rtree=0.9.4=py37_1
  - scipy=1.6.0=py37h2515648_0
  - sentinelsat=0.14=pyh9f0ad1d_0
  - setuptools=52.0.0=py37hecd8cb5_0
  - shapely=1.7.1=py37hb435bde_0
  - six=1.15.0=py37hecd8cb5_0
  - snuggs=1.4.7=py_0
  - sqlite=3.33.0=hffcf06c_0
  - statsmodels=0.12.1=py37h9ed2024_0
  - svgwrite=1.4.1=pyhd8ed1ab_0
  - tbb=2018.0.5=h04f5b5a_0
  - tiledb=1.6.3=h29f752d_0
  - tk=8.6.10=hb0a8c7a_0
  - tornado=6.1=py37h9ed2024_0
  - tqdm=4.56.2=pyhd8ed1ab_0
  - urllib3=1.26.3=pyhd8ed1ab_0
  - wheel=0.36.2=pyhd3eb1b0_0
  - xerces-c=3.2.3=h48eee30_0
  - xmltodict=0.12.0=py_0
  - xz=5.2.5=h1de35cc_0
  - zlib=1.2.11=h1de35cc_3
  - zstd=1.3.7=h5bba6e5_0
  - pip:
    - appdirs==1.4.4
    - astropy==4.2
    - cssselect==1.1.0
    - datetime==4.3
    - decorator==4.4.2
    - ggtools==1.1.7
    - gpy==1.9.9
    - landsatxplore==0.9
    - lxml==4.6.2
    - numpy==1.20.1
    - packaging==20.9
    - paramz==0.9.5
    - pooch==1.3.0
    - pyerfa==1.7.2
    - pyshtools==4.8
    - seasonal==0.3.1
    - sphericalpolygon==1.2.0
    - svgis==0.5.1
    - tinycss2==1.1.0
    - utm==0.7.0
    - webencodings==0.5.1
    - xarray==0.16.2
    - zope-interface==5.2.0
prefix: /Applications/anaconda3/envs/geoimagine_202003_py37a
```
{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html  toggle-text=text-capture  %}
</div>

### Import

#### Test if the following works (not installed with create_default_packages)

- array
- struct
- os
- shutil
- subprocess
- gc
- collections
- sys
- math

# Resources

[Eclipse / Pydev features: Import existing project](https://sites.google.com/site/bcgeopython/examples/eclipse-pydev/eclipse-pydev-features-import-existing-project)

[Managing conda environments](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html)
