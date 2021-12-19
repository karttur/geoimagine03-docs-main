---
layout: article
title: GitHub Submodules with git
categories: develop
excerpt: Create submodules and a superproject using git
previousurl: develop/develop-github-eclipse
nexturl: prep/prep-dblink/
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2020-11-10 T18:17:25.000Z'
modified: '2021-10-18 T18:17:25.000Z'
comments: true
share: true
figure15: github-framework_karttur_15_new-other
figure16: github-framework_karttur_16_pydev-package
figure17: github-framework_karttur_17_pydev-package2
---

**These instructions are for using the git command line tool for creating a GitHub repository with a frame- (or super-) project (repository [repo]) linking together individual repos each containing one of the python packages that constitute Karttur's GeoImagine Framework. You can also use <span class='app'>Eclipse</span> for creating the submodules and the superproject as outliend in the [next post](../develop-submodules-w-eclipse/). If you are looking for how to clone the ready version of the complete framework, continue to the post [Git clone with Eclipse - NOT YET AVAILABLE](../../prep/prepare-clone-eclipse/)**.

## Introduction

Setting up a repository (repo) for code projects is offered by several companies. Karttur's GeoImagine Framework is hosted on [GitHub](https://github.com). This post is a manual on how to use the [git command line tool](https://karttur.github.io/git-vcs/) to create a superproject on GitHub that links together a set of submodules to a complete system.

