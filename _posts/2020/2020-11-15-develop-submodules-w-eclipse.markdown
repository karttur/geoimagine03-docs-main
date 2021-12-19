---
layout: article
title: GitHub Submodules
categories: develop
excerpt: Organize GitHub repositories with python packages as submodules
previousurl: develop/develop-github-eclipse
nexturl: prep/prep-dblink/
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2020-11-15 T18:17:25.000Z'
modified: '2021-10-18 T18:17:25.000Z'
comments: true
share: true
figure15: github-framework_karttur_15_new-other
figure16: github-framework_karttur_16_pydev-package
figure17: github-framework_karttur_17_pydev-package2
---

**These instructions are for creating a GitHub repository with a frame- (or super-) project (repository [repo]) linking together individual repos each containing one of the python packages that constitute Karttur's GeoImagine Framework. If you are looking for how to clone the ready version of the complete framework, continue to the post [Git clone with Eclipse](../../prep/prepare-clone-eclipse/)**.

## Introduction

Developing my code and learning more about version control and <span class='app'>Eclipse</span>, I have come to the point where I need to setup Karttur´s GeoImagine Framework as a distributed version control system, or Git. There are different options for how to go about this. I chose to use [GitHub](https://github.com) and <span class='app'>Eclipse</span> submodules, keeping separate GitHub repositories (repos) for each python package and then joining all repos as submodules in a main-frame (or superproject) repo that functions like a container for all the included packages.

This post describes how to use submodules in a Git project for assembling a hierarchical PyDev project, and details how Karttur's GeoImagine Framework is organised on GitHub.

If you are primarily interested in Git submodules I recommend a more general instruction, like [Using submodules in Git - Tutorial](https://www.vogella.com/tutorials/GitSubmodules/article.html), [Git Submodules basic explanation](https://gist.github.com/gitaarik/8735255), [Working with submodules](https://github.blog/2016-02-01-working-with-submodules/) or the youtube introduction [Git Tutorial: All About Submodules](https://www.youtube.com/watch?v=8Z4Cmhji_FQ).

## Prerequisites

To follow the instructions in this post you need a [GitHub](https://github.com) account with a repository containing an empty PyDev project for <span class='app'>Eclipse</span>, created as explained in the post on [Setup Eclipse teamed with GitHub repository](../develop-github-eclipse/). You also need to have the [<span class='terminalapp'>git</span> command line tool](https://karttur.github.io/git-vcs/) installed.

To create a fully functional GeoImagine Framework you must also have installed the Spatial Data Integrated Development Environment (SPIDE) as outlined for Mac OSX in my blog [Install and setup spatial data IDE](https://karttur.github.io/setup-ide/), and summarised for Ubuntu in the post [Spatial Data Integrated Development Environment for Ubuntu 18.04](https://karttur.github.io/setup-ide/blog/ubuntu-setup-spide/). In march 2021 I updated the instructions to also include [Ubuntu 20](https://karttur.github.io/setup-ide/blog/ubuntu20-setup-spide/).

## Setup Eclipse PyDev project with GitHub

As a result of the previous post [Setup Eclipse teamed with GitHub repository](../develop-github-eclipse/), you should have a file and folder structure representing your local GitHub clone that looks like this (comments starting with "#" added for explanation in this text):

```
kt-gi-test01
|____.git #.git is a folder with hidden content not shown here
|____README.md #optional, only if you created the repository with a README
|____Karttur2019GitHub
| |____.project
| |____.pydevproject
```
where <span class='file'>kt-gi-test01</span> is the local clone of the GitHub repository and <span class='file'>Karttur2019GitHub</span> the <span class='app'>Eclipse</span> PyDev project. <span class='file'>.git</span> is a hidden folder containing a dozen Git related files. <span class='file'>README.md</span> was created with the GitHub repository if you requested it, otherwise you do not have it.

### Managing your local project

Karttur's GeoImagine Framework is built from approximately 40 python packages, all specifically written to be part of the Framework. These packages need to be added to the combined GitHub / <span class='app'>Eclipse</span> project as submodules. But before we can link the packages/submodules, you must create a frame (core or top) python package. Then all of the packages will be linked to the frame package.

#### Create the project python frame package

To create the python frame package, return to <span class='app'>Eclipse</span> and locate your project (_Karttur2019GitHub_) in the <span class='tab'>Package Explorer</span> (navigation) window. Right click and from the pop-out menu select:

<span class='menu'>--> New --> Other </span>

<figure>
<img src="{{ site.commonurl }}/images/{{ site.data.images[page.figure15].file }}">
<figcaption> {{ site.data.images[page.figure15].caption }} </figcaption>
</figure>

In the window <span class='tab'>Select a Wizard</span> that opens, select the option <span class='menu'>--> PyDev --> PyDev Package </span> and click <span class='button'>Next ></span>

<figure>
<img src="{{ site.commonurl }}/images/{{ site.data.images[page.figure16].file }}">
<figcaption> {{ site.data.images[page.figure16].caption }} </figcaption>
</figure>

In the window <span class='tab'>Create a new Python package</span> just fill in the name of your frame package (e.g. _geoimagine_).

<figure>
<img src="{{ site.commonurl }}/images/{{ site.data.images[page.figure17].file }}">
<figcaption> {{ site.data.images[page.figure17].caption }} </figcaption>
</figure>

Click <span class='button'>Finish</span> to create the package <span class='package'>geoimagine</span>. If you look in <span class='app'>Atom</span> or use the <span class='terminal'>ls -a</span> command with the terminal you should see that your local project have, at least, the following file/folder structure.

```
kt-gi-test01
|____.git
|____Karttur2019GitHub
| |____.project
| |____.pydevproject
| |____geoimagine
| | |______init__.py
```

#### Locate Karttur's GitHub repository

Your project does not yet contain any actual code. Before adding the python packages of Karttur's GeoImagine Framework as submodules you need to check out which python packages are available. Do that by either looking directly in [Karttur's GitHub account](https://github.com/karttur) (under the tab [repositories](https://github.com/karttur?tab=repositories) or check the list and links at the [packages page in the GeoImagine blog](https://karttur.github.io/geoimagine/packages/).

In Karttur's GitHub pages all repos containing python packages belonging to the GeoImagine Framework are named _geoimagine-"package"_, where package is the actual package name to be used in the hierarchical <span class='app'>Eclipse</span> PyDev project.

#### Add python package repo as submodule

When assembling Karttur's complete GeoImagine Framework all the repositories with python packages (i.e. those named _geoimagine-*_) must be located directly under the GitHub python frame package (named _geoimagine_ in this tutorial). To add the first python package (repository), start the <span class='app'>Terminal</span> and change directory to the python frame package:

<span class='terminal'>$ cd path/to/localGitHubClone/EclipseProject/PythonPackage</span>

which, with the names used in this example, and on my machine, becomes:

<span class='terminal'>$ cd /Users/thomasgumbricht/GitHub/kt-gi-test01/Karttur2019GitHub/geoimagine</span>

Check out that you are in the correct place by printing working directory <span class='terminal'>$ pwd</span>.

The first submodule (= repository = python package) that you are going to add is [setup_db](https://karttur.github.io/geoimagine/package/package-setup_db/) (where the repository name should then be "_geoimagine-setup_db_"). The <span class='app'>Terminal </span> command for adding a submodules is:

<span class='terminal'>$ git submodule add "url" name</span>

where _url_ is the url path to the GitHub repository to add, and _name_ is the name the added _url_ will get in the your main (target) repository. Adding the repository _geoimagine-setup_db_ as a python package called _setup_db_ thus becomes:

<span class='terminal'>$ git submodule add https://github.com/karttur/geoimagine-setup_db setup_db</span class='terminal'>

If you check online (www.github.com) there should be no changes (yet) in the main repo (_kt-gi-test01_). But if you check the local clone you should see several changes. At the top level there should be a new hidden file, <span class='file'>.gitmodules</span>, and then the frame python package (_geoimagine_) should contain a new sub-package called _setup_db_. The content of your project (main repository) should now be something like this:

```
kt-gi-test01
|____.git
|____.gitmodules
|____Karttur2019GitHub
| |____.project
| |____.pydevproject
| |____geoimagine
| | |______init__.py
| | |____setup_db
| | | |____.git
| | | |______init__.py
| | | |____version.py
| | | |____setup_db_main.py
| | | |____README.md
| | | |____setup_db_class.py
| | | |____.gitignore
| | | |____doc #folder with text and xml documents, content not shown here
```

#### All GeoImagine Python Packages

Below are the commands for adding all GeoImagine packages (repositories) as submodules (September 2019). You can run all the commands sequentially. You can also save the code as a shell script file (<span class='file'>.sh</span>) and run all the commands by executing the shell script.

```
git submodule add https://github.com/karttur/geoimagine-kartturmain kartturmain
git submodule add https://github.com/karttur/geoimagine-ancillary ancillary
git submodule add https://github.com/karttur/geoimagine-dem dem
git submodule add https://github.com/karttur/geoimagine-endmembers endmembers
git submodule add https://github.com/karttur/geoimagine-export export
git submodule add https://github.com/karttur/geoimagine-extract extract
git submodule add https://github.com/karttur/geoimagine-gdalutilities gdalutilities
git submodule add https://github.com/karttur/geoimagine-gis gis
git submodule add https://github.com/karttur/geoimagine-grace grace
git submodule add https://github.com/karttur/geoimagine-image image
git submodule add https://github.com/karttur/geoimagine-jekyllise jekyllise
git submodule add https://github.com/karttur/geoimagine-ktgraphics ktgraphics
git submodule add https://github.com/karttur/geoimagine-ktnumba ktnumba
git submodule add https://github.com/karttur/geoimagine-ktpandas ktpandas
git submodule add https://github.com/karttur/geoimagine-landsat landsat
git submodule add https://github.com/karttur/geoimagine-layout layout
git submodule add https://github.com/karttur/geoimagine-mask mask
git submodule add https://github.com/karttur/geoimagine-modis modis
git submodule add https://github.com/karttur/geoimagine-overlay overlay
git submodule add https://github.com/karttur/geoimagine-postgresdb postgresdb
git submodule add https://github.com/karttur/geoimagine-projects projects
git submodule add https://github.com/karttur/geoimagine-region region
git submodule add https://github.com/karttur/geoimagine-scalar scalar
git submodule add https://github.com/karttur/geoimagine-sentinel sentinel
git submodule add https://github.com/karttur/geoimagine-setup_db setup_db
git submodule add https://github.com/karttur/geoimagine-setup_process setup_process
git submodule add https://github.com/karttur/geoimagine-smap smap
git submodule add https://github.com/karttur/geoimagine-soilmoisture soilmoisture
git submodule add https://github.com/karttur/geoimagine-specials specials
git submodule add https://github.com/karttur/geoimagine-sqldumps sqldumps
git submodule add https://github.com/karttur/geoimagine-support support
git submodule add https://github.com/karttur/geoimagine-timeseries timeseries
git submodule add https://github.com/karttur/geoimagine-transform transform
git submodule add https://github.com/karttur/geoimagine-updatedb updatedb
git submodule add https://github.com/karttur/geoimagine-userproj userproj
git submodule add https://github.com/karttur/geoimagine-zipper zipper
```

### Start using Karttur's GeoImaginge Framework

If everything worked out correctly, you should now be able to start using (your customized version of) Karttur's GeoImagine Framework. But remember, you have to have [setup the complete SPIDE](https://karttur.github.io/setup-ide/) as well as created a customised Python environment that is linked to <span class='app'>Eclipse</span> as the Python interpreter. The instructions for how to create a virtual python environment in [Anaconda](https://anaconda.org) is covered in my post on [Conda virtual environments](../../prep/prep-conda-environ/).

Once you have installed all the required component for SPIDE and your Eclipse frame project is up and running, the next step is to prepare the solution for [Database connection](../../prep/prep-dblink/).
