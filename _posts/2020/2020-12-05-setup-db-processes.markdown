---
layout: article
title: "Karttur's GeoImagine Framework:<br />Setup processes (setup_processes)<br />Part 3 Database backup and restore"
categories: setup
excerpt: "Backup and restore (setup) alternatives for the Postgres database"
previousurl: setup/setup-custom-system
nexturl: setup/setup-setup-processes-regions
tags:
 - addsubproc
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2020-12-05 T18:17:25.000Z'
modified: '2021-11-21 T18:17:25.000Z'
comments: true
share: true
---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>

This post outlines different alternatives for creating Karttur's GeoImagine Framework database in postgres, and filling it with default data, using postgres itself. The postgres commands outlined in this post, together with the prepared files outlined in the last section (below), are thus an alternative to the [setup_db](../setup-setup-db/) commands to create the postgres database. If you want to create a customized postgres database, then you need to revert to the original definitions in [setup_db](../setup-setup-db/).

## Introduction

The backbone keeping all the data and processes together in Karttur's GeoImagine Framework is a PostgreSQL database. If you build the Framework from scratch, the database is first created in the python package [<span class='package'>setup_db</span>](../setup-setup-db/) and then subsequently filled with data as you [install processes](../setup-setup-processes/) and different [data systems](../setup-setup-processes-regions/). Most processes that you run also add records related to the data layers that are created.

Some of the setup processes used for analysing data and then inserting the results into the database take a long time - including for instance the analysis of spatial relations between different geographic regions and the tiling system of the different projection systems. Instead of running these processes you can insert the database records using prepared files that can be used by PostgreSQL itself for creating and updating the Framework database.

## Prerequisites

You must have installed Karttur's GeoImagine Framework. If you need to Install PostgreSQL (or postgres for short) this is outlined in the post [Install postgreSQL and postGIS](https://karttur.github.io/setup-ide/setup-ide/install-postgres/).

## PostgreSQL database

The most advanced alternative for backup and restoring both the definitions (sometimes called _schemas_, but schema also denotes a subset of tables within a database) and data of a postgres database, is to use the command pairs of _pg\_dump_ and _pg\_restore_ or _psql_. The second alternative is to write the results of an ordinary _SELECT_ query to a comma-separated values (csv) file. The content of the csv file can then be imported to the db either by an ordinary sql command _INSERT_ adding line by line, or _COPY_ to read and add the whole file in one go. The latter alternative can not be used for defining the database, only for adding data to predefined schemas and tables.

### pg_dump

