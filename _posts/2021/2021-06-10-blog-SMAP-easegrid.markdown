---
layout: post
title: SMAP EASE grid projections
categories: blog
datasource: smap
biophysical: soilwater
excerpt: "Handling EASE grid projections"
tags:
  - EASE
  - EASEGRID
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2021-06-10 T18:17:25.000Z'
modified: '2021-06-10 T18:17:25.000Z'
comments: true
share: true
---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>

# Introduction

Soil Moisture Active Passive (SMAP) images, as well as other satellite data products, are available as Equal-Area Scalable Earth (EASE) grid projected data sets. This post explains how to extract EASE-grid data from Hdf files while getting the correct projection and how this is done is Karttur's GeoImagine Framework.

## Prerequisites

The processing explained in this post relies on python and various packages, but does not strictly require Karttur's GeoImagine Framework.

## EASE-grid projection

The EASE-grid projection is detailed by the [National Snow & Ice Data Center (NSIDC)](https://nsidc.org/data/ease).

"The Equal-Area Scalable Earth (EASE) Grids are intended to be versatile formats for global-scale gridded data, including remotely sensed data. Data can be expressed as a digital array with one of many possible grid resolutions, which are defined in relation to one of four possible projections: Northern / Southern Hemispheres (Lambert's equal-area, azimuthal), temperate zones (cylindrical, equal-area), or global (cylindrical, equal-area)."

There are two generations of the EASE-grid projection; this post only deals with the more recent EASE-grid 2.0. EASE-grid 2.0 includes three different projections, each with its own [EPSG](https://epsg.io) code:

- North polar: [6931](https://epsg.io/6931)
- South polar: [6932](https://epsg.io/6932)
- Global/Tropical: [6933](https://epsg.io/6933)

[While the two polar projections are azimuthal equal-areas, the global/tropical projection is a cylindrical equal-area](https://nsidc.org/ease/ease-grid-projection-gt).

The links to each of regions above takes you to pages that describes each projection, and you can get the standard codes for each projection from there (including for proj4, Well Known Text [WKT] etc).

So far so good, the problems start when accessing Hdf5 (h5) compressed files with geographic data in EASE-grid 2.0. to continue when transforming to and from the polar azimuthal projections.

## EASE-grid extents

EASE-grid 2.0 uses the WGS84 datum, which greatly facilitates transformation to other projection that are also based on WGS84 (including geographic coordinates). The data supplied by NSIDC in the EASE-grid projection (including SMAP) have the information on map extent given as geographic coordinates (latitude and longitude). As the geographic coordinates also use WGS84, it should theoretically be rather easy to transform the geographic coordinates in lat/long to the EASE-grid projected x/y coordinates. For the cylindrical EASE-grid (EPSG:6933) girdling the equator it also works fine, but for the Northern / Southern Hemispheres (Lambert's equal-area, azimuthal) projections it does not. The next sections outlines how to get the proper projections defined.

### Transforming lat/lon to EASE-grid x/y

When accessing EASE-grid projected data from NSIDC (and other sources) you must know the extent or corners of the layer (band) that you want to access. These coordinates must be given in the projection of the layer (band), but are usually only available as lat/lon in the metadata. Before importing you thus need to translate the lat/lon coordinates to EASE-grid x/y. Three are at least two Python packages that handles geotransformations:

- gdal
- pyproj

#### gdal/osgeo

The [Geographic Data Abstraction Library (GDAL)](https://gdal.org) is part of [The Open Source Geospatial Foundation(OSGeo)](https://www.osgeo.org). You can install the Python binding of GDAL via [conda](https://anaconda.org/conda-forge/gdal):

<span class='terminal'>$  conda install -c conda-forge gdal</span>

or [pip](https://pypi.org/project/GDAL/):

<span class='terminal'>$  pip install GDAL</span>

With gdal installed, you can reproject map data as desribed in the [Python GDAL/OGR Cookbook - Projection](https://pcjericks.github.io/py-gdalogr-cookbook/projection.html). The essential code snippet for transforming from from geographic coordinates to an EASE-grid projection works like this:

```
# import the package
from osgeo import osr, ogr

# Set the source projection (geographic coordinates)
source = osr.SpatialReference()
source.ImportFromEPSG(4326) # 4326 represents geographic coordinates

# Set the target projection (EASE-grid)
target = osr.SpatialReference()
target.ImportFromEPSG(6933) # 6933 represents the global/tropial EASE grid

# Set the transformation
transform = osr.CoordinateTransformation(source, target)

# Create a coordinate point
point = ogr.CreateGeometryFromWkt("POINT (85.044502 -180 )")

# Transform the coordinate point
point.Transform(transform)

# print out the transformed coordinate point
print ( point.ExportToWkt() )
```

Note that as the source projection is geographic (lat/lon) you give the coordinates as _lat_ _lon_. The output of the above code snippet is:
```
POINT (-17367530.4451614 7314540.11134227)
```
If you look in the [documentation for the projected SMAP data](https://nsidc.org/ease/ease-grid-projection-gt), this is the upper left corner of the layers projected to the cylindrical (global/tropical) EASE-grid 6933. So that is all well and fine.

Change the target projection to North polar (EPSG:6931) and the coordinate point of the lower right corner of that projection as used for the SMAP data (_45_ _-180_).

```
# import the package
from osgeo import osr, ogr

# Set the source projection (geographic coordinates)
source = osr.SpatialReference()
source.ImportFromEPSG(4326) # 4326 represents geographic coordinates

# Set the target projection (EASE-grid)
target = osr.SpatialReference()
target.ImportFromEPSG(6931) # 6931 represents the north polar EASE grid

# Set the transformation
transform = osr.CoordinateTransformation(source, target)

# Create a coordinate point
point = ogr.CreateGeometryFromWkt("POINT (45 -180 )")

# Transform the coordinate point
point.Transform(transform)

# print out the transformed coordinate point
print ( point.ExportToWkt() )
```

The returned coordinates:
```
POINT (0.000000000598771 4889334.80295488)
```

is not correct (the correct coordinate is 9000000.0 -9000000.0).

#### pyproj

The [pyproj package](https://pyproj4.github.io/pyproj/stable/) is an interface to [PROJ](https://proj.org) (cartographic projections and coordinate transformations library). PROJ is a generic coordinate transformation software that transforms geospatial coordinates from one coordinate reference system (CRS) to another. This includes cartographic projections as well as geodetic transformations. PROJ is released under the [X/MIT open source license](https://proj.org/about.html#license). Also pyprpj can be installed either via [conda](https://anaconda.org/conda-forge/pyproj) or [pip](https://pypi.org/project/pyproj/). The code snippet for transforming from geographic coordinates to an EASE-grid:

```
# import the package
from pyproj import Proj, transform

# Set the source projection (geographic coordinates)
srcProj = Proj('epsg:4326') # 4326 represents geographic coordinates

# Set the target projection (EASE-grid)
dstProj = Proj('epsg:6933') # 6933 represents the global/tropial EASE grid

# Transform the coordinate point
x,y = transform(srcProj, dstProj, 85.044502, -180)

# print out the transformed coordinate point
print ('EASE-grid', x, y)
```

The result is the same as when using GDAL:

```
EASE-grid -17367530.445161372 7314540.111342266
```

### EASE grid data tools

NSIDC offers a suite of [EASE-Grid Data Tools](https://nsidc.org/data/ease/tools):

- easeconv.pro (for IDL)
- ezlhconv.c (+ hedaer file ezlhconv.h) (for C)
- ezlhconv.f (for fortran)

I did not test these tools, instead I got the default projection and extension of all products offered by NSIDC, and stored them in a database. When extracting and organizing data projected using EPSG I used the default data on extents from the database and thus simply bypassed the need for runtime projection.

### A last resort?

I found one python script that might work, posted on [stackexchange](https://stackoverflow.com/questions/57184305/how-can-i-convert-latitude-longitude-to-ease-grid-of-nasa). The documentation, however, was not sufficient for me to understand how to parameterize the transformation.

### Template database table

For all downloadable EASE-grid projected datasets, I created a table identifying the corners in both lat/lon and EASE-grid x/y. The database table contains data on the EASE-grid of each individual band within each hdf product. The extraction and projection of the data can be set to be done either at runtime or using a shell script and calling <span class='terminalapp'>gdal</span>.

### Extracting H5 (hdf v5) compressed datasets

Hdf v5 datasets can contain multiple layers, where each layer also can hold one or more bands. One dataset can further contain layers with different projections, and a single layer can contain data for more more than one region. The latter, I think, is, however, restricted to polar data so that there is one band for the north pole and one for the south pole. The projection numbers (dataset corners) are then equal, but the individual bands actually cover two different regions. This might sound a bit complicated, and it is. The solution I have developed for Karttur´s GeoImagine Framework is to also include information on the projection of individual layers and bands in the database template. When actually extracting the data, the user of the Framework can chose to extract data at runtime or generate a shell script that can be executed separately.

#### Runtime extraction with h5py

Extraction at runtime is best done using the [h5py](conda install h5py) package. Install the package by either using [conda](https://anaconda.org/anaconda/h5py) (<span class='terminal'>$ conda install -c anaconda h5py</span>) or [pip](https://pypi.org/project/h5py/) (<span class='terminal'>$ ip install h5py</span>). With h5py and gdal installed and the EASE-grid together with the upper left (ul) and lower right (lr) corners predefined in a database, the script for extracting a layer looks like this:

```
import h5py

import numpy as np

from osgeo import gdal, osr

def _ExtractHDF(layerD)

    with h5py.File(srcFPN mode="r") as f:

        datagrid = '/%(hdffolder)s/%(hdfgrid)s' %{'hdffolder':layerD['hdffolder'],'hdfgrid':layerD['hdfgrid']}

        data = f[datagrid][:]

        ncols = data.shape[1]

        nrows = data.shape[0]

        xmin, ymax, xmax, ymin = layerD['ulx'],layerD['uly'],layerD['lrx'],layerD['lry']

        xres = yres = ((xmax-xmin)/ncols + (ymax-ymin)/nrows)/2

        geotransform = (layerD['ulx'], xres, 0, layerD['uly'], 0, -yres)

        # create geotiff
        driver = gdal.GetDriverByName("Gtiff")

        if layerD['celltype'].lower() == 'float32':

            raster = driver.Create(dstLayer.FPN, int(ncols), int(nrows), 1, gdal.GDT_Float32)

        else:

            exitstr = 'EXIGING, cellytpe %s missing in assets.httpsdataaccess.AccessOnlineData._ExtractH5' %(layerD['celltype'])

            exit(exitstr)

        # set geotransform and projection

        srs = osr.SpatialReference()

        srs.ImportFromEPSG(layerD['epsg'])

        raster.SetGeoTransform(geotransform)

        raster.SetProjection(srs.ExportToWkt())

        # write data array to raster
        data[np.isnan(data)]=layerD['cellnull']

        raster.GetRasterBand(layerD['band']).WriteArray(data)

        raster.GetRasterBand(layerD['band']).SetNoDataValue(layerD['cellnull'])

        raster.FlushCache()

        raster = None
```

#### Shell script extraction with GDAL

The corresponding code for extracting layers using GDAL:
```
import h5py

import numpy as np

from osgeo import gdal, osr

def _ExtractHDF(layerD)

    cmd = 'gdal_translate -b %(band)s' %{'band':layerD['band']}

    cmd = '%(cmd)s -a_srs epsg:%(epsg)s' %{'cmd':cmd,'epsg':layerD['epsg']}

    cmd = '%(cmd)s -a_ullr %(ulx)f %(uly)f %(lrx)f %(lry)f' %{'cmd':cmd, 'ulx':layerD['ulx'], 'uly':layerD['uly'], 'lrx':layerD['lrx'], 'lry':layerD['lry']}

    cmd = '%(cmd)s  -a_nodata %(null)d -stats' %{'cmd':cmd, 'null':layerD['cellnull']}

    cmd = '%(cmd)s HDF5:"%(hdf)s"://%(folder)s/%(grid)s %(dst)s\n' %{'cmd':cmd,'hdf':srcLayerFile.FPN,
             'folder':layerD['hdffolder'],'grid':layerD['hdfgrid'], 'dst':dstLayer.FPN}
```

### Reprojection data

Once you have extracted and processed the EASE-grid projected data, you will want to combine it with other data sources. This requires transforming spatial data layers to and from the EASE-grid projection.

## Resources

[hdf5_2_geotiff.py at Github](https://github.com/Zepy1/satellite_analysis/blob/master/hdf5_2_geotiff.py)

Interesting, not yet checked out:
https://github.com/geohackweek/ghw2019_SnowAtlas

https://github.com/TUW-GEO/smap_io/

[EASE Grids Map Projection & Grid Definitions](https://nsidc.org/ease/ease-grid-projection-gt) by NSIDC

[Karttur´s GeoImagine Framework](https://karttur.github.io/setup-ide/)

[the EASE-Grid Projection](https://nsidc.org/ease/clone-ease-grid-projection-gt) by NSIDC

[EASE-Grid Data Tools](https://nsidc.org/data/ease/tools) at NSIDC

[EASE-Grid Geolocation Tools](https://nsidc.org/data/smmr_ssmi/tools)

[convert Northern EASE-Grid to Global EASE-Grid](https://nsidc.org/support/23169258-What-do-I-use-to-convert-Northern-EASE-Grid-to-Global-EASE-Grid-) at NSIDC

[hdf5_to_geotiff](https://github.com/Zepy1/satellite_analysis/blob/master/hdf5_2_geotiff.py) GitHub script for projecting SMAP layers in EASE-Grid 2

[smap_io - code](https://github.com/TUW-GEO/smap_io/tree/master/tests)
[smap_io - documentation](https://smap-io.readthedocs.io/en/latest/)
[the smap_io is recommended by NSIDC](https://www.earthdatascience.org/tutorials/create-raster-from-smap-soil-moisture-data/)

[How to Georeference and Convert NRT AMSR2 Snow Water Equivalent Polar EASE-Grid Data to GeoTIFF Format using Python and ArcGIS](https://ghrc.nsstc.nasa.gov/home/data-recipes/how-georeference-and-convert-nrt-amsr2-snow-water-equivalent-polar-ease-grid-data)
[Georef_AMSR2_SWE_PolarGrid_Data_Recipe.py](https://gitlab.com/NASA-GHRC-DAAC/data-recipes/blob/master/Georef_AMSR2_SWE_PolarGrid_Data_Recipe.py)

[pyproj](https://pyproj4.github.io/pyproj/stable/)

[pyproj - LambertAzumuthalEqualAreaConversion](https://pyproj4.github.io/pyproj/dev/api/crs/coordinate_operation.html)

Stackexchange

[How to fix the reprojection from EASE-2 grid product SMAP to geographic coordinates?](https://gis.stackexchange.com/questions/253923/how-to-fix-the-reprojection-from-ease-2-grid-product-smap-to-geographic-coordina) - the solution for setting the correct projecting when extracting h5 EASE-grid data.

[How to re-project the EASE (Equal Area Scalable Earth) grid with a ~25 km cylindrical projection to WGS84 0.25 degree?](https://gis.stackexchange.com/questions/47991/how-to-re-project-the-ease-equal-area-scalable-earth-grid-with-a-25-km-cylind)

[How can I convert latitude-longitude to ease grid of NASA?](https://stackoverflow.com/questions/57184305/how-can-i-convert-latitude-longitude-to-ease-grid-of-nasa) contains 2 python modules for the coordinate transformation.
