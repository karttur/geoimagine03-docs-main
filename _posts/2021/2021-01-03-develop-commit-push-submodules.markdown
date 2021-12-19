---
layout: article
title: Add, commit and push submodules
categories: develop
tutorial: null
excerpt: "If your Framework PyDev project is not linked to a git origin, this post describes how to add, commit and push changes via the local repo that is linked to a git origin."
previousurl: null
nexturl: null
tags:
  - git
  - submodules
  - update
  - python
  - script
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2021-01-03 T18:17:25.000Z'
modified: '2021-10-19 T18:17:25.000Z'
comments: true
share: true
---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>

## Introduction

If your work with the Framework development has been done using a copy detached from the local clone of your online (e.g. GitHub) repo of the Framework, this post describes how to copy your changes to a local clone and then add, commit and push these changes to your online repo. The solution is a python package that copies all updates to your local clone and that also writes the <span class='app'>Terminal</span> commands for add, commit and push.

## Framework submodule structure

Karttur's GeoImagine Framework available at [GitHub](https://github.com/karttur) is built from a "superproject" (or container) repository with around 40 individual repositories attached as submodules. Each submodule (or repo) contains a customised Python package belonging to the Framework. In the online GitHub repo, each submodule has a 2-part name:

geoimagine*xx*_*package*

where _xx_ is the Framework version (02 when writing this in October 2021), and _package_ is the python package name that is used in the Framework. The conversion in the naming:

geoimagine*xx*_*package* -> *package*

is defined in the superproject as described in the post on [git superproject and submodels](../develop-git-superproject).

## submodule_stage-commit-push_script.py

The python module (script) <span class='module'>submodule_stage-commit-push_script</span> is part of the Framework, and found under the <span class='package'>support</span> package. The parameters required for running the script are given directly in the \_\_main\_\_ section:

```
    copyProject = True

    copyProjectDoc = False

    branch = 'main'

    commitMsg = 'updates oct 2021'

    ignoreL = ['__pycache__','.DS_Store']

    home = os.path.expanduser('~')

    scriptFPN = os.path.join(home, 'submodule_stage_commit_push.sh')

    srcProjectFP = '/Users/thomasgumbricht/eclipse-workspace/2020-03_geoimagine/karttur_v202003/geoimagine'

    gitHubFP = '/Users/thomasgumbricht/GitHub/'

    gitHubAccount = 'karttur'

    prefix = 'geoimagine02'

    submoduleL = ['ancillary','assets','basins','copernicus',
                  'dem','export','exract',
                  'gis','grace','grass','ktgdal',
                  'ktgrass','ktnumba',
                  'ktpandas','landsat','layout',
                  'modis','npproc',
                  'params','postgresdb','projects',
                  'region','sentinel',
                  'setup_db','setup_processes','smap','support',
                  'timeseries','updatedb','userproj',
                  'zipper']

    if copyProject:

        CopyProject()

    WriteScript()
```

Set all the variables and then just run the script. All updated documents will be changed in the destination directory (_gitHubFP_), and a shell script file created under the home directory (_home_). To add, commit and push the changes to the online (origin) repo, run the shell script after the python module is executed. The first lines of the shell script created from the above parameters look like this:

```
cd /Users/thomasgumbricht/GitHub/geoimagine02-ancillary
echo "${PWD}"
git add .
git commit -m "updates oct 2021"
git push origin main
```
