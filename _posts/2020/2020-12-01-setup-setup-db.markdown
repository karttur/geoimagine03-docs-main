---
layout: article
title: "Karttur's GeoImagine Framework:<br />Set up the database (setup_db)"
categories: setup
excerpt: "Run the setup_db package to setup the postgres database for Karttur's GeoImagine Framework"
previousurl: setup/setup-geoimagine-basic-install
nexturl: setup/setup-setup-processes
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2020-12-01 T18:17:25.000Z'
modified: '2021-10-01 T14:17:25.000Z'
comments: true
share: true
---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>

## Introduction

In Karttur's GeoImagine Framework both the definition of processes and the metadata for all spatial datasets and layers are stored in a postgreSQL (postgres) database. The database is built up with schemas associated with typical processes, data sources and projection systems. This post explains how to setup the complete database by using the special python package <span class='package'>setup_db</span> and prepared json files defining all the schemas and tables. All <span class='file'>json</span> command files are listed as [web (html) documents](https://karttur.github.io/geoimagine03-docs-setup_db/) and in the [GitHub repo <span class='repo'>geoimagine03-setup_db</span>](https://github.com/karttur/geoimagine03-setup_db/tree/main/doc/jsonsql).

This post is a step by step manual for separate downloading and then running the Framework python package <span class='package'>setup_db</span>. You can also [import the complete Framework](../../putinplace/) (using a range of different approaches) and then run <span class='package'>setup_db</span>. Even if you restore the database using postgres, as suggested in the next paragraph, you need to setup the <span class='package'>setup_db</span> package.

If you intend to use the Framework with predefined settings, you can build the complete database using one of the built-in postgres restore functions, explained in the post on [Database backup and restore](../setup-db-processes). With the latter alternative you can skip the rest of this post and move on to [Set up custom system](../setup-custom-system/).

## Prerequisites

