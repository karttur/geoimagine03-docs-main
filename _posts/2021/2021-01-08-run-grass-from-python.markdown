---
layout: article
title: Run GRASS from Python
categories: prep
tutorial: null
excerpt: "How to start and run GRASS from within an external Python script."
tags:
  - Python 3.7
  - GRASS 7.8
  - package
  - import
  - __init__.py
image: rainfall-delta_3B43_trmm_2001-2016_mk-z-ts-model@p005
date: '2021-01-08'
modified: '2021-01-08'
comments: true
share: true
---

## Introduction

[GRASS GIS](https://grass.osgeo.org) is a very versatile and powerful Geographic Information System. And it is Open Source. In this post you will learn how to call GRASS functions from a python module without actually starting GRASS.

## GRASSDATA, location and mapset

One of the defining features of GRASS GIS is how spatial data is organized at three hierarchical levels:

- GRASSDATA,
- Location,
- MapSet

_GRASSDATA_ is the root directory under which all GRASS related spatial data is stored. A _Location_ is defined by a projection and a region, and thus each regional dataset you work with must be defined as a _Location_. As a region can be global, the GRASSDATA Location used for external calls need only define the projection; the region (map extent) will be defined with each external call. All actual data belonging to a _Location_ is related to a _MapSet_, where the default _MapSet_ is called _PERMANENT_. While _GRASSDATA_ and _Location_ must exist beforehand when calling GRASS from an external Python module, the _MapSet_ can be created and changed on the fly.

### Setting up GRASS for external calls

Before calling GRASS you must setup _GRASSDATA_ and a _Location_. To use GRASS as part of Karttur's GeoImagine Framework you must setup a _Location_ for the projection system(s) you use (e.g. modis, ease2n, ease2t etc). This section illustrates how to setup GRASS for using the EASE-grid north (ease2n) projection system. The [installation of GRASS](https://karttur.github.io/setup-ide/setup-ide/install-gis/#grass) is covered in another post.

#### Start GRASS

Start GRASS and wait for the _Startup_ window.

<figure>
<img src="../../images/GRASS_startup.png">
<figcaption>GRASS startup window</figcaption>
</figure>

#### GRASSDATA and Location

Click the button for <span class='button'>New</span>, and create a new folder called _GRASSDATA_ (it can be called something else, but most users call it _GRASSDATA_). Then define a Location name and a description. The location name **must** be identical to the projection system you intend to use with Karttur´s GeoImagine Framework.

<figure>
<img src="../../images/grassdata_location.png">
<figcaption>Create GRASSDATA and a Location</figcaption>
</figure>

#### Define Location

Click <span class='button'>Next</span> to set the Location projection:

<figure>
<img src="../../images/GRASS_define_location.png">
<figcaption>Define Location, the projection and Location name must correspond to the projection system name and projection used in Karttur's GeoImagine Framework</figcaption>
</figure>

Again click <span class='button'>Next</span> to see the summary of your new location:

<figure>
<img src="../../images/GRASS_location_summary.png">
<figcaption>GRASS Location summary</figcaption>
</figure>

#### Start and finish

When you click <span class='button'>Finish</span> in the window with the Location Summary, GRASS Graphical User Interface (GUI) should start. As this _Location_ will be used for external calls you are done and can can Quit GRASS.

<figure>
<img src="../../images/GRASS_quit.png">
<figcaption>Quit GRASS.</figcaption>
</figure>

## Install grass.script

All the manuals start with importing grass.script, but not a single page explains how to install grass.script itself. A reference to a GitHub repo is broken.

### Trial 1 pip install grass-session

The first trial to get this up and running is to install the package <spanc class='package'>grass-session</span>. In the <span class='app'>Terminal</span>, activate the python conda environment that your project is running under.

<span class='terminal'>$ $ conda activate geoimagine_date_pyversion</span>

Then pip-install grass-session:

<span class='terminal'>$ pip install grass-session</span>

### Trial 2 - Link GRASS python via <span class='app'>Eclipse</span>
![Eclipse preferences](../../images/eclipse_preferences.png){: .pull-right}
In <span class='app'>Eclipse</span> you can add the folders with the GRASS builtin Python scripts to your environment (see the [GRASSwiki Using Eclipse to develop GRASS Python programs](https://grasswiki.osgeo.org/wiki/Using_Eclipse_to_develop_GRASS_Python_programs) for more details and other operating systems). Go via the preferences menu to open the Python interpreter of your project (see figure below):

<span class='menu'>Eclipse -> Preferences -> PyDev -> Interpreters -> Python Interpreter </span>

In the lower of the two sub-windows in the Preferences window, click on the <span class=''>Libraries</span> button.

<figure>
<img src="../../images/eclipse_python_interpreter.png">
<figcaption>Eclipse preferences for python interpreter</figcaption>
</figure>


<figure>
<img src="../../images/grass-app_navigate.png">
<figcaption>Navigate to inside the GRASS application (you might need to give the full path as the app content is not always seen in your file browser)</figcaption>
</figure>

For macOS add the following folder:

```
/Applications/GRASS-7.8.app/Resources/MacOS/lib
/Applications/GRASS-7.8.app/Resources/MacOS/etc
/Applications/GRASS-7.8.app/Resources/MacOS/bin
/Applications/GRASS-7.8.app/Resources/MacOS/etc/python
```

<figure>
<img src="../../images/eclipse_add_grass_folders.png">
<figcaption>Add GRASS folders to your Python interpreter in Eclipse</figcaption>
</figure>

For other Operating system, please see the [[GRASSwiki Using Eclipse to develop GRASS Python programs](https://grasswiki.osgeo.org/wiki/Using_Eclipse_to_develop_GRASS_Python_programs).

Finish the isntallation by <span class='button'>Apply and close</span>.

#### Set up the GRASS environment

Before you can call the GRASS commands from Python you need to define GRASS environmental variables. The easiest way to achieve that is to start a GRASS session with the _GRASSDATA_ and _Location_ that you defined above. Thus start <spanclas='app'>GRASS</span> and go to the <span class='app'>Terminal</span> prompt and <span class='terminalapp'>export</span> all the variables:

<span class='terminal'>> export</span>

```
GRASS 7.8.3 (ease2n):~ > export
export GDAL_DATA="/Applications/GRASS-7.8.app/Contents/Resources/share/gdal"
export GISBASE="/Applications/GRASS-7.8.app/Contents/Resources"
export GISBASE_SYSTEM="/Library/GRASS/7.8"
export GISBASE_USER="/Users/thomasgumbricht/Library/GRASS/7.8"
export GISRC="/tmp/grass7-thomasgumbricht-61909/gisrc"
export GIS_LOCK="61909"
export GRASS_ADDON_BASE="/Users/thomasgumbricht/Library/GRASS/7.8/Modules"
export GRASS_ADDON_ETC="/Users/thomasgumbricht/Library/GRASS/7.8/Modules/etc:/Library/GRASS/7.8/Modules/etc"
export GRASS_FONT_CAP="/Users/thomasgumbricht/Library/GRASS/7.8/Modules/etc/fontcap"
export GRASS_GNUPLOT="gnuplot -persist"
export GRASS_HTML_BROWSER="/Applications/GRASS-7.8.app/Contents/Resources/etc/html_browser_mac.sh"
export GRASS_HTML_BROWSER_MACOSX="-b com.apple.helpviewer"
export GRASS_OS_STARTUP="Mac.app"
export GRASS_PAGER="more"
export GRASS_PROJSHARE="/Applications/GRASS-7.8.app/Contents/Resources/share/proj"
export GRASS_PYTHON="/Applications/GRASS-7.8.app/Contents/Resources/bin/pythonw"
export GRASS_PYTHONWX="/Applications/GRASS-7.8.app/Contents/Resources/bin/pythonw"
export GRASS_VERSION="7.8.3"
export HOME="/Users/thomasgumbricht"
export LD_RUN_PATH="/Applications/GRASS-7.8.app/Contents/Resources/lib"
export MANPATH="/Applications/GRASS-7.8.app/Contents/Resources/docs/man:/Users/thomasgumbricht/Library/GRASS/7.8/Modules/docs/man:/Applications/GRASS-7.8.app/Contents/Resources/share/man:/usr/share/man:/usr/local/share/man:/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/share/man:/Library/Developer/CommandLineTools/usr/share/man"
export OLDPWD
export PATH="/Applications/GRASS-7.8.app/Contents/Resources/bin:/Applications/GRASS-7.8.app/Contents/Resources/scripts:/Users/thomasgumbricht/Library/GRASS/7.8/Modules/bin:/Users/thomasgumbricht/Library/GRASS/7.8/Modules/scripts:/usr/bin:/bin:/usr/sbin:/etc:/usr/lib"
export PS1="GRASS 7.8.3 (ease2n):\\w > "
export PWD="/Users/thomasgumbricht"
export PYTHONEXECUTABLE="/Applications/GRASS-7.8.app/Contents/Resources/bin/python"
export PYTHONPATH="/Applications/GRASS-7.8.app/Contents/Resources/etc/python"
export SHELL="sh"
export SHLVL="3"
export TMPDIR="/tmp/grass7-thomasgumbricht-61909"
export _="/Applications/GRASS-7.8.app/Contents/Resources/python.app/Contents/MacOS/python"
```


### Environment settings

To get GRASS to work from Python you must alter some Operating System Environment parameters.  I think (but am not sure) that you can do this either using softcoding on the fly, or hardcoding at startup. I opted for doing a soft coding in the \_\_init\_\_.py module that initiated the grass package in Karttur´s GeoImagine Framework.

```
"""
Created 4 Apr 2021

GRASS
==========================================

Package belonging to Karttur´s GeoImagine Framework.

Author
------
Thomas Gumbricht (thomas.gumbricht@karttur.com)

"""

import os
import sys

from .version import __version__, VERSION, metadataD


os.environ['GRASSBIN']=r"/Applications/GRASS-7.8.app/Contents/MacOS/Grass"

os.environ['GISBASE'] = "/Applications/GRASS-7.8.app/Contents/Resources"

os.environ['GISRC']="/tmp/grass7-thomasgumbricht-61909/gisrc"

os.environ['PATH'] = "/Applications/GRASS-7.8.app/Contents/Resources/bin:/Applications/GRASS-7.8.app/Contents/Resources/scripts:/Users/thomasgumbricht/Library/GRASS/7.8/Modules/bin:/Users/thomasgumbricht/Library/GRASS/7.8/Modules/scripts:/usr/bin:/bin:/usr/sbin:/etc:/usr/lib"

os.environ['PYTHONPATH']="/Applications/GRASS-7.8.app/Contents/Resources/etc/python"

sys.path.append("/Applications/GRASS-7.8.app/Contents/Resources/etc/python")

from .grass02 import ProcessGRASS
```

I think that you can alternatively for instance [set the environment using <span class='app'>Eclipse</span>](https://www.pydev.org/manual_101_interpreter.html)






## Resources

GRASS wiki
[Using Eclipse to develop GRASS Python programs](https://grasswiki.osgeo.org/wiki/Using_Eclipse_to_develop_GRASS_Python_programs)

[Working with GRASS without starting it explicitly](https://grasswiki.osgeo.org/wiki/Working_with_GRASS_without_starting_it_explicitly)

[GRASS Python Scripting Library](https://grasswiki.osgeo.org/wiki/GRASS_Python_Scripting_Library#Calling_a_GRASS_module_in_Python)

[script package](https://grass.osgeo.org/grass78/manuals/libpython/script.html#module-script.setup)

[Grass-session on GitHub](https://github.com/zarch/grass-session)

[GRASS 7 environment setup for Python](https://gis.stackexchange.com/questions/198540/grass-7-environment-setup-for-python)

### Stackexchange

[Connecting Python script external to Grass GIS 7 program in Windows 10?](https://gis.stackexchange.com/questions/203310/connecting-python-script-external-to-grass-gis-7-program-in-windows-10)
