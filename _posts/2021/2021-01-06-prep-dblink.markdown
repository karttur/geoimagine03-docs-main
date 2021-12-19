---
layout: article
title: Database connections
categories: prep
excerpt: "Prepare database connections for Karttur's GeoImagine Framework"
previousurl: null
nexturl: setup/setup-db
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2021-01-06 T18:17:25.000Z'
modified: '2021-10-16 T18:17:25.000Z'
comments: true
share: true
general_grant_v80_sql: general_grant_v80_sql
---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>

# Introduction

This post goes through the steps needed for creating a (fairly) secure link between users, processes and the postgres database of Karttur´s GeoImagine Framework.

# Prerequisites

To follow this post you must have the complete Spatial Data Integrated Development Environment (SPIDE) installed as described in the blog [Install and setup spatial data IDE](https://karttur.github.io/setup-ide/).

# Connect Python and PostgreSQL

Karttur´s GeoImagine Framework relies on a postgres database that holds information on all processes parameters as well as all data. The installation of the postgres database should already have been done as described in the blogpost [Install postgreSQL and postGIS](https://karttur.github.io/setup-ide/setup-ide/install-postgres/). Then you must also have installed and setup <span class='package'>psycopg</span> for connecting Python to postgres. If you followed the post on [Conda virtual environments](../prep-conda-environ), <span class='package'>psycopg</span> will be part of your Python environment.

## Principal solution

At this point you need to set the login and password of the users that will access different parts of the postgres database. In principal each schema of the database is managed by a different role (user), but with some exception and some crossover capacity granted to different roles.

At present the Framework contains the following roles (apart from the superusers):
- processread
- userread
- regionread
- processmanage
- manageregion
- manageuserproj
- manageancillary
- managemodis
- managesenitnel
- managelandsat
- managesmap
- managesoilmoisture
- managelayout
- manageexport

The actual running of the process and setting up of the roles is covered in the setup post on [Set up the database (setup_db)](../../setup/setup-db/). And is done from within the Framework itself. This post only describes how to define the roles, both in a json file (that will be accessed from the Framework when defining the roles in the post as explained in the post on [Set up the database (setup_db)](../../setup/setup-setup-db/)) and in the system default <span class='file'>.netrc</span> file used for storing the passwords associated with each role.

### Defining roles

The json file that defines the database roles is included in the [GitHub repo geoimagine02-setup_db](https://github.com/karttur/geoimagine02-setup_db) package under the path [<span class='file'>doc/jsonsql/general_grant_v090_sql.json</span>](https://github.com/karttur/geoimagine02-setup_db/tree/master/doc/jsonsql). The content of this json file is also available under <span class='button'>"Hide/show"</span> button below. You need to create your own copy of this file and set your own passwords for each role. If you want to change the principal system solution with one role for each schema, say to a single role dealing with everything, you can do that by giving all the rights to the same role. And then also give this role as the "HOST" in each module under the package [<span class='package'>postgresdb</span>](../../package/package-postgresdb/).

Note that the process <span class='package'>grant</span> is not defined in the database, but a stand alone process and can only be run from the package [<span class='package'>setup_db</span>](../../package/package-setup_db/). Explained in detail in the setup post on [Set up the database (setup_db)](../../setup/setup-setup-db/).

{% capture foo %}{{page.general_grant_v80_sql}}{% endcapture %}
{% include xml/general_grant_v80_sql.html foo=foo %}

### Login and password (.netrc)

Karttur's GeoImagine Framework standard solution for database access at runtime is to read the credentials from a <span class='file'>.netrc</span> file. You have to create your own <span class='file'>.netrc</span> file that gives the same roles and passwords as you gave in the xml file above. The <span class='file'>.netrc</span> file should be in your home folder and you can edit it by using <span class='terminalapp'>pico</span>. You can copy, paste and edit the text under the <span class='button'>"Hide/show"</span> button below to your own <span class='file'>.netrc</span> file.

<span class='terminal'>$ pico .netrc</span>

<button id= "togglenetrc" onclick="hiddencode('netrc')">Hide/Show .netrc</button>

<div id="netrc" style="display:none">

{% capture text-capture %}
{% raw %}

```
machine localhost0 login superuser password abc
machine localhost1 login produser  password abc
machine usermanager login usermanager password abc
machine managelayout login managelayout password abc
machine managemodis login managemodis password abc
machine manageregion login manageregion password abc
machine formatread login formatread password abc
machine regionread login regionread password abc
machine manageancillary login manageancillary abc
machine managesentinel login managesentinel password abc
machine managesoilmoisture login managesoilmoisture password abc
machine managelandsat login managelandsat password abc
machine managesmap login managesmap password abc
machine manageexport login manageexport password abc
machine ManageUserProj login manageuserproj password abc
```
{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html toggle-text=text-capture  %}
</div>

## Before the next steps

You should now have corresponding roles, passwords and rights for operating the Framework database. In summary:

1. Roles, passwords and their granted rights are defined in a json file.
2. Different roles are used for accessing and editing different schemas in the database. The linking of processes and database roles is hardcoded, and to change that you need to edit the modules in the <span class='package'>postgresdb</span> package.
3. At runtime the name and password of each role is accessed from a <span class='file'>.netrc</span> file that must have access codes, role names and role passwords that corresponds to the definitions in the xml file and the modules of the <span class='package'>postgresdb</span> package.

If you decided to keep the default roles, role names, passwords and codes, all the parts should correspond. If you changed the name, passwords and grants, the Framework will report errors and you can update any mistakes when you account them.