If you are primarily interested in Git submodules I recommend a more general instruction, like [Using submodules in Git - Tutorial](https://www.vogella.com/tutorials/GitSubmodules/article.html), [Git Submodules basic explanation](https://gist.github.com/gitaarik/8735255), [Working with submodules](https://github.blog/2016-02-01-working-with-submodules/) or the youtube introduction [Git Tutorial: All About Submodules](https://www.youtube.com/watch?v=8Z4Cmhji_FQ).

## Prerequisites

To follow the instructions in this post you need a [GitHub](https://github.com) account.

To create a fully functional GeoImagine Framework you must also have installed the Spatial Data Integrated Development Environment (SPIDE) as outlined in my blog [Install and setup spatial data IDE](https://karttur.github.io/setup-ide/).

## Python packages repositories

The first step is to create all the repositories for the individual python packages. The approach I use for that is to give all the repos with individual packages a double name:

geoimagineXX-package

where the prefix is composed of two parts: the name _geoimagine_ and then a version number (_XX_) then a hyphen ("-") followed by the name of the actual python package. In October 2021, the Framework (version 03) is composed of the following packages/repos:

| spackage | repository |
| ktpandas | geoimagine03-ktpandas |
| userproj | geoimagine03-userproj |
| dem | geoimagine03-dem |
| setup_processes | geoimagine03-setup_processes-x |
| ktnumba | geoimagine03-ktnumba |
| grass | geoimagine03-grass |
| ktgdal | geoimagine03-ktgdal |
| zipper | geoimagine03-zipper |
| updatedb | geoimagine03-updatedb |
| basins | geoimagine03-basins |
| gis | geoimagine03-gis |
| landsat | geoimagine03-landsat |
| layout | geoimagine03-layout |
| projects | geoimagine03-projects |
| grace | geoimagine03-grace |
| smap | geoimagine03-smap |
| params | geoimagine03-params |
| timeseries | geoimagine03-timeseries |
| copernicus | geoimagine03-copernicus |
| setup_processes | geoimagine03-setup_processes |
| npproc | geoimagine03-npproc |
| ktgrass | geoimagine03-ktgrass |
| ancillary | geoimagine03-ancillary |
| sentinel | geoimagine03-sentinel |
| setup_db | geoimagine03-setup_db |
| extract | geoimagine03-extract |
| region | geoimagine03-region |
| modis | geoimagine03-modis |
| assets | geoimagine03-assets |
| support | geoimagine03-support |
| postgresdb | geoimagine03-postgresdb |
| export | geoimagine03-export |

### Create repos

To create the repos listed above, open your [GtHub](https://github.com) account in your web-browser. Then manually create all the repos as outlined in the post on [git cheat sheet](https://karttur.github.io/git-vcs/git/blog-git-cheat-sheet/). You must also clone all the repos manually using the <span class='terminalapp'>git clone</span> command.

Each created repo will only contain two visible files: <span class='file'>README.md</span> and <span class='file'>LICENCE</span>. The next step is to add the python package code belonging to each repo. This can either be done by manual copy/paste from your locally developed IDE, or using the python module <span class='module'>submodule_stage-commit-push_script</span>. This module (or script) is part of the Framework itself, available in the <span class='package'>support</span> package. The script copies a list of python packages from one directory tree to another. If the target file already exist it is overwritten if the source file in more recent. The script also creates a predefined <span class='file'>.gitignore</span>. As the script is not dependent on any other part of the Framework, you can just copy and paste it from under the <span class='button'>Hide/Show</span> button.

<button id= "togglesrcipt" onclick="hiddencode('script')">Hide/Show submodule_stage-commit-push_script.py</button>

<div id="script" style="display:none">

{% capture text-capture %}
{% raw %}
```
'''
Created on 12 Feb 2021

@author: thomasgumbricht
'''

# Standard library imports

import os, shutil

import  time

import datetime

import csv

def CopyProject():
    ''' Copy project updates to local GitHub clone
    '''

    for item in submoduleL:

        submoduleGitHubDirName = '%s-%s' %(prefix,item)

        dstRootFP = os.path.join(gitHubFP,submoduleGitHubDirName)

        print ("copying updates for package", item)

        srcFP = os.path.join(srcProjectFP,item)

        for subdir, dirs, files in os.walk(srcFP, topdown=True):

            files = [f for f in files if not f.endswith('pyc')]

            for file in files:

                print ('file',file)

                srcFPN = os.path.join(subdir,file)

                if not os.path.isfile(srcFPN):

                    continue

                if file in ignoreL:

                    continue

                if file[0] == '.':

                    continue

                srcFPN = os.path.join(srcFP, subdir, file)

                print (srcFPN)

                print ('subdir',subdir)

                dstSubdir = os.path.split( subdir.replace(srcFP,'') )[1]

                print ('dstSubdir',dstSubdir)

                if len(dstSubdir) > 0:

                    dstFP =  os.path.join(dstRootFP,  dstSubdir)

                    if not os.path.isdir(dstFP):

                        print ('dstRootFP',dstRootFP)

                        print ('dstFP',dstFP)

                        os.makedirs(dstFP)

                else:

                    dstFP = dstRootFP

                dstFPN =  os.path.join(dstFP, file)

                print ('dstFPN',dstFPN)

                try:

                    srcTime = datetime.datetime.fromtimestamp( int(os.path.getmtime(srcFPN)) )

                    dstTime = datetime.datetime.fromtimestamp( int(os.path.getmtime(dstFPN)) )

                    if int( os.stat(srcFPN).st_mtime) <= int(os.stat(dstFPN).st_mtime):

                        continue

                except OSError:

                    pass

                    print ('error - target probably non-existing')

                print ('    copying', item, file, dstFPN)

                print ('')

                shutil.copy(srcFPN, dstFPN) #copying from source to destination

        # Create .gitignore if it does not exist, or overwrite is set to true       
        gitignoreFPN = os.path.join(dstRootFP,'.gitignore')

        if not os.path.isfile( gitignoreFPN ) or overwriteGitIgone:

            with open(gitignoreFPN, 'w', encoding='UTF8', newline='') as f:

                writer = csv.writer(f)

                # write multiple rows
                writer.writerows(gitignore)


def WriteScript():
    ''' Write script that loops over all the repos and stage, commit and push
    '''

    shF = open(scriptFPN, 'w')

    for item in submoduleL:

        submoduleGitHubDirName = '%s-%s' %(prefix,item)

        FP = os.path.join(gitHubFP,submoduleGitHubDirName)

        cdCmd = 'cd %s\n' %(FP)

        shF.write(cdCmd)

        shF.write('echo "${PWD}"\n')

        stageCmd = 'git add .\n'

        shF.write(stageCmd)

        commitCmd = 'git commit -m "%s"\n' %(commitMsg)

        shF.write(commitCmd)

        pushCmd = 'git push origin %s\n' %(branch)

        shF.write(pushCmd)

        shF.write('\n')

    shF.close()

    print ('Script file:', scriptFPN)

if __name__ == "__main__":

    copyProject = True

    overwriteGitIgone = True

    branch = 'main'

    commitMsg = 'updates oct 2021'

    ignoreL = ['__pycache__','.DS_Store','README.md']

    home = os.path.expanduser('~')

    scriptFPN = os.path.join(home, 'submodule_stage_commit_push.sh')

    srcProjectFP = '/Users/thomasgumbricht/eclipse-workspace/2020-03_geoimagine/karttur_v202003/geoimagine'

    gitHubFP = '/Users/thomasgumbricht/GitHub/'

    gitHubAccount = 'karttur'

    prefix = 'geoimagine03'

    gitignore = [['.DS_Store'],['__pycache__/']]

    submoduleL = ['ancillary','assets','basins','copernicus',
                  'dem','export','extract',
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

{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html  toggle-text=text-capture  %}
</div>

### Stage, commit and push

When you have filled the repos with the python packages, you need to stage (add), commit and push the locally edited repos to you online origin. If you used the script supplied above, it will generate a script file that will execute all the <span class='terminalapp'>git</span> commands.

### Create the superproject repo

To create the superproject repo that will contain the python frame package, return to your online [GtHub](https://github.com) account and create another repo with only a <span class='file'>README.md</span> and a <span class='file'>LICENCE</span>. There is no need for a strict naming, in this example I named it _geoimagine03frame_, without any hyphen to separate it from the submodules. Clone the superproject repo to your local machine with the command <span class='terminalapp'>git clone</span>.

#### Link the submodules to the superproject

The <span class='terminalapp'>git</span> command for linking other repos as submodules is [<span class='terminalapp'>git submodule add</span>](https://git-scm.com/book/en/v2/Git-Tools-Submodules). The command expects a url link to a repo; by default the name of the submodule will be identical to the original repo, but by adding a second variable the name can be customised. For the GeoImagine Framework the name should be set to the actual name of the python package. Thus the command for using the repo _geoimagine03-ancillary_ as a submodule in the superproject becomes:

<span class='terminal'>$ git submodule add https://github.com/karttur/geoimagine03-ancillary ancillary</span>

Instead of writing the commands for adding all the individual package repos, the script _submodule_stage-commit-push_script.py_ (above) generates the shell script code for adding all. To execute the script, open a <span class='app'>Terminal</span> window and change directory <span class='terminal'>cd</span> to the superproject repo, for example:

<span class='terminal'>$ cd /Users/thomasgumbricht/GitHub/geoimagine03frame</span>

and execute the <span class='terminalapp'> git submodule add</span> scripts from within the superproject.

After adding all package repos as submodules in October 2021, the complete GeoImagine Framework consists of 826 individual files. The complete directory tree in under the <span class='button'>Hide/Show</span> button.

<button id= "togglesrcipt" onclick="hiddencode('script')">Hide/Show GeoImagine Framework tree</button>

<div id="script" style="display:none">

{% capture text-capture %}
{% raw %}
```
├── LICENSE
├── README.md
├── addsubmodules.sh
├── ancillary
│   ├── LICENSE
│   ├── README.md
│   ├── __init__.py
│   ├── ancillary.py
│   ├── ancillary_import.py
│   ├── bboxtiledrawdata.py
│   ├── download.py
│   ├── mosaic.py
│   ├── searchjson.py
│   ├── unziprawdata.py
│   └── version.py
├── assets
│   ├── LICENSE
│   ├── README.md
│   ├── __init__.py
│   ├── ease2gridproj.py
│   ├── ease2helper.py
│   ├── easegrid_templates.py
│   ├── gdal_reproject.py
│   ├── hdf_2_geotiff.py
│   ├── hdf_2_geotiffok.py
│   ├── httpsdataaccess.py
│   ├── pyproj_reproject.py
│   └── version.py
├── basins
│   ├── LICENSE
│   ├── README.md
│   ├── __init__.py
│   ├── basins.py
│   └── version.py
├── copernicus
│   ├── LICENSE
│   ├── README.md
│   ├── __init__.py
│   ├── copernicus.py
│   ├── era_climadata_cdsapi.py
│   └── version.py
├── dem
│   ├── LICENSE
│   ├── README.md
│   ├── __init__.py
│   ├── dem.py
│   └── version.py
├── export
│   ├── LICENSE
│   ├── README.md
│   ├── __init__.py
│   ├── export.py
│   └── version.py
├── extract
│   ├── LICENSE
│   ├── README.md
│   ├── __init__.py
│   ├── extract.py
│   └── version.py
├── gis
│   ├── LICENSE
│   ├── README.md
│   ├── __init__.py
│   ├── kt_gis.py
│   └── version.py
├── grace
│   ├── LICENSE
│   ├── README.md
│   ├── __init__.py
│   ├── grace.py
│   └── version.py
├── grass
│   ├── LICENSE
│   ├── README.md
│   ├── __init__.py
│   ├── exceptions
│   │   └── __init__.py
│   ├── gis
│   │   ├── __init__.py
│   │   └── region.py
│   ├── grid
│   │   ├── __init__.py
│   │   ├── grid.py
│   │   ├── patch.py
│   │   └── split.py
│   ├── gunittest
│   │   ├── __init__.py
│   │   ├── case.py
│   │   ├── checkers.py
│   │   ├── gmodules.py
│   │   ├── gutils.py
│   │   ├── invoker.py
│   │   ├── loader.py
│   │   ├── main.py
│   │   ├── reporters.py
│   │   ├── runner.py
│   │   └── utils.py
│   ├── imaging
│   │   ├── __init__.py
│   │   ├── images2avi.py
│   │   ├── images2gif.py
│   │   ├── images2ims.py
│   │   ├── images2swf.py
│   │   └── operations.py
│   ├── interface
│   │   ├── __init__.py
│   │   ├── docstring.py
│   │   ├── env.py
│   │   ├── flag.py
│   │   ├── module.py
│   │   ├── parameter.py
│   │   ├── read.py
│   │   └── typedict.py
│   ├── lib
│   │   ├── __init__.py
│   │   ├── arraystats.py
│   │   ├── cluster.py
│   │   ├── ctypes_loader.py
│   │   ├── ctypes_preamble.py
│   │   ├── date.py
│   │   ├── dbmi.py
│   │   ├── display.py
│   │   ├── gis.py
│   │   ├── gmath.py
│   │   ├── imagery.py
│   │   ├── nviz.py
│   │   ├── ogsf.py
│   │   ├── proj.py
│   │   ├── raster.py
│   │   ├── raster3d.py
│   │   ├── rowio.py
│   │   ├── rtree.py
│   │   ├── segment.py
│   │   ├── stats.py
│   │   ├── temporal.py
│   │   ├── vector.py
│   │   └── vedit.py
│   ├── messages
│   │   └── __init__.py
│   ├── modules
│   │   ├── __init__.py
│   │   └── shortcuts.py
│   ├── pydispatch
│   │   ├── __init__.py
│   │   ├── dispatcher.py
│   │   ├── errors.py
│   │   ├── robust.py
│   │   ├── robustapply.py
│   │   ├── saferef.py
│   │   └── signal.py
│   ├── pygrass
│   │   ├── __init__.py
│   │   ├── errors.py
│   │   ├── orderdict.py
│   │   └── utils.py
│   ├── raster
│   │   ├── __init__.py
│   │   ├── abstract.py
│   │   ├── buffer.py
│   │   ├── category.py
│   │   ├── history.py
│   │   ├── raster_type.py
│   │   ├── rowio.py
│   │   └── segment.py
│   ├── rpc
│   │   ├── __init__.py
│   │   └── base.py
│   ├── script
│   │   ├── __init__.py
│   │   ├── array.py
│   │   ├── core.py
│   │   ├── db.py
│   │   ├── raster.py
│   │   ├── raster3d.py
│   │   ├── setup.py
│   │   ├── task.py
│   │   ├── utils.py
│   │   └── vector.py
│   ├── shell
│   │   ├── __init__.py
│   │   ├── conversion.py
│   │   └── show.py
│   ├── temporal
│   │   ├── __init__.py
│   │   ├── abstract_dataset.py
│   │   ├── abstract_map_dataset.py
│   │   ├── abstract_space_time_dataset.py
│   │   ├── aggregation.py
│   │   ├── base.py
│   │   ├── c_libraries_interface.py
│   │   ├── core.py
│   │   ├── datetime_math.py
│   │   ├── extract.py
│   │   ├── factory.py
│   │   ├── gui_support.py
│   │   ├── list_stds.py
│   │   ├── mapcalc.py
│   │   ├── metadata.py
│   │   ├── open_stds.py
│   │   ├── register.py
│   │   ├── sampling.py
│   │   ├── space_time_datasets.py
│   │   ├── spatial_extent.py
│   │   ├── spatial_topology_dataset_connector.py
│   │   ├── spatio_temporal_relationships.py
│   │   ├── stds_export.py
│   │   ├── stds_import.py
│   │   ├── temporal_algebra.py
│   │   ├── temporal_extent.py
│   │   ├── temporal_granularity.py
│   │   ├── temporal_operator.py
│   │   ├── temporal_raster3d_algebra.py
│   │   ├── temporal_raster_algebra.py
│   │   ├── temporal_raster_base_algebra.py
│   │   ├── temporal_topology_dataset_connector.py
│   │   ├── temporal_vector_algebra.py
│   │   ├── unit_tests.py
│   │   └── univar_statistics.py
│   ├── tests
│   │   ├── __init__.py
│   │   ├── benchmark.py
│   │   └── set_mapset.py
│   └── vector
│       ├── __init__.py
│       ├── abstract.py
│       ├── basic.py
│       ├── find.py
│       ├── geometry.py
│       ├── sql.py
│       ├── table.py
│       └── vector_type.py
├── ktgdal
│   ├── LICENSE
│   ├── README.md
│   ├── __init__.py
│   ├── ktgdal.py
│   ├── ogr2ogr.py
│   └── version.py
├── ktgrass
│   ├── LICENSE
│   ├── README.md
│   ├── __init__.py
│   ├── grass.py
│   ├── grass01.py
│   ├── grass02.py
│   ├── grassdem\ (original).py
│   ├── grassdem.py
│   └── version.py
├── ktnumba
│   ├── LICENSE
│   ├── README.md
│   ├── __init__.py
│   ├── tsnumba.py
│   └── version.py
├── ktpandas
│   ├── LICENSE
│   ├── README.md
│   ├── __init__.py
│   ├── kt_pandas.py
│   └── version.py
├── landsat
│   ├── LICENSE
│   ├── README.md
│   ├── __init__.py
│   ├── landsat.py
│   └── version.py
├── layout
│   ├── LICENSE
│   ├── README.md
│   ├── __init__.py
│   ├── layout.py
│   ├── mj_legends.py
│   └── version.py
├── modis
│   ├── LICENSE
│   ├── README.md
│   ├── __init__.py
│   ├── modis.py
│   ├── modispolar.py
│   └── version.py
├── npproc
│   ├── LICENSE
│   ├── README.md
│   ├── __init__.py
│   ├── dem.py
│   ├── npproc.py
│   └── version.py
├── params
│   ├── LICENSE
│   ├── README.md
│   ├── __init__.py
│   ├── layers.py
│   ├── paramsjson.py
│   ├── timestep.py
│   └── version.py
├── postgresdb
│   ├── LICENSE
│   ├── README.md
│   ├── __init__.py
│   ├── ancillary.py
│   ├── compositions.py
│   ├── easegrid.py
│   ├── export.py
│   ├── fileformats.py
│   ├── gdalcomp.py
│   ├── hdfstuff.py
│   ├── landsat.py
│   ├── layout.py
│   ├── modis.py
│   ├── modispolar.py
│   ├── processes.py
│   ├── region.py
│   ├── selectuser.py
│   ├── sentinel.py
│   ├── session.py
│   ├── smap.py
│   ├── soilmoisture.py
│   ├── sqldump.py
│   ├── userproj.py
│   └── version.py
├── projects
│   ├── AW3D30
│   │   └── aw3d30_20210321.txt
│   ├── CopDEM_mosaic_arctic-hydro-regions.txt
│   ├── CopernicusDEM
│   │   ├── CopDEM_mosaic_arctic-hydro-regions.txt
│   │   └── CopernicusDEM_20210323.txt
│   ├── LICENSE
│   ├── README.md
│   ├── SwedenWetlands
│   │   └── Sweden_wetlands_20210318.txt
│   ├── TDM90
│   │   └── W-180_E180_S45_N90.txt
│   ├── TanDEMX
│   │   └── TanDEMX_20210318.txt
│   ├── __init__.py
│   ├── adduserprojs
│   │   └── users_20210303.txt
│   ├── arcticDEM
│   │   ├── ArcticDEM_20210309.txt
│   │   └── ArcticDEM_process.txt
│   ├── arcticwetland
│   │   ├── ArcticWetlands.txt
│   │   └── arctic_wetlands_20210304.txt
│   ├── grace
│   │   ├── grace_20190216.txt
│   │   └── grace_20210212.txt
│   ├── importAncillary
│   │   └── Import_ancillary_20210317.txt
│   ├── importGMTED
│   │   └── Import_gmted_20210317.txt
│   ├── json
│   │   ├── 0001_CreatesScaling_DEM_v090.json
│   │   ├── 0002_AddRasterPalette_DEM_v090.json
│   │   ├── 0003_createlegends_DEM_v090.json
│   │   ├── 0005_exportlegend_DEM_v090.json
│   │   ├── 0100-SearchCopernicusProducts_CopDEM-90m.json
│   │   ├── 0100_SearchCopernicusProducts_CopDEM-90m.json
│   │   ├── 0100_search-download-tandemx90.json
│   │   ├── 0110-tandemX_unzip-tandemx90.json
│   │   ├── 0110_DownloadCopernicus_CopDEM-90m.json
│   │   ├── 0115-ancillary-download-GMTED2010.json
│   │   ├── 0115-ancillary-download-panarcticDEM.json
│   │   ├── 0115-download-Metria-VMI.json
│   │   ├── 0115-download-Metria-markdata.json
│   │   ├── 0115-download-SMHI-SVAR.json
│   │   ├── 0118-AW3D30-mosaic-raw.json
│   │   ├── 0118-ancillary-mosaic-panarcticDEM.json
│   │   ├── 0118-tandemx-mosaic-rawjson.json
│   │   ├── 0120_UnZipRawData_CopDEM-90m.json.json
│   │   ├── 0122_BBoxTiledRawData_CopDEM-90m.json
│   │   ├── 0125_MosaicAncillary_CopDEM-30m.json
│   │   ├── 0125_MosaicAncillary_CopDEM-90m.json
│   │   ├── 0160-ancillary-import-TanDEMX90.json
│   │   ├── 0160-ancillary-import-arcticDEM.json
│   │   ├── 0160-ancillary-import-panarcticDEM.json
│   │   ├── 0160-import-AW3D30.json
│   │   ├── 0160-organize-SMHI-SVAR.json
│   │   ├── 0160_OrganizeAncillary_CopDEM-30m.json
│   │   ├── 0160_OrganizeAncillary_CopDEM-90m.json
│   │   ├── 0180_TileAncillaryRegion_CopDem-30m.json
│   │   ├── 0180_TileAncillaryRegion_CopDem-90m.json
│   │   ├── 0190-reproject-SMHI-SVAR.json
│   │   ├── 0190_MosaicAdjacentTiles_CopDEM-30m.json
│   │   ├── 0190_MosaicAdjacentTiles_CopDEM-90m.json
│   │   ├── 0191_MosaicAdjacentTiles_CopDEM-90m.json
│   │   ├── 0192_MosaicAdjacentTiles_CopDEM-90m.json
│   │   ├── 0200_tile_AW3D30_nortlandease2n.json
│   │   ├── 0200_tile_ArcticDEM2ease2n.json
│   │   ├── 0200_tile_GMTED20102ease2n.json
│   │   ├── 0200_tile_PanArcticDEM2ease2n.json
│   │   ├── 0200_tile_tandemX902ease2n.json
│   │   ├── 0210_GrassOnetoManyTiles-correct-shoreline-shoreline-only_CopDEM-90m.json
│   │   ├── 0210_GrassOnetoManyTiles-correct-shoreline_CopDEM-90m.json
│   │   ├── 0210_mosaic_ArcticDEMease2n.json
│   │   ├── 0210_mosaic_canadahydro-PanArcticDEMease2n.json
│   │   ├── 0210_mosaic_greenlandhydro-PanArcticDEMease2n.json
│   │   ├── 0210_mosaic_nordichydro-GMTED2010ease2n.json
│   │   ├── 0210_mosaic_nordichydro-PanArcticDEMease2n.json
│   │   ├── 0210_mosaic_nordichydro-tandemx90.json
│   │   ├── 0225_MosaicTiles-copDEM.json
│   │   ├── 0230_GrassDemFillDirTiles_CopDEM_90m.json
│   │   ├── 0240_GrassDemHydroDemTiles_CopDEM-90m.json
│   │   ├── 0301_GdalDemTiles_CopDEM-90m.json
│   │   ├── 0303_NumpyDemTiles_CopDEM-90m.json
│   │   ├── 0303b_NumpyDemTiles_CopDEM-90m.json
│   │   ├── 0305_GrassOnetoManyTiles-DEM-derivates-3+9cell_CopDEM-90m.json
│   │   ├── 0310NEW_CopDEM_grassdem_ease2n.json
│   │   ├── 0310_CopDEM_grassdem-1-1_ease2n.json
│   │   ├── 0310_CopDEM_grassdem_ease2n-OLD.json
│   │   ├── 0310_CopDEM_grassdem_ease2n.json
│   │   ├── 0310_CopernicusDEM_gdaldem_ease2n.json
│   │   ├── 0311_GrassOnetoManyTiles_hillslope-derivates_copDEM-90m.json
│   │   ├── 0312_COPDEM_numpydemtpi_ease2n.json
│   │   ├── 0312b_COPDEM_numpydemtpi_ease2n.json
│   │   ├── 0313_CopDEM_mosaic-alaskahydro_ease2n.json
│   │   ├── 0313_CopDEM_mosaic-arcticoceanhydro_ease2n.json
│   │   ├── 0313_CopDEM_mosaic-cahydro_ease2n.json
│   │   ├── 0313_CopDEM_mosaic-dvinahydro_ease2n.json
│   │   ├── 0313_CopDEM_mosaic-greenlandhydro_ease2n.json
│   │   ├── 0313_CopDEM_mosaic-kolymahydro_ease2n.json
│   │   ├── 0313_CopDEM_mosaic-lenahydro_ease2n.json
│   │   ├── 0313_CopDEM_mosaic-nordichydro-terrain_ease2n.json
│   │   ├── 0313_CopDEM_mosaic-nordichydro_ease2n.json
│   │   ├── 0313_CopDEM_mosaic-obhydro_ease2n.json
│   │   ├── 0313_CopDEM_mosaic-yieniseyhydro_ease2n.json
│   │   ├── 0313_CopDEM_mosaic1km_ease2n.json
│   │   ├── 0313_CopDEM_translate1km_ease2n.json
│   │   ├── 0315_CopDEM_Basin-outlets-tiles-r-out-gdal_ease2n.json
│   │   ├── 0321_GrassOnetoManyTilesCopDEM-basin-extract-stage2_copDEM.json
│   │   ├── 0321b_GrassOnetoManyTilesCopDEM-basin-extract-stage2_copDEM.json
│   │   ├── 0325_BasinOutletTiles_CopDEM-90m.json
│   │   ├── 0905A_ExportTilesToByte_CopDEM-elevation_v090.json
│   │   ├── 0905_DEM-TRI_ExportTilesToByte_v090.json
│   │   ├── 0905_DEM-landforms_ExportTilesToByte_v090.json
│   │   ├── 0905_DEM-slope_ExportTilesToByte_v090.json
│   │   ├── 0905_DEM_ExportTilesToByte_v090.json
│   │   ├── 0905_terrain_ExportTilesToByte_v090.json
│   │   ├── 0906A_ExportShadedTilesToByte_CopDEM-elevation_v090.json
│   │   ├── 0906_DEM-curvature_ExportShadeTilesToByte_v090.json
│   │   ├── 0906_DEM-elevation_ExportShadeTilesToByte_v090.json
│   │   ├── 0906_DEM_ExportShadeTilesToByte_v090.json
│   │   ├── 0950_duplicate_CopDEM_v090.json
│   │   ├── 0950_duplicate_CopDEM_v090_temp.json
│   │   ├── 0960_ZipArchive_DEM_v090.json
│   │   ├── 0960b_ZipArchive_DEM_v090.json
│   │   ├── GRACE-0001_createscaling.json
│   │   ├── GRACE-0002_createpalettes.json
│   │   ├── GRACE-0003_createlegends.json
│   │   ├── GRACE-0005_exportlegend.json
│   │   ├── GRACE-0100_search-podaac_v090.json
│   │   ├── GRACE-0115_curl-podaac_v090.json
│   │   ├── GRACE-0121_organize.json
│   │   ├── GRACE-0124_mendts.json
│   │   ├── GRACE-0129_monthdaytomonth.json
│   │   ├── GRACE-0145_average.json
│   │   ├── GRACE-0190_updatedb.json
│   │   ├── GRACE-0231_extract-season.json
│   │   ├── GRACE-0290_resample-2-annual.json
│   │   ├── GRACE-0310_trend_A_2003-2016.json
│   │   ├── GRACE-0320_changes_A_2003-2016.json
│   │   ├── GRACE-0910_ExporttoByte_timespanA_2003-2016.json
│   │   ├── GRACE-0925_graticule_ExporttoSVG.json
│   │   ├── MODIS-0100_search-datapool_MCD43A4.json
│   │   ├── MODIS-0100_search-datapool_MOD09A1.json
│   │   ├── MODIS-0110_search-todb_MCD43A4.json
│   │   ├── MODIS-0110_search-todb_MOD09A1.json
│   │   ├── MODIS-0120_download_region.json
│   │   ├── MODIS-0120_download_singletile.json
│   │   ├── MODIS-NSIDC-0100_search_MOD29E1D_20000224-20210223_v090.json
│   │   ├── MODIS-NSIDC-0100_search_MOD29P1D_20000224-20210224_v090.json
│   │   ├── MODIS-NSIDC-0110_search-todb_MOD29E1D_20000224-20210223_v090.json
│   │   ├── MODIS-NSIDC-0120_download_MOD29E1D_20000224-20210223_v090.json
│   │   ├── MODIS-NSIDC-0150_extract_MOD29E1D_20000224-20210223_v090.json
│   │   ├── SMAP-0001_CreatesScaling_v090.json
│   │   ├── SMAP-0002_CreatePalettes_v090.json
│   │   ├── SMAP-0003_CreateLegends_v090.json
│   │   ├── SMAP-0004_CreateMovieClock_v090.json
│   │   ├── SMAP-0040_udatedb_D_20150331-present_v090.json
│   │   ├── SMAP-0100_search-daac-SPL3FTA_20150413-20150707_v090.json
│   │   ├── SMAP-0100_search-daac-SPL3FTP-E_2015-present_v090.json
│   │   ├── SMAP-0100_search-daac-SPL3FTP_2015-present_v090.json
│   │   ├── SMAP-0100_search-daac-SPL3SMP-E_2015-present_v090.json
│   │   ├── SMAP-0100_search-daac-SPL3SMP_2015-present_v090.json
│   │   ├── SMAP-0100_search-daac_SPL3SMAP_20150413-20150707_v090.json
│   │   ├── SMAP-0100_search-daac_SPL3SMA_20150413-20150707_v090.json
│   │   ├── SMAP-0110_search-todb_SPL3FTA_20150413-20150707_v090.json
│   │   ├── SMAP-0110_search-todb_SPL3FTP-E_2015-present_v090.json
│   │   ├── SMAP-0110_search-todb_SPL3FTP_2015-present_v090.json
│   │   ├── SMAP-0110_search-todb_SPL3SMAP_20150413-20150707_v090.json
│   │   ├── SMAP-0110_search-todb_SPL3SMA_20150413-20150707_v090.json
│   │   ├── SMAP-0110_search-todb_SPL3SMP-E_2015-present_v090.json
│   │   ├── SMAP-0110_search-todb_SPL3SMP_2015-present_v090.json
│   │   ├── SMAP-0115_check_v090.json
│   │   ├── SMAP-0120_download_SPL3FTA_20150413-20150707_v090.json
│   │   ├── SMAP-0120_download_SPL3FTP-E_2015-present_v090.json
│   │   ├── SMAP-0120_download_SPL3FTP_2015-present_v090.json
│   │   ├── SMAP-0120_download_SPL3SMAP_20150413-20150707_v090.json
│   │   ├── SMAP-0120_download_SPL3SMA_20150413-20150707_v090.json
│   │   ├── SMAP-0120_download_SPL3SMP-E_2015-present_v090.json
│   │   ├── SMAP-0120_download_SPL3SMP_2015-present_v090.json
│   │   ├── SMAP-0150_extract_SPL3FTP-E_2015-present_v090.json
│   │   ├── SMAP-0150_extract_SPL3FTP_2015-present_v090.json
│   │   ├── SMAP-0150_extract_SPL3SMAP_20150413-20150707_v090.json
│   │   ├── SMAP-0150_extract_SPL3SMA_20150413-20150707_v090.json
│   │   ├── SMAP-0150_extract_SPL3SMP-E_2015-present_v090.json
│   │   ├── SMAP-0150_extract_SPL3SMP_2015-present_v090.json
│   │   ├── SMAP-0240_overlaydaily_20150331-20181231.json
│   │   ├── SMAP-0240_overlaydaily_20190101-present.json
│   │   ├── SMAP-0310_tsresample-16D_2015.json
│   │   ├── SMAP-0310_tsresample-16D_2016.json
│   │   ├── SMAP-0320_extract-season_16D.json
│   │   ├── SMAP-0330_interpolseasn_16D_2015-2019.json
│   │   ├── SMAP-0900_ExporttoByte_16D.json
│   │   ├── SMAP-0905_ExporttoByte_16D-seasons.json
│   │   ├── SMAP-0925_graticule_ExporttoSVG.json
│   │   ├── SMAP-0950_movieframes_16D-seasons.json
│   │   ├── SMAP-0950_movieframes_16D.json
│   │   ├── USGS-0100_search-ASTERDEM.json
│   │   ├── USGS-0120_download-ASTERDEM.json
│   │   ├── add_user_projects-national.json
│   │   ├── add_user_projects-regions_arctic-hydro.json
│   │   ├── add_user_projects-regions_arctic.json
│   │   ├── ancillary-import-GMTED2010.json
│   │   ├── ancillary-import-NaturalEarth.json
│   │   ├── climateIndex-0100_import-NOAA.json
│   │   ├── climateIndex-0100_import-NOAA.xml
│   │   ├── climateIndex-0100_import-co2records.json
│   │   ├── climateIndex-0100_import-co2records.xml
│   │   ├── climateIndexes-0800_plot.xml
│   │   ├── em.json
│   │   ├── regions-link-ease2ntiles_v090.json
│   │   ├── regions-modtiles_v090.json
│   │   └── smap-0040_udatedb_16D_20150423-present_v090.json
│   ├── modis
│   │   └── modis_20210302.txt
│   ├── modis-nsidc
│   │   └── modis-nsidc_20210218.txt
│   ├── process_project.py
│   ├── projAW3D30.py
│   ├── projAncillary.py
│   ├── projArcticDEM.py
│   ├── projArcticWetlands.py
│   ├── projClimateIndexes.py
│   ├── projCopDEMbasins.py
│   ├── projCopernicus.py
│   ├── projGRACE.py
│   ├── projMODIS.py
│   ├── projMODISPolar.py
│   ├── projRegions.py
│   ├── projSMAP.py
│   ├── projSwedenWetlands.py
│   ├── projTRMM.py
│   ├── projTanDEMX.py
│   ├── projUSGS.py
│   ├── projUsers.py
│   ├── regions
│   │   └── regions_link_20210304.txt
│   ├── smap
│   │   ├── smap-waterbodies-adjust_20190416.txt
│   │   ├── smap_20190416.txt
│   │   └── smap_20210201.txt
│   ├── usgsdata
│   │   └── usgs-data_20210321.txt
│   ├── version.py
│   └── xml
│       ├── ArcticDEM_Aspect.json
│       ├── ArcticDEM_Aspect.xml
│       ├── ArcticDEM_HillShade.json
│       ├── ArcticDEM_HillShade.xml
│       ├── ArcticDEM_Slope.json
│       ├── ArcticDEM_Slope.xml
│       ├── ArcticDEM_TPI.json
│       ├── ArcticDEM_TPI.xml
│       ├── ArcticDEM_TRI.json
│       ├── ArcticDEM_TRI.xml
│       ├── ArcticDEM_landformTPI.json
│       ├── ArcticDEM_landformTPI.xml
│       ├── ArcticDEM_roughness.json
│       ├── ArcticDEM_roughness.xml
│       ├── ArcticWetlands_MODIS-0320_TWI-extract-season_16D.xml
│       ├── ArcticWetlands_MODIS-0461_orthotrans.xml
│       ├── ArcticWetlands_MODIS-0471_fgbg-TWI.xml
│       ├── ArcticWetlands_MODIS-0472_TWI-percent.xml
│       ├── ExporttoByte_landform_v090.json
│       ├── ExporttoByte_landform_v80.xml
│       ├── MODIS-0100_downloaddatapool.xml
│       ├── MODIS-0100_search-datapool.xml
│       ├── MODIS-0110_search-todb.xml
│       ├── MODIS-0120_download_singletile.xml
│       ├── MODIS-0129_checksingletile.xml
│       ├── MODIS-0130_explodetiles.xml
│       ├── MODIS-0130_explodetiles_h18v02.xml
│       ├── MODIS-0130_explodsingletile.xml
│       ├── MODIS-0320_TWI-extract-season_16D.xml
│       ├── MODIS-0330_interpolseasn-16D.xml
│       ├── MODIS-0461_orthotrans_singletile.xml
│       ├── MODIS-0471_fgbg-TWI_singletile.xml
│       ├── MODIS-0472_TWI-percent_singletile.xml
│       ├── MODIS-0900_ExporttoByte_16D.xml
│       ├── MODIS-0900_ExporttoByte_A.xml
│       ├── SMAP-0005_add-movieclock.xml
│       ├── SMAP-0010_insert-template-product.xml
│       ├── SMAP-0150_extract_20181010-present.xml
│       ├── SMAP-0190_udatedb_16D_20150423-present.xml
│       ├── SMAP-0240_overlayWaterBody_20150331-20181231_16D.xml
│       ├── SMAP-0310_tsresample-16D_2015.xml
│       ├── SMAP-0310_tsresample-16D_2016.xml
│       ├── SMAP-0310_tsresample-16D_2017.json
│       ├── SMAP-0310_tsresample-16D_2017.xml
│       ├── SMAP-0310_tsresample-16D_2018.json
│       ├── SMAP-0310_tsresample-16D_2018.xml
│       ├── SMAP-0310_tsresample-16D_2019.xml
│       ├── SMAP-0310_tsresample-M_2015.xml
│       ├── SMAP-0310_tsresample-M_201512.xml
│       ├── SMAP-0310_tsresample-M_2016.xml
│       ├── SMAP-0310_tsresample-M_2017.xml
│       ├── SMAP-0310_tsresample-M_2018.xml
│       ├── SMAP-0310_tsresample-M_2019.xml
│       ├── SMAP-0320_extract-season_M.xml
│       ├── SMAP-0320_extract-season_soil-moisture-fill-wboadj_16D.xml
│       ├── SMAP-0320_extract-season_soil-moisture-wboadj_16D.xml
│       ├── SMAP-0330_interpolseasn-fill-M_2015-2019.xml
│       ├── SMAP-0330_interpolseasn-fill_soilmoisture-wboadj_16D_2015-2019.xml
│       ├── SMAP-0330_interpolseasn-season_soil-moisture-wboadj_16D_2015-2019.xml
│       ├── SMAP-0960_movieclock_16D-seasons.xml
│       ├── SMAP-0960_movieclock_16D.xml
│       ├── Text-4.txt
│       ├── add_user_project-region_africa-sub-sahara.json
│       ├── add_user_project-region_africa-sub-sahara.xml
│       ├── add_user_projects-regions_arctic.json
│       ├── add_user_projects-regions_arctic.xml
│       ├── add_user_projects-regions_lesotho.xml
│       ├── ancillary-import-NaturalEarth.xml
│       ├── ancillary-import-arcticDEM.xml
│       ├── ancillary-import-gghydro.xml
│       ├── createscaling_Landform_v090.json
│       ├── createscaling_Landform_v80.xml
│       ├── extract_season_GRACE_v80.xml
│       ├── landformpalettes_v090.json
│       ├── landformpalettes_v80.xml
│       ├── manage_project_v80.xml
│       ├── regions-modtiles_v090.json
│       ├── regions-modtiles_v80\ 2.xml
│       ├── regions-modtiles_v80.xml
│       ├── smap-search_daac.xml
│       ├── smap_ExporttoByte_Daily_v80.xml
│       └── tile_ArcticDEM2modis.xml
├── region
│   ├── LICENSE
│   ├── README.md
│   ├── __init__.py
│   ├── region.py
│   └── version.py
├── sentinel
│   ├── LICENSE
│   ├── README.md
│   ├── __init__.py
│   ├── gml_transform.py
│   ├── sentinel.py
│   └── version.py
├── setup_db
│   ├── LICENSE
│   ├── README.md
│   ├── __init__.py
│   ├── doc
│   │   ├── db_karttur_dbusers_20210102.txt
│   │   └── db_karttur_setup_20201231.txt
│   ├── jsonsql
│   │   ├── EASE2N_template_v090_sql.json
│   │   ├── EASE2N_v090_sql.json
│   │   ├── EASE2S_template_v090_sql.json
│   │   ├── EASE2S_v090_sql.json
│   │   ├── MODISpolar_template_v090_sql.json
│   │   ├── MODISpolar_v090_sql.json
│   │   ├── SMAP_template-NEW_v090_sql.json
│   │   ├── SMAP_template-OLD_v090_sql.json
│   │   ├── SMAP_v090_sql.json
│   │   ├── all_system_regions_v090_sql.json
│   │   ├── ancillary_v090_sql.json
│   │   ├── climateindexes_v090_sql.json
│   │   ├── compositions_ancillary_v090_sql.json
│   │   ├── compositions_ease2_v090_sql.json
│   │   ├── compositions_export_v090_sql.json
│   │   ├── compositions_landsat_v090_sql.json
│   │   ├── compositions_modis_v090_sql.json
│   │   ├── compositions_modispolar_v090_sql.json
│   │   ├── compositions_regions_v090_sql.json
│   │   ├── compositions_sentinel_v090_sql.json
│   │   ├── compositions_smap_v090_sql.json
│   │   ├── compositions_specimen_v090_sql.json
│   │   ├── compositions_system_v090_sql.json
│   │   ├── ease_tile_regions_v090_sql.json
│   │   ├── ease_tilecoords_v090_sql.json
│   │   ├── endmember_v090_sql.json
│   │   ├── general_GDAL_v090_sql.json
│   │   ├── general_grant-karttur_v80_sql.json
│   │   ├── general_grant_v090_sql.json
│   │   ├── general_processes_v090_sql.json
│   │   ├── general_processeschain_v090_sql.json
│   │   ├── general_records_v090_sql.json
│   │   ├── general_schema_v090_sql.json
│   │   ├── landsat_scenecoords_v090_sql.json
│   │   ├── landsat_scenes_bands_v090_sql.json
│   │   ├── landsat_templates_v090_sql.json
│   │   ├── landsat_tilecoords_v090_sql.json
│   │   ├── landsat_usgs_meta_v090_sql.json
│   │   ├── layout_v090_sql.json
│   │   ├── modis_daacdata_v090_sql.json
│   │   ├── modis_template_v090_sql.json
│   │   ├── modis_tile_regions_v090_sql.json
│   │   ├── modis_tilecoords_v090_sql.json
│   │   ├── modis_tiles_v090_sql.json
│   │   ├── process_default-comp-naming_v090_sql.json
│   │   ├── regions_v090_sql.json
│   │   ├── sentinel_scenes_bands_v090_sql.json
│   │   ├── sentinel_template_v090_sql.json
│   │   ├── sentinel_tilecoords_v090_sql.json
│   │   ├── soilmoisture_v090_sql.json
│   │   ├── specimen_satdata_v090_sql.json
│   │   ├── specimen_satdata_v80_sql.json
│   │   ├── specimen_v090_sql.json
│   │   ├── system_v090_sql.json
│   │   ├── topo_v090_sql.json
│   │   ├── user_projects_v090_sql.json
│   │   ├── user_super_v090_sql.json
│   │   └── users_v090_sql.json
│   ├── paramjson_mini.py
│   ├── setup_db_class.py
│   ├── setup_db_main.py
│   └── version.py
├── setup_processes
│   ├── LICENSE
│   ├── README.md
│   ├── __init__.py
│   ├── dbdoc
│   │   └── process_karttur_setup_20210104.txt
│   ├── json
│   │   ├── BasinProcess_v090.json
│   │   ├── CopernicusProcess_root+search+download_v090.json
│   │   ├── DEMGDALproc_v090.json
│   │   ├── DEMgrassProc_v090.json
│   │   ├── DEMnumpyProc_v090.json
│   │   ├── ExportCopy_v090.json
│   │   ├── ExportToByte_v090.json
│   │   ├── ExportZip_v090.json
│   │   ├── Extract_v090.json
│   │   ├── add_Africa-Sub_Sahara_default-region_v090.json
│   │   ├── add_arbitrary_default_regions_v090.json
│   │   ├── add_arctic_default_regions_v090.json
│   │   ├── add_arctic_ease2n_regions_v090.json
│   │   ├── add_arctic_hydro_regions_v090.json
│   │   ├── add_default_regions_from-vector_v090.json
│   │   ├── add_ease2n_hydro_regions_v090.json
│   │   ├── add_region_categories_v090.json
│   │   ├── ancillary-import-USGS-WRS_v090.json
│   │   ├── ancillary-import-kartturROI_2014_v090.json
│   │   ├── ancillary-import-mgrs_v090.json
│   │   ├── ancillary-import-modistileslonlat_v090.json
│   │   ├── ancillary-import-sentinel_tiles_v090.json
│   │   ├── ancillary_csv_v80.json
│   │   ├── ancillary_download_v090.json
│   │   ├── ancillary_mosaic_v090.json
│   │   ├── ancillary_root+organize_v090.json
│   │   ├── ancillary_tandemX-download_v090.json
│   │   ├── ancillaryprocess_v090.json
│   │   ├── graceProcess_v090.json
│   │   ├── grassProcess_v090.json
│   │   ├── landsatprocess_v090.json
│   │   ├── landsatprocess_v80.json
│   │   ├── layoutprocess_v090.json
│   │   ├── manage_project_v090.json
│   │   ├── manageuser_v090.json
│   │   ├── modis-DataPool-search_todb.json
│   │   ├── modis-search_data-pool.json
│   │   ├── modisProcess_checkups_v090.json
│   │   ├── modisProcess_root+search+download_v090.json
│   │   ├── modisProcess_root_v090.json
│   │   ├── modisProcess_v090.json
│   │   ├── modis_Polar_Process_v090.json
│   │   ├── modis_SINrid-NSIDC_Process_v090.json
│   │   ├── mosaic_process_v090.json
│   │   ├── overlay_average_v090.json
│   │   ├── overlay_root_v090.json
│   │   ├── periodicity_v090.json
│   │   ├── regions-DefaultRegionFromCoords_v80.json
│   │   ├── regions-root+categories_v090.json
│   │   ├── regions_DefaultRegionFromVector_v090.json
│   │   ├── regions_Tract+Site_FromVector_v090.json
│   │   ├── regions_links_v090.json
│   │   ├── regions_tractextent_v80.json
│   │   ├── regions_v090.json
│   │   ├── reproject_systemregion_process_v090.json
│   │   ├── sentinelProcess_v090.json
│   │   ├── smapProcess_v090.json
│   │   ├── tiling_process_v090.json
│   │   ├── timeseriesgraph_acfboxwhisker_v090.json
│   │   ├── timeseriesgraph_setup_v090.json
│   │   ├── timeseriesprocesses_assimilate_v090.json
│   │   ├── timeseriesprocesses_autocorr_v090.json
│   │   ├── timeseriesprocesses_correlate-lags_v090.json
│   │   ├── timeseriesprocesses_decompose_v090.json
│   │   ├── timeseriesprocesses_extract-min-max_v090.json
│   │   ├── timeseriesprocesses_extractseason_v090.json
│   │   ├── timeseriesprocesses_graphics_v090.json
│   │   ├── timeseriesprocesses_image-mend_v090.json
│   │   ├── timeseriesprocesses_imagecrosstrend_v090.json
│   │   ├── timeseriesprocesses_indexcrosstrend_v090.json
│   │   ├── timeseriesprocesses_resample_v090.json
│   │   ├── timeseriesprocesses_root-resample_v090.json
│   │   ├── timeseriesprocesses_season-fill_v090.json
│   │   ├── timeseriesprocesses_set-assimilation_v090.json
│   │   ├── timeseriesprocesses_significant-trends_v090.json
│   │   ├── timeseriesprocesses_trends_v090.json
│   │   ├── timeseriesprocesses_z-score_v090.json
│   │   ├── translate_process_v090.json
│   │   ├── updateLayer_v090.json
│   │   └── usgsProcess_root+search+download_v090.json
│   ├── landsatdoc
│   │   └── landsat_karttur_setup_20210128.txt
│   ├── modisdoc
│   │   └── modis_karttur_setup_20210127.txt
│   ├── regiondoc
│   │   ├── link-regions_karttur_setup_20181116.txt
│   │   ├── regions_karttur_setup_20181116.txt
│   │   └── regions_karttur_setup_20210117.txt
│   ├── sentineldoc
│   │   ├── sentinel_karttur_setup_2018116.txt
│   │   └── sentinel_karttur_setup_20210129.txt
│   ├── setup_process_main.py
│   ├── setup_process_process.py
│   ├── version.py
│   └── xml
│       ├── ancillary-import-USGS-WRS.xml
│       ├── ancillary-import-modistileslonlat.xml
│       ├── mgrs-extract_tile_coords.json
│       ├── mgrs-extract_tile_coords.xml
│       ├── modis-DataPool-search_todb.xml
│       ├── modis-search_data-pool.xml
│       ├── regions-modtiles_v80.xml
│       ├── regions-sentineltiles_v090.json
│       ├── regions-sentineltiles_v80.xml
│       ├── sentinel-extract_tile_coords.json
│       └── sentinel-extract_tile_coords.xml
├── smap
│   ├── LICENSE
│   ├── README.md
│   ├── __init__.py
│   ├── nsidc-download_SPL3FTA.003_2021-02-20.py
│   ├── smap.py
│   ├── version.py
│   └── {'e':\ 'ease2s'}_ease2s.json
├── support
│   ├── LICENSE
│   ├── README.md
│   ├── __init__.py
│   ├── csv2json.py
│   ├── doc
│   │   ├── hydroregion_setup.json
│   │   ├── northland_ease2n.csv
│   │   └── northland_ease2n.json
│   ├── earthsundist.py
│   ├── easegrid.py
│   ├── ftpdownload.py
│   ├── git_submodules_add.py
│   ├── karttur_dt.py
│   ├── kt_statistics.py
│   ├── landsat.py
│   ├── modis.py
│   ├── pymasker.py
│   ├── regionfit.py
│   ├── rgbcomposite.py
│   ├── submodule_stage-commit-push_script.py
│   ├── test.py
│   ├── topocorr.py
│   ├── version.py
│   ├── webcolors.py
│   └── xml2json.py
├── timeseries
│   ├── LICENSE
│   ├── README.md
│   ├── __init__.py
│   ├── numbautil.py
│   ├── timeseries.py
│   └── version.py
├── updatedb
│   ├── LICENSE
│   ├── README.md
│   ├── __init__.py
│   ├── updatedb.py
│   └── version.py
├── userproj
│   ├── LICENSE
│   ├── README.md
│   ├── __init__.py
│   ├── userproj.py
│   └── version.py
└── zipper
    ├── LICENSE
    ├── README.md
    ├── __init__.py
    ├── version.py
    └── zipper.py
```

{% endraw %}
{% endcapture %}
{% include widgets/toggle-code.html  toggle-text=text-capture  %}
</div>

### Prepare superproject for Eclipse



### Stage, commit and push

With the local clone of the superproject assembled, stage, commit and push it to the online origin repo.