You must have the complete Spatial Data Integrated Development Environment (SPIDE) installed as described in the blog [Install and setup spatial data IDE](https://karttur.github.io/setup-ide/).

## Setup database

The blogpost [Connect Python and PostgreSQL using psycopg2](https://karttur.github.io/setup-ide/blog/connect-with-psycopg2/) contains a script for creating databases in postgres using Python. And the blogpost [Postgres setup with Python & xml](https://karttur.github.io/setup-ide/blog/setup-db-karttur/) describes how to combine **xml** and python to create tables. More recent versions of the Framework instead use <span class='file'>json</span> objects for parameterisation. But if you want to understand the principles behind the framework package <span class='package'>setup_db</span>, the blog posts above explains just that.

## db_setup python package

The framework v3.0 package [setup_db is available on GitHub](https://github.com/karttur/geoimagine03-setup_db/) (click the link or see the figure below) and contains the complete structure for setting up the Framework postgres database.

The [<span class='package'>db_setup</span>](https://karttur.github.io/geoimagine03-docs-setup_db/) package contains five <span class='file'>.py</span> files, the standard modules <span class='package'>\_\_init\_\_.py</span> and <span class='package'>version.py</span>, plus one main module, one class module and one module that reads <span class='file'>json</span> files:

- setup_db_main.py
- setup_db_class.py
- paramjson_mini.py

The package also contains a subfolder called [<span class='file'>doc</span>](https://github.com/karttur/geoimagine03-setup_db/tree/main/doc) that contains 4 text files:

- db_karttur_setup_YYYYMMD.txt
- db_karttur_setup-easegrid_YYYYMMDD.txt
- db_karttur_dbusers_YYYMMDD.txt
- db_karttur_delete_YYYYMMDD.txt

The file <span class='file'>db_karttur_setup_YYYYMMD.txt</span> lists, in sequence, all the json objects (files) to execute for installing the basic postgres schemas and tables. Optionally you can install the tables that define the [Equal-Area Scalable Earth (EASE) Grid version 2.0](https://nsidc.org/data/ease), schema and tables with the file <span class='file'>db_karttur_setup-easegrid_YYYYMMDD.txt</span>. The file <span class='file'>db_karttur_dbusers_YYYMMDD.txt</span> links to the installation of all the database roles (users). If you want to change the default users and passwords you need to edit the linked json file. The last file <span class='file'>db_karttur_delete_YYYYMMDD.txt</span> links to a json command file that empties all the content of the database and removes all tables and schemas.

Under the <span class='file'>doc</span> directory there is also a sub-directory, [<span class='file'>jsonsql</span>](https://github.com/karttur/geoimagine03-setup_db/tree/main/doc/jsonsql), that contains all the json files listed in <span class='file'>txt</span>. The same json command files are also available as [web (html) documents](https://karttur.github.io/geoimagine03-docs-setup_db/).

### Download the package

Go to the GitHub repo for [geoimagine03-setup_db](https://github.com/karttur/geoimagine03-setup_db/). Click the <span class='button'>Code</span> button and then <span class='textbox'>Download ZIP</span>.

<figure>
<img src="../../images/github_code_download_setup-db.png">
<figcaption>Download setup_db from GitHub</figcaption>
</figure>

### Create a hierarchical python package in eclipse

Start <span class='app'>Eclipse</span>. Create a project (call it what you want):

<span class='menu'>File : New : Project : PyDev project</span>

Create a new PyDev Package and call it 'geoimagine':

<span class='menu'>File : New : PyDev Package</span>

Create a new sub-package and call it 'db_setup':

<span class='menu'>File : New : PyDev Package</span>

In the dialog window you should see the main package ('geoimagine') already filled (<span class='textbox'>geoimagine</span>). Use Python syntax and add a dot (.) followed by the name of the sub-package ('db_setup') (<span class='textbox'>geoimagine.db_setup</span>).

Use the <span class='app'>Finder</span> and navigate to the download/clone of the <span class='package'>setup_db</span> package, mark all of the content and drop them in the newly created sub-package in the navigation frame of <span class='app'>Eclipse</span>.

You should now have a sub-package with a file structure that looks similar to this:

```
.
├── LICENSE
├── README.md
├── __init__.py
├── paramjson_mini.py
├── setup_db_class.py
├── setup_db_main.py
├── version.py
└── doc
   ├── db_karttur_dbusers_20211018.txt
   ├── db_karttur_delete_20211202.txt
   ├── db_karttur_setup-easegrid_20211018.txt
   ├── db_karttur_setup_20211018.txt
   └── jsonsql
       ├── EASE2N_template_v090_sql.json
       ├── EASE2N_v090_sql.json
       ├── EASE2S_template_v090_sql.json
       ├── EASE2S_v090_sql.json
       ├── MODISpolar_template_v090_sql.json
       ├── MODISpolar_v090_sql.json
       ├── SMAP_products_v090_sql.json
       ├── SMAP_template_v091_sql.json
       ├── SMAP_v090_sql.json
       ├── ancillary_v090_sql.json
       ├── climateindexes_v090_sql.json
       ├── compositions_ancillary_v090_sql.json
       ├── compositions_ease2_v090_sql.json
       ├── compositions_export_v090_sql.json
       ├── compositions_landsat_v090_sql.json
       ├── compositions_modis_v090_sql.json
       ├── compositions_modispolar_v090_sql.json
       ├── compositions_regions_v090_sql.json
       ├── compositions_sentinel_v090_sql.json
       ├── compositions_smap_v090_sql.json
       ├── compositions_specimen_v090_sql.json
       ├── compositions_system_v090_sql.json
       ├── db-delete_v090.json
       ├── db-dump_v090.json
       ├── default_system_regions_v090_sql.json
       ├── ease2_schema_v090_sql.json
       ├── ease_tile_regions_v090_sql.json
       ├── ease_tilecoords_v090_sql.json
       ├── endmember_v090_sql.json
       ├── general_GDAL_v090_sql.json
       ├── general_GDALtypes_v090_sql.json
       ├── general_grant_karttur_v090_sql.json
       ├── general_processes_v090_sql.json
       ├── general_processeschain_v090_sql.json
       ├── general_records_v090_sql.json
       ├── general_schema_v090_sql.json
       ├── landsat_scenecoords_v090_sql.json
       ├── landsat_scenes_bands_v090_sql.json
       ├── landsat_templates_v090_sql.json
       ├── landsat_tilecoords_v090_sql.json
       ├── landsat_usgs_meta_v090_sql.json
       ├── layout_v090_sql.json
       ├── modis_daacdata_v090_sql.json
       ├── modis_scenes_bands_v090_sql.json
       ├── modis_template_v090_sql.json
       ├── modis_tile_regions_v090_sql.json
       ├── modis_tilecoords_v090_sql.json
       ├── modis_tiles_v090_sql.json
       ├── process_default-comp-naming_v090_sql.json
       ├── regions_v090_sql.json
       ├── sentinel_scenes_bands_v090_sql.json
       ├── sentinel_template_v090_sql.json
       ├── sentinel_tilecoords_v090_sql.json
       ├── soilmoisture_v090_sql.json
       ├── specimen_satdata_v090_sql.json
       ├── specimen_satdata_v80_sql.json
       ├── specimen_v090_sql.json
       ├── system_regions_v090_sql.json
       ├── system_v090_sql.json
       ├── topo_v090_sql.json
       ├── user_projects_v090_sql.json
       ├── user_super_v090_sql.json
       └── users_v090_sql.json

```

### Package processes

The database setup is accomplished through a set of special processes:

- createschema
- createtable
- tableinsert
- tableupdate
- grant
- deletedatabase

These processes are **not** defined in the database itself and can only be run from the package <span class='package'>setup_db</span>.

### setup_db_main.py

In <span class='module'>setup_db_main.py</span> there are predefined commands and links in the main section that are used to setup the entire database. You do not need to edit any of these files unless you want to change the default roles (users) as explained in the preparation post on [Database connections](../../prep/prep-dblink/).

#### Create main production db

If you accept all the default settings all you have to do is to open <span class='module'>setup_db_main.py</span>
and then run the module from the <span class='app'>Eclipse</span> menu <span class='menu'>Run : run</span>.

If you want to customise the setup, you need to edit the in the json command files and also under the "\_\_main\_\_" section of <span>class='module'>setup_db_main.py</span>. If you want to check the database or change/add superuser(s) please refer to the post on [Install PostgreSQL and postGIS](https://karttur.github.io/setup-ide/setup-ide/install-postgres/). If you want to make more substantial changes, all the json command files are listed and linked further down.

```
if __name__ == "__main__":

    '''
    This module should only be run at the very startup of building the Karttur GeoImagine framework.
    To run, remove the comment "#prodDB" and set the name of your production DB ("YourProdDB")
    '''

    # Set the name of the productions db cluster
    # prodDB = 'YourProdDB' #'e.g. postgres or geoimagine
    prodDB = 'geoimagine'

    '''
    SetUpProdDb creates an empty Postgres database.
    '''
    SetUpProdDb(prodDB)

    '''
    SetupSchemasTables creates schemas and tables from json files, with the relative path to the
    json files given in the plain text file "projFPN".
    '''
    projFPN = path.join('doc','db_karttur_setup_20211018.txt')
    SetupSchemasTables(projFPN,prodDB)

    '''
    The command list file doc/db_karttur_setup-easegrid_20211018.txt links to
    a set of json commands that setup the three EASEGRID 2 projection systems, inlcuding tables for MODIS and SMAP data)
    '''
    projFPN = path.join('doc','db_karttur_setup-easegrid_20211018.txt')
    SetupSchemasTables(projFPN,prodDB)

    '''
    #db_karttur_dbusers_YYYYMMDDX.xml adds db users for handling connections to postgres db
    '''
    projFPN = path.join('doc','db_karttur_dbusers_20211018.txt')
    SetupSchemasTables(projFPN,prodDB)

    '''
    #db_karttur_delete_YYYYMMDDX.xml deletes the complete database
    projFPN = path.join('doc','db_karttur_delete_20211202.txt')
    # WARNING - running this command will delete the complete db #SetupSchemasTables(projFPN,prodDB)
    '''
```

#### Setup default schemas and tables

The json commands for setup of default schemas and tables are defined are linked via the text file <span class='file'>db_karttur_setup_YYYYMMDD.txt</span>. To inspect the content of the json command files, toggle the <span class='button'>Hide/Show</span> button and click on the json file names.

<button id= "togglesetuptxt" onclick="hiddencode('setuptxt')">Hide/Show db_karttur_setup_YYYYMMDD.txt</button>

<div id="setuptxt" style="display:none">

{% capture text-capture %}
{% raw %}

\# Install the default database schemas
[general_schema_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-general_schema/)

\# Install tables for handling paths and processes
[general_processes_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-general_processes/)

\# Install tables for default naming of subprocesses destination layers
[process_default-comp-naming_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-process_default-comp-naming/)

\# Add records for super users and the process for managing all other processes
[general_records_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-general_records/)

\# Install and fill the tables that define the different cell types and file types that the system can handle
[general_GDALtypes_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-general_GDALtypes/)

\# Install the automated processing chains tables
[general_processeschain_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-general_processeschain/)

\# Install the tables for defining ancillary compositions
[compositions_ancillary_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-compositions_ancillary/)

\# Install the tables for defining export compositions
[compositions_export_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-compositions_export/)

\# Install the tables for defining landsat compositions
[compositions_landsat_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-compositions_landsat/)

\# Installs the tables for defining modis compositions
[compositions_modis_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-compositions_modis/)

\# Installs the tables for defining modis-polar compositions
[compositions_modispolar_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-compositions_modispolar/)

\# Installs the tables for defining region compositions
[compositions_regions_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-compositions_regions/)

\# Install the tables for defining sentinel compositions
[compositions_sentinel_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-compositions_sentinel/)

\# Installs and fills tables for DAAC SMAP data holdings
[SMAP_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-SMAP/)

\# Installs the tables for defining smap compositions
[compositions_smap_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-compositions_smap/)

\# Installs the tables for defining specimen compositions
[compositions_specimen_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-compositions_specimen/)

\# Install the tables for defining system compositions
[compositions_system_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-compositions_system/)

\# Install region tables for the default systems
[default_system_regions_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-default_system_regions/)

\# Install the tables that defines ancillary data sources
[ancillary_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-ancillary/)

\# Add coordinates for landsat tiles
[landsat_scenecoords_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-landsat_scenecoords/)

\# Install tables for landsat scenes, bands and masks
[landsat_scenes_bands_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-landsat_scenes_bands/)

\# Install landsat template table
[landsat_templates_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-landsat_templates/)

\# Add tables for layout
[layout_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-layout/)

\# MODIS regional tiles for land and continents
[modis_tile_regions_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-modis_tile_regions/)

\# Add tables for tiles both online datapool and locally downloaded and processed
[modis_daacdata_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-modis_daacdata/)

\# Add the table for holding all scenes available at the datapool and tables for local MODIS data holdings
[modis_scenes_bands_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-modis_scenes_bands/)

\# Install MODIS template table, and add records for the MODIS products in use
[modis_template_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-modis_template/)

\# Add table for MDOIS tile coordinates
[modis_tilecoords_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-modis_tilecoords/)

\# Install tables that hold system default regions and categories
[system_regions_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-system_regions/)

\# Install tables that hold regions
[regions_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-regions/)

\# User projects - defines users and user projects
[user_projects_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-user_projects/)

\# Install tables that hold all the system users
[users_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-users/)

\# Add superusers of the system,
[user_super_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-user_super/)

\# Adds the schema and table for climate indexes
[climateindexes_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-climateindexes/)

\# Add tables for sentinel scenes, granules bands
[sentinel_scenes_bands_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-sentinel_scenes_bands/)

\# Add the coordinates for sentinel tiles
[sentinel_tilecoords_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-sentinel_tilecoords/)

\# Add the sentinel tile templates
[sentinel_template_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-sentinel_template/)

\# Create table for SMAP products and inserts records
[SMAP_products_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-SMAP_products/)

\# Add the SMAP product templates
[SMAP_template_v091_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-SMAP_template_v091_sql.json/)

\# Add tables for MODIS polar datasets
[MODISpolar_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-MODISpolar/)

\# MODISpolar templates (identical to SMAP templates)
[MODISpolar_template_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-MODISpolar_template/)

\# Create soilmoisture tables
[soilmoisture_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-soilmoisture/)

{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html  toggle-text=text-capture  %}
</div>

#### Setup EASE-grid 2 schema and tables

The json commands for setup of the schema and tables for the EASE-grid 2.0 projection system are defined linked via the text file <span class='file'>db_karttur_setup-easegrid_YYYYMMDD.txt</span>. To inspect the content of the json command files, toggle the <span class='button'>Hide/Show</span> button and click on the json file names.

<button id= "toggleeaseuptxt" onclick="hiddencode('easeuptxt')">Hide/Show db_karttur_setup-easegrid_YYYYMMDD.txt</button>

<div id="easeuptxt" style="display:none">

{% capture text-capture %}
{% raw %}

\# Install schema for EASEGRID 2
[ease2_schema_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-ease2_schema/)

\# Install the tables defining all EASEGRID compositions
[compositions_ease2_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-compositions_ease2/)

\# Table for EASEGRID 2 regional tiles
[ease_tile_regions_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-ease_tile_regions/)

\# Table for EASEGRID 2 tile coordinates
[ease_tilecoords_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-ease_tilecoords/)

\# Table for templates EASE GRID north
[EASE2N_template_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-EASE2N_template/)

\# Table for EASE GRID north
[EASE2N_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-EASE2N/)

\# Table for templates EASE GRID south
[EASE2S_template_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-EASE2S_template/)

\# Table for EASE GRID south
[EASE2S_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-EASE2S/)

{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html  toggle-text=text-capture  %}
</div>

#### Add default users

The json commands for adding default users to the Framework are defined linked via the text file <span class='file'>db_karttur_dbusers_20211018.txt</span>. Only a single json is linked <span class='file'>general_grant_karttur_v090_sql.json</span>. The json command file contains all the database roles and rights, including passwords. You need to edit the passwords to match the <span class='file'>.netrc</span> file that is used for accessing the database at runtime.

To inspect the content of the single linked json command file, toggle the <span class='button'>Hide/Show</span> button and click on the json file names.

<button id= "toggleuseruptxt" onclick="hiddencode('useruptxt')">Hide/Show db_karttur_setup-easegrid_YYYYMMDD.txt</button>

<div id="useruptxt" style="display:none">

{% capture text-capture %}
{% raw %}

\# Add db users for handling connections to postgres db
[general_grant_karttur_v090_sql.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-general_grant_karttur/)

{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html  toggle-text=text-capture  %}
</div>

#### Delete database

The last lines under the \_\_main\_\_" section link to the text file <span class='file'>db_karttur_delete_YYYYMMDD.txt</span>. If you run the commands in the linked json file, the complete content of the database will be erased. To inspect the content of the single linked json command file, toggle the <span class='button'>Hide/Show</span> button and click on the json file names.

<button id= "toggledeleteuptxt" onclick="hiddencode('deleteuptxt')">Hide/Show db_karttur_delete_YYYYMMDD.txt</button>

<div id="deleteuptxt" style="display:none">

{% capture text-capture %}
{% raw %}

\# Delete the complete database
[db-delete_v090.json](https://karttur.github.io/geoimagine03-docs-setup_db/setup_db/setup_db-jsonsql-db-delete_v090.json/)

{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html  toggle-text=text-capture  %}
</div>

#### Superusers and process for setting up all other processes

The package <span class='package'>db_setup</span> also installs the system superuser and two processes: [_addrootproc_](../../subprocess/subproc-addrootproc/) and [_addsubproc_](../../subprocess/subproc-addsubproc/). Having access to the superuser and the two processes, all other processes can be installed using the package [<span class='package'>setup_processes</span>](../../package/package-setup_processes/).

## Next step

The next step is [Setup processes part 1](../setup-setup-processes).