[_pg\_dump_](https://www.postgresql.org/docs/13/app-pgdump.html) is a versatile utility for PostgreSQL database backup. Digestible instructions are available at for example [stackoverflow](https://stackoverflow.com/questions/14486241/how-can-i-export-the-schema-of-a-database-in-postgresql) and [SimpleBackups](https://simplebackups.com/blog/postgresql-pgdump-and-pgrestore-guide-examples/). [This post on stackoverflow](https://stackoverflow.com/questions/2732474/restore-a-postgres-backup-file-using-the-command-line) outlines the differences between restoring with  _pg\_restore_ and _psql_, and how to parameterise _pg\_dump_ for either alternative.

In Karttur's GeoImagine Framework, there are three different processes that binds to _pg\_dump_:

- [DumpTableSQL](#) for backup of single tables,
- [DumpSchemaSQL](#) for backup of a schemas (schema as a collection of tables), and
- [DumpDatabaseSQL](#) for backup of an entire database.

[_pg\_dump_](https://www.postgresql.org/docs/13/app-pgdump.html) has a range of options; the Framework processes binding to _pg\_dump_, however, only allow for setting the options for _Format_ (\-F or \-\-format), _Data only_ (\-a or \-\-data\-only) and _Schema only_ (\-s or \-\-schema\-only_). _Data only_ and _Schema only_ (or definition only) are each others inverse, and can thus not be used together. In the Framework _Schema only_ is invoked by setting the parameter _definitiononly_ to _true_, _Data only_ by setting the parameter _dataonly_ to _true_. If both are set to false, the complete definition (schema) and data are backed up. The default format is _c_, that generates custom dump files that can be used for restoring the database  by calling _pg\_restore_, if you prefer to use <span class='terminalpp'>psql</span> for restoring, then you should use the _Format_ _p_ (plain) setting.

To run directly from the python package, the operating system link to _pg\_dump_ (and _pg\_restore_/_psql_) must be set in order for the system command to be executed in runtime. If you have trouble in linking the path to _pg\_dump_ in your system setup, you can use the parameter _cmdpath_ to set an explicit path to _pg\_dump_ (and _pg\_restore_). For my postgres installation using Homebrew I need to set \"cmdpath\":\"/usr/local/bin\".

### pg_restore

 There are three corresponding Framework processes binding to _pg\_restore_:

- [RestoreTableSQL](#) for restoring of single tables,
- [RestoreSchemaSQL](#) for restoring of a schema (collection of tables), and
- [RestoreDatabaseSQL](#) for restoring of an entire database.

The three restoration processes actually calls the same internal process under the hood of the Framework, the only difference is that the three different processes look for different backup (dump) files. The default _Format_ for all three processes is set to _c_, and thus the restoration process is defaulted to _pg\_restore_.

### Export table data as csv

In the Framework, all postgres database tables can be exported using a standard _SELECT_ query and then writing the results to a csv file. There are three different Framework processes for exporting table data as csv files:

- [ExportTableCsv](#) for exporting of single tables,
- [ExportSchemaCsv](#) for exporting all tables of a schema (collection of tables), and
- [ExportDatabaseCsv](#) for exporting all tables of a database.

In comparison with the _pg\_dump_ processes, the export functions can only save data; and data is always saved for each individual table. Thus the processes _ExportSchemaCsv_ and _ExportDatabaseCsv_ loop over and process individual tables. These two processes can only save the complete data from a table. With the process _ExportTableCsv_ the columns and records to save can be set by listing the columns and apply a _WHERE_ statement.

### Import table data from csv files

Corresponding to the processes for exporting table data as csv, the Framework has different processes for importing csv data to the database. There are two sets of processes, using ordinary database _INSERT_ and using _COPY_ that reads the complete csv in one go. _INSERT_ is better to use when filling up a table that already contains some data:

- [InsertTableCsv](#) for inserting data of single tables,
- [InsertSchemaCsv](#) for inserting data to all tables of a schema, and
- [InsertDatabaseCsv](#) for inserting data to all tables of a database.

The postgres _COPY_ command is faster, but the table can not contain any of the records listed in the csv, _COPY_ is thus best suited for filling a new table or replacing (by setting the parameter _overwrite_ to _true_) all records in an existing table:

- [CopyTableCsv](#) for inserting data of single tables,
- [CopySchemaCsv](#) for inserting data to all tables of a schemas, and
- [CopyDatabaseCsv](#) for inserting data to all tables of a database.

### Setup_processes linked commands

The package <span class='package'>setup_processes</span> is prepared for both dumping (and exporting) and restoring (importing) the complete Framework database. In the \_\_main\_\_ section of <span class='module'>setup_process_main</span> you can either backup or restore the complete Framework database by removing the comment sign. The default path for both commands is directly under the package <span class='package'>setup_processes</span> itself. When you cloned (copied) the database from Karttur's GitHub repo, the default database backup is included in several formats (oulined in detail below).

If you want to make a fresh backup the database, remove the comment sign ("#") for _#BackupDatabase(prodDB)_. To restore the complete default database, uncomment _RestorepDatabase(prodDB)_.

```
    # BackupDatabase creates a backup of the entire db in different formats
    #BackupDatabase(prodDB)

    # RestoreDatabase restores of the entire using psql
    #RestorepDatabase(prodDB)
```


#### BackupDatabase

The function _BackupDatabase_ links to <span class='file'>backup_karttur_db_YYYYMMDD.txt</span>. Inspect its content by toggling the <span class='button'>Hide/Show</span> button and click on the linked json file name.

<button id= "toggleBackupDatabase" onclick="hiddencode('BackupDatabase')">Hide/Show backup_karttur_db_YYYYMMDD.txt</button>

<div id="BackupDatabase" style="display:none">

{% capture text-capture %}
{% raw %}

Dump (as sql) and export (as csv) all Framework database schemas and tables
[db-dump-all_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-db-dump-all/)

{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html toggle-text=text-capture  %}
</div>

Running the json command file (<span class='file'>db-dump-all_v090.json</span>) on 4th December 2021 generated the backup structure under the <span class='button'>Hide/Show</span> button.

<button id= "toggleBackupTree" onclick="hiddencode('BackupTree')">Hide/Show backup tree</button>

<div id="BackupTree" style="display:none">

{% capture text-capture %}
{% raw %}
```
└── geoimagine
    ├── ancillary
    │   ├── authors
    │   ├── compdef
    │   │   └── csv-geoimagine-ancillary-compdef_2021-12-04.csv
    │   ├── compprod
    │   │   └── csv-geoimagine-ancillary-compprod_2021-12-04.csv
    │   ├── datasets
    │   │   └── csv-geoimagine-ancillary-datasets_2021-12-04.csv
    │   ├── dscompid
    │   │   └── csv-geoimagine-ancillary-dscompid_2021-12-04.csv
    │   ├── dslayers
    │   └── layer
    │       └── csv-geoimagine-ancillary-layer_2021-12-04.csv
    ├── c-geoimagine-data_2021-12-04.sql
    ├── c-geoimagine-definition_2021-12-04.sql
    ├── c-geoimagine_2021-12-04.sql
    ├── climateindex
    │   ├── climindex
    │   └── indexmeta
    ├── ease2n
    │   ├── compdef
    │   ├── compprod
    │   ├── layer
    │   ├── mask
    │   ├── products
    │   │   └── csv-geoimagine-ease2n-products_2021-12-04.csv
    │   ├── regions
    │   │   └── csv-geoimagine-ease2n-regions_2021-12-04.csv
    │   ├── template
    │   │   └── csv-geoimagine-ease2n-template_2021-12-04.csv
    │   ├── tilecoords
    │   │   └── csv-geoimagine-ease2n-tilecoords_2021-12-04.csv
    │   └── urldata
    ├── ease2s
    │   ├── compdef
    │   ├── compprod
    │   ├── layer
    │   ├── mask
    │   ├── products
    │   │   └── csv-geoimagine-ease2s-products_2021-12-04.csv
    │   ├── regions
    │   │   └── csv-geoimagine-ease2s-regions_2021-12-04.csv
    │   ├── template
    │   │   └── csv-geoimagine-ease2s-template_2021-12-04.csv
    │   ├── tilecoords
    │   │   └── csv-geoimagine-ease2s-tilecoords_2021-12-04.csv
    │   └── urldata
    ├── ease2t
    │   ├── compdef
    │   ├── compprod
    │   ├── layer
    │   ├── mask
    │   ├── regions
    │   └── tilecoords
    ├── export
    │   ├── compdef
    │   ├── compprod
    │   ├── layer
    │   └── legend
    ├── landsat
    │   ├── banddos
    │   ├── bands
    │   ├── compdef
    │   ├── compprod
    │   ├── dnemiscal
    │   ├── dnreflcal
    │   ├── dossrfi
    │   ├── imgattr
    │   ├── layer
    │   ├── mask
    │   ├── regions
    │   ├── scenecoords
    │   ├── scenedos
    │   ├── scenes
    │   ├── templatelayers
    │   ├── templatescenes
    │   └── wavelengths
    ├── layout
    │   ├── defaultpalette
    │   ├── legend
    │   ├── movieclock
    │   ├── pubtext
    │   ├── rasterpalcolors
    │   ├── rasterpalette
    │   └── scaling
    ├── modis
    │   ├── compdef
    │   ├── compprod
    │   ├── daacdata
    │   ├── datapooltiles
    │   ├── layer
    │   ├── mask
    │   ├── regions
    │   │   └── csv-geoimagine-modis-regions_2021-12-04.csv
    │   ├── template
    │   │   └── csv-geoimagine-modis-template_2021-12-04.csv
    │   ├── tilecoords
    │   │   └── csv-geoimagine-modis-tilecoords_2021-12-04.csv
    │   └── tiles
    ├── modispolar
    │   ├── compdef
    │   ├── compprod
    │   ├── daacdata
    │   ├── daacholdings
    │   ├── layer
    │   └── template
    │       └── csv-geoimagine-modispolar-template_2021-12-04.csv
    ├── p-geoimagine-data_2021-12-04.sql
    ├── p-geoimagine-definition_2021-12-04.sql
    ├── p-geoimagine_2021-12-04.sql
    ├── process
    │   ├── celltypes
    │   │   └── csv-geoimagine-process-celltypes_2021-12-04.csv
    │   ├── chaincompin
    │   ├── chaincompout
    │   ├── chainparams
    │   ├── chainprocess
    │   ├── complabeldefaults
    │   │   └── csv-geoimagine-process-complabeldefaults_2021-12-04.csv
    │   ├── gdalformat
    │   │   └── csv-geoimagine-process-gdalformat_2021-12-04.csv
    │   ├── prcesschain
    │   ├── procdiv
    │   ├── processparams
    │   │   └── csv-geoimagine-process-processparams_2021-12-04.csv
    │   ├── processparamsetminmax
    │   │   └── csv-geoimagine-process-processparamsetminmax_2021-12-04.csv
    │   ├── processparamsetvalues
    │   │   └── csv-geoimagine-process-processparamsetvalues_2021-12-04.csv
    │   ├── procsys
    │   │   └── csv-geoimagine-process-procsys_2021-12-04.csv
    │   ├── rootprocesses
    │   │   └── csv-geoimagine-process-rootprocesses_2021-12-04.csv
    │   └── subprocesses
    │       └── csv-geoimagine-process-subprocesses_2021-12-04.csv
    ├── regions
    │   ├── compdef
    │   ├── compprod
    │   ├── defregions
    │   ├── layer
    │   ├── regions
    │   ├── sites
    │   └── tracts
    │       └── csv-geoimagine-regions-tracts_2021-12-04.csv
    ├── sentinel
    │   ├── bands
    │   ├── compdef
    │   ├── compprod
    │   ├── granulemeta
    │   ├── granules
    │   ├── granuletiles
    │   ├── layer
    │   ├── mask
    │   ├── metatranslate
    │   │   └── csv-geoimagine-sentinel-metatranslate_2021-12-04.csv
    │   ├── mgrscoords
    │   ├── regions
    │   ├── template
    │   │   └── csv-geoimagine-sentinel-template_2021-12-04.csv
    │   ├── tilecoords
    │   ├── tilemeta
    │   ├── tiles
    │   └── vectorsearches
    ├── smap
    │   ├── compdef
    │   ├── compprod
    │   ├── daacdata
    │   ├── daacholdings
    │   │   └── csv-geoimagine-smap-daacholdings_2021-12-04.csv
    │   ├── layer
    │   ├── products
    │   │   └── csv-geoimagine-smap-products_2021-12-04.csv
    │   └── template
    │       └── csv-geoimagine-smap-template_2021-12-04.csv
    ├── soilmoisture
    │   ├── am05
    │   ├── ammax
    │   ├── daily05
    │   ├── dailymax
    │   ├── datasets
    │   ├── evening05
    │   ├── eveningmax
    │   ├── networks
    │   ├── noon05
    │   ├── noonmax
    │   ├── pm05
    │   ├── pmmax
    │   └── stations
    ├── specimen
    │   ├── compdef
    │   ├── compprod
    │   ├── dscompid
    │   └── layer
    ├── system
    │   ├── compdef
    │   │   └── csv-geoimagine-system-compdef_2021-12-04.csv
    │   ├── compprod
    │   │   └── csv-geoimagine-system-compprod_2021-12-04.csv
    │   ├── defregions
    │   │   └── csv-geoimagine-system-defregions_2021-12-04.csv
    │   ├── layer
    │   │   └── csv-geoimagine-system-layer_2021-12-04.csv
    │   ├── regioncats
    │   │   └── csv-geoimagine-system-regioncats_2021-12-04.csv
    │   ├── regions
    │   │   └── csv-geoimagine-system-regions_2021-12-04.csv
    │   ├── regionsease2n
    │   ├── regionsease2s
    │   ├── regionsease2t
    │   ├── regionsmodis
    │   ├── regionssentinel
    │   └── regionswrs
    └── userlocale
        ├── linkprojregion
        │   └── csv-geoimagine-userlocale-linkprojregion_2021-12-04.csv
        ├── organisations
        ├── projancil
        ├── projkeywords
        ├── projlevels
        │   └── csv-geoimagine-userlocale-projlevels_2021-12-04.csv
        ├── themeids
        ├── usercats
        │   └── csv-geoimagine-userlocale-usercats_2021-12-04.csv
        ├── userprojects
        │   └── csv-geoimagine-userlocale-userprojects_2021-12-04.csv
        └── users
            └── csv-geoimagine-userlocale-users_2021-12-04.csv
```

{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html toggle-text=text-capture  %}
</div>

### Restoring from prepared dump and csv files

The [Framework GitHub repo](https://github.com/karttur/geoimagine03frame) package <span class='package'>setup_processes</span> contains a sub-folder called <span class='file'>dbdump</span>, under which you find all the dump (sql) and text (csv) files required to create the Framework database (listed above under the <span class='button'>Hide/Show</span> button). The Framework database can have any name, but the default name is _geoimagine_, and that is also the name of the single sub-folder under <span class='file'>dbdump</span>. The complete database, all schemas and tables with data, are hierarchically organised under _geoimagine_. Thus the <span class='files'>.sql</span> files that can be called by either _pg\_restore_ or _psql_ to restore the complete database are directly under the <span class='file'>geoimagine</span> folder:

- c-geoimagine_yyyy-mm-dd.sql
- c-geoimagine-data_yyyy-mm-dd.sql
- c-geoimagine-definition_yyyy-mm-dd.sql
- p-geoimagine_yyyy-mm-dd.sql
- p-geoimagine-data_yyyy-mm-dd.sql
- p-geoimagine-definition_yyyy-mm-dd.sql

The first letter of the files indicates whether the sql is formatted as \[c\]ustom (for _pg\-restore_) or \[p\]lain (for _psql_). Both alternatives were tested in November 2021, for both MacOS and Windows. With varying results.

#### MacOS

While _psql_ could be run parameterised with any of the three \[p\] sql files, _pg\-restore_ did not function with the combined sql (_c-geoimagine_yyyy-mm-dd.sql_), but the database could be restored by sequentially running _c-geoimagine-definition_yyyy-mm-dd.sql_ followed by _c-geoimagine-data_yyyy-mm-dd.sql_. The complete sequence of creating (or restoring) the Framework database using postgres itself thus becomes:

- 1a. Create a new postgres database ("geoimg02"):
- <span class='terminal'>$ psql geoimg02</span>
- 1b. If you need to setup a user (role) for the database ("karttur" in this example):
- <span class='terminal'>$ CREATE USER karttur WITH LOGIN PASSWORD \'quoted password\' SUPERUSER CREATEDB CREATEROLE;</span>
- 1c. quite the _psql_ session before running the restoration commands:
- <span class='terminal'>$ \\q</span>
- 2a Restore the Framework db to "geoimg02" using _psql_:
- <span class='terminal'>$ psql -U karttur -d geoimg03 < /path/to/dbdump/geoimagine/p-geoimagine_yyyy-mm-dd.sql</span>
- or
- 2b Run the definition and data adding in two separate steps with _pg\-restore_:
- <span class='terminal'>$ psql -U karttur -d geoimg02 < /path/to/dbdump/geoimagine/c-geoimagine-definition_yyyy-mm-dd.sql</span>
- <span class='terminal'>$ psql -U karttur -d geoimg02 < /path/to/dbdump/geoimagine/c-geoimagine-data_yyyy-mm-dd.sql</span>

#### Windows

For Windows we did not manage to restore the database using the terminal commands. But restoring using _psql_ via the free version of <span class='app'>tableplus</span> and _p-geoimagine_yyyy-mm-dd.sql_ worked flawlessly.

#### RestoreDatabase using _setup_processes_

You can also use the function _RestoreDatabase_ from the \_\_main\_\_ section of <span class='module'>setup_process_main</span>. However, before you remove the comment sign, make sure that you define the kid of restore command you want to run. In order not to overwrite any existing records you need to carefully read the options for using psql, pg-restore INSERT and COPY in the manual pages of your version of PostgreSQL.

You can bypass any conflicts by setting up a completely new database, in which case you will not overwrite any existing data. And then just run the framework with the novel database. The default command files lined in the <span class='package'>setup_processes</span> has both _dataonly_ and _definitiononly_ set to _true_, which is not allowed and causes an error report. That means that to actually use the _RestoreDatabase_ function you **must** edit the command file before it can be used.

 Link to <span class='file'>restore_karttur_db_YYYYMMDD.txt</span>. Inspect its content by toggling the <span class='button'>Hide/Show</span> button and click on the linked json file name.

<button id= "toggleRestoreDatabase" onclick="hiddencode('RestoreDatabase')">Hide/Show restore_karttur_db_YYYYMMDD.txt</button>

<div id="RestoreDatabase" style="display:none">

{% capture text-capture %}
{% raw %}

Restore (as sql) and import (csv) all Framework database schemas and tables
[db-restore-all_v090.json](https://karttur.github.io/geoimagine03-docs-setup_processes/setup_processes/setup_processes-json-db-restore-all/)


{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html toggle-text=text-capture  %}
</div>

## Next step

The next step is adding [default regions](../setup-setup-processes-regions).
