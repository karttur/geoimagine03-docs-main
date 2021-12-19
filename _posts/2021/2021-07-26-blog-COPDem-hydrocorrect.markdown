---
layout: post
title: DTM hydrological corrections
categories: blog
datasource: dem
excerpt: "Hydrological corrections of Digital Terrain Models"
tags:
  - Copernicus DEM
  - hydrology
  - filling pits
  - leveling stremas
  - flattening peaks
  - GRASS
  - r.rill.dir
  - r.hydrodem
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2021-07-26 T18:17:25.000Z'
modified: '2021-07-26 T18:17:25.000Z'
comments: true
share: true
---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>

# Introduction

Digital Terrain Models (DTMs) are widely used for routing water flow through the landscape. Ideally the hillside and its valley should show progressively lower elevations until the stream empties in a larger river and then the sea. This is, however, seldom the case and most DTMs will contain artificial smaller pits and larger depressions. Water levels are notoriously difficult to capture. In side looking Synthetic Aperture Radar (SAR) data (the most common source method fore deriving global DEMs), water surfaces are often depressed relative to other surfaces. Vegetated ground, on the other hand, is often elevated as the true terrain level is hidden below a dense canopy.

This manual covers how to use [GRASS GIS](https://grass.osgeo.org) and Karttur's GeoImagine Framework for hydrological correction of DTMs.

## Prerequisites

To follow this manual you need to have [GRASS GIS](https://karttur.github.io/setup-ide/setup-ide/install-gis/#grass) installed and if you want to automate the hydrological correction fo a global dataset you also need to Karttur's GeoImagine Framework. You can apply the processing to any DTM; the manual uses the 90 m version of [Copernicus DEM](https://karttur.github.io/geoimagine02-docs/blog/blog-global-dems/) as an example.

## Depression filling

Many advanced Geographic Information Systems (GIS) include routines for hydrological correction of DTMs. The correction basically consist of filling up all pits (from single cell holes to large depressions) to the lowest outlet threshold. Pits and depressions might, however, be real, and it is usually recommended to only fill smaller pits or apply a mask that identifies real depressions beforehand.

If you only want to process Digital Elevation data and have no GIS package, you can try [Terrain Analysis Using Digital Elevation Models (TAUDEM)](https://hydrology.usu.edu/taudem/taudem5/), that is also integrated into ArCGIS. Otherwise [GRASS GIS](https://grass.osgeo.org), used in this manual, is available for free for al major platforms.

### GRASS modules

There are two different raster modules in GRASS that can be applied for pit removal in DTMs: [r.fill.dir](https://grass.osgeo.org/grass78/manuals/r.fill.dir.html) and [r.hydrodem](https://grass.osgeo.org/grass78/manuals/addons/r.hydrodem.html). [r.hydrodem](https://grass.osgeo.org/grass78/manuals/addons/r.hydrodem.html) is an [addon](https://grass.osgeo.org/grass78/manuals/addons/) and you need to install it in your GRASS package.

#### Install r.hydrodem addon

To install [r.hydrodem](https://grass.osgeo.org/grass78/manuals/addons/r.hydrodem.html), start a GRASS GIS session and go the GRASS terminal window and execute the command:

<span class='terminal'>g.extension extension=r.hydrodem</span>

## Simple depression filling

You can apply [r.fill.dir](https://grass.osgeo.org/grass78/manuals/r.fill.dir.html) or [r.hydrodem](https://grass.osgeo.org/grass78/manuals/addons/r.hydrodem.html) for a direct DEM correction. To fill single cell pits with [r.fill.dir](https://grass.osgeo.org/grass78/manuals/r.fill.dir.html), set the _-f_ flag and then:

<span class='terminal'>r.fill.dem -f input=srcDEM output=dstDEM direction=dstFlowDir</span>

This is the recommended use of [r.fill.dir](https://grass.osgeo.org/grass78/manuals/r.fill.dir.html) if applying the GRASS module [r.watershed](https://grass.osgeo.org/grass76/manuals/r.watershed.html) for analysing hydrology. For correcting larger areas than a single cell it is better to use [r.hydrodem](https://grass.osgeo.org/grass78/manuals/addons/r.hydrodem.html). With [r.hydrodem](https://grass.osgeo.org/grass78/manuals/addons/r.hydrodem.html) you can set the maximum size (in cells) of the pits to fill, which gives better control compared to [r.fill.dir](https://grass.osgeo.org/grass78/manuals/r.fill.dir.html). To fill pits that are up to 5 cells large, the command line for [r.hydrodem](https://grass.osgeo.org/grass78/manuals/addons/r.hydrodem.html) looks like this:

<span class='terminal'>r.hydrodem -f input=srcDEM output=dstDEM mod=5 size=5</span>

## Filling using vectors and SQL

Identifying cells that are depressed, vectorise them, assemble more data and then apply an SQL for the actual pit filling has several advantaged. Most importantly you can fill pits of various sizes dependent of local conditions, for instance only cells that are associated with streams. Converting the pit filling to vectors also allow for easier testing of alternative filling strategies (you only need to alter the SQL, not run the entire analysis), and you can rather easily also tile the original dataset and fill smaller tiles sequentially (that can also be done using raster data but you loose the flexibility).

Having tried [r.fill.dir](https://grass.osgeo.org/grass78/manuals/r.fill.dir.html) on DEMs with 100 to 1000 M cells (10000 to 30000 rows/columns), the processing time becomes almost insurmountable. This can be solved by tiling the original DEM and then iterate the pit filling over each tile. To avoid edge effects the tiles must overlap. The overlap should be larger than the maximum cell area for pits to fill (i.e. if you want to fill pits that are up to 5 cells large, the overlap should be 6 cells).

## Flattening peaks

In most cases DTMs overestimate the surface elevation as the signal is rather caused by the canopy (or buildings) covering the ground level terrain. These errors will be most apparent, and have the largest negative impact on e.g. hydrological modelling, at edges (e.g. forest boundaries) where the relative elevation difference will be exaggerated. The largest errors tend to be with SAR data and at water edges, where the water surface is artificially depressed (due to double bouncing on the water surface and the shore prolonging the signal travel distance). Flattening peaks adjacent to water surface can be applied to decrease these problems. Flattening peaks adjacent to water bodies will increase the hydrological wetness of these positions, facilitate flooding etc.

You can apply either [r.fill.dir](https://grass.osgeo.org/grass78/manuals/r.fill.dir.html) or [r.hydrodem](https://grass.osgeo.org/grass78/manuals/addons/r.hydrodem.html) for flattening peaks by simply inverting the DEM and identify pits (inverted peaks)  and then fill (flatten) them. To only flatten peaks adjacent to water bodies you need to assemble data on drainage from the DEM itself, or from an ancillary data source, and then apply an SQL.

## Pit filling and peak flattening using SQL

The principal steps for identifying single cell pits (with the _-f_ flags set in [r.fill.dir](https://grass.osgeo.org/grass78/manuals/r.fill.dir.html)) in a DEM in GRASS:


```
- r.fill.dir -f input=srcDEM output=fillDEM
- r.mapcalc diffdem=fillDEM-srcDEM
- r.to.vect input=diffdem output=diffdem type=point
- v.db.addcolumn map=diffdem columns="filldem DOUBLE PRECISION"
- v.what.rast map=filldem column=filldem raster=filldem
```

In a similar manner also the peaks can be identified:

```
- r.mapcalc invDEM=10000-srcDEM
- r.fill.dir -f input=invDEM output=peakDEM
- r.mapcalc diffdem=peakDEM-invDEM
- r.to.vect input=diffdem output=diffdem type=point
- v.db.addcolumn map=diffdem columns="invdem DOUBLE PRECISION, filldem DOUBLE PRECISION"
- v.what.rast map=filldem column=invdem raster=filldem
- v.db.update map=filldem column=filldem query_column="10000-(invdem)"
```

### A complete loop for tiles

Combining the ideas of filling pits and flattening peaks with the use additional information and SQL _and_ a tiling process to speed up the processing, is implemented in Karttur´s GeoImagine Framework. For each DEM layer, an initial set of commands is required:

```
# create a new mapset
g.mapset -c tile_id

# import the source DEM
r.in.gdal input=/path/to/dem.tif output=iniDEM  --overwrite

# Set region after DEM
g.region raster=iniDEM

# Reclass sea level to null to speed up by skipping all tiles that are only null
r.mapcalc "nullDEM = if((iniDEM == 0), null(), iniDEM )" --overwrite

# There is a bug in r.fill.dir and you must reclass all no data to a very low elevation (-1000)
r.mapcalc "srcDEM = if(isnull(iniDEM), -1000, iniDEM )" --overwrite

#r.watershed to get upstream areas and streams for queries
r.watershed -a elevation=nullDEM accumulation=MFD_updrain stream=MFD_stream threshold=2000--overwrite
```

Then loop for each tile using the terminal itself to determine whether or not a particular tile contains any valid elevations data. The example below is for tile at columns=0 and row=0. By default the Framework uses GDAL for superimposing the filled/flattened DEM values. This is more efficient compared to using GRASS and can be done on the fly in the script.

```
# Set the region to the tile including an overlap
g.region -a n=-2609100.000000 s=-2700000.000000 e=-5309100.000000 w=-5400000.000000

# Check if there is any valid elevations in this tile (region), if not just skip this tile
data="$(r.stats -p input=nullDEM null_value='null')"
if echo "$data" | grep -q "null\s100"; then

    echo "Null tile - skipping"

else

    echo "Valid tile"

    #### First part - fill pits ###

    r.fill.dir -f input=srcDEM output=filldir_0_0 direction=hydro_ptfill_draindir_0_0 areas=hydro_ptfill_problems_0_0 --overwrite

    # Reset region to just the tile
    g.region -a n=-2610000.000000 s=-2700000.000000 e=-5310000.000000 w=-5400000.000000

    r.mapcalc "diff_0_0 = filldir_0_0 - srcDEM" --overwrite

    r.mapcalc "fillarea_0_0 = if( diff_0_0 != 0, 1, null() )" --overwrite

    r.to.vect input=fillarea_0_0 output=fillpt_0_0 type=point --overwrite

    v.db.addcolumn map=fillpt_0_0             columns="updrain DOUBLE PRECISION, column=filldem

    v.what.rast map=fillpt_0_0 column=filldem raster=filldir_0_0

    v.what.rast map=fillpt_0_0 column=updrain raster=MFD_updrain

    v.out.ogr input=fillpt_0_0 type=point format=ESRI_Shapefile output=/path/to/vector.shp --overwrite

    # Rasterize using GDAL - more efficient and canbe done on a tile per tile basis
    GDAL_rasterize -a filldem /path/to/vector.shp /path/to/dstDEM.tif

    ### Second part - flatten peaks ###

    # Set the regions to the tile including an overlap
    g.region -a n=-2609100.000000 s=-2700000.000000 e=-5309100.000000 w=-5400000.000000

    r.mapcalc "invertedDEM_0_0 = 10000-srcDEM" --overwrite

    r.fill.dir -f input=invertedDEM_0_0 output=flattenpeak_0_0 direction=hydro_pkflat_draindir_0_0 areas=hydro_pkflat_problems_0_0 --overwrite

    g.region -a n=-2610000.000000 s=-2700000.000000 e=-5310000.000000 w=-5400000.000000

    r.mapcalc "diff_0_0 = flattenpeak_0_0 - invertedDEM_0_0" --overwrite

    r.mapcalc "fillarea_0_0 = if( diff_0_0 != 0, 1, null() )" --overwrite

    r.to.vect input=fillarea_0_0 output=fillpt_0_0 type=point --overwrite

    v.db.addcolumn map=fillpt_0_0             columns="area_cells INT, area_km2 DOUBLE PRECISION, invdem DOUBLE PRECISION, filldem DOUBLE PRECISION, nbupmax DOUBLE PRECISION, nbupq3 DOUBLE PRECISION, nbdemq1 DOUBLE PRECISION, nbdemmin DOUBLE PRECISION"

    v.what.rast map=fillpt_0_0 column=invdem raster=flattenpeak_0_0

    v.db.update map=fillpt_0_0 column=filldem query_column="10000-(invdem)"

    r.neighbors input=srcDEM selection=diff_0_0             output=dem_neighbor_quart1_0_0,dem_neighbor_min_0_0  method=quart1,minimum --overwrite

    r.neighbors input=MFD_updrain selection=diff_0_0             output=inverted_neighbor_max_0_0,inverted_neighbor_quart3_0_0 method=maximum,quart3 --overwrite

    v.what.rast map=fillpt_0_0 column=nbupmax raster=inverted_neighbor_max_0_0

    v.what.rast map=fillpt_0_0 column=nbupq3 raster=inverted_neighbor_quart3_0_0

    v.what.rast map=fillpt_0_0 column=nbdemq1 raster=dem_neighbor_quart1_0_0

    v.what.rast map=fillpt_0_0 column=nbdemmin raster=dem_neighbor_min_0_0

    v.out.ogr input=fillpt_0_0 type=point format=ESRI_Shapefile output=/path/to/vector.shp --overwrite

    # Rasterize using GDAL - more efficient and canbe done on a tile per tile basis
    GDAL_rasterize -a nbdemq1 -where "nbupmax >= 500 AND nbupmax <= 50000 AND nbupq3 >= 250" /path/to/vector.shp /path/to/dstDEM.tif

    g.remove -f type=raster pattern="*_0_0"

    g.remove -f type=vector pattern="*_0_0"
fi
```

### Automating with Karttur's GeoImagine Framework

Expanding the script above to run say 100 tiles for one large DEM must be automated. That is done using Karttur´s GeoImagine Framework, and the process _GrassDemFillDirTiles_. The json object setup for Copernicus DEM in 90 m projected and tiled to ease-GRID north, is shown here:

```

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
      "processid": "GrassDemFillDirTiles",
      "version": "1.3",
      "overwrite": false,
      "parameters": {
        "asscript": true,
        "superimpose": false,
        "pitsize": 1,
        "pitquery": "",
        "peaks": true,
        "peakquery": "nbupmax >= 500 AND nbupq3 >= 250",
        "mosaic": true
      },
      "srcpath": {
        "volume": "Ancillary",
        "hdr": "tif"
      },
      "dstpath": {
        "volume": "Ancillary",
        "hdr": "tif"
      },
      "srccomp": [
        {
          "copdem90": {
            "source": "ESA",
            "product": "copdem",
            "content": "dem",
            "layerid": "copdem",
            "prefix": "dem",
            "suffix": "v01-90m"
          }
        }
      ],
      "dstcopy": [
        {
          "copdem90": {
            "source": "copy",
            "product": "copy",
            "content": "copy",
            "layerid": "copy",
            "prefix": "copy",
            "suffix": "v01-pfpf-90m"
          }
        }
      ]
    }
  ]
}
```

The command above will run all 104 tiles composing the northern hemisphere DEM in the region _northlandease2n_ [Link to post defining region](#). The script file contains around 50,000 lines.

### And using r.hydrodem instead

As note d above, for filling pits larger that a single cell, [r.hydrodem](https://grass.osgeo.org/grass78/manuals/addons/r.hydrodem.html) is a better alternative. The principal steps for applying [r.hydrodem](https://grass.osgeo.org/grass78/manuals/addons/r.hydrodem.html) are the same as for [r.fill.dir](https://grass.osgeo.org/grass78/manuals/r.fill.dir.html). The advantage with [r.hydrodem](https://grass.osgeo.org/grass78/manuals/addons/r.hydrodem.html) is that you can set the size (in cells) of the pits to be filled. This also fills the bottom troughs in larger depressions. The size of the pits of fill are set with two parameters, _size_ and _mod_. Where _size_ is the maximum sized depressions (in cells) to remove and _mod_ is the maximum region (in cells) to modify overall for removing the depression. Both are defaulted to 4 if not explicitly set.

The
```
g.region -a n=-1169100.000000 s=-1260900.000000 e=-4859100.000000 w=-4950900.000000

data="$(r.stats -p input=nullDEM null_value='null')"
if echo "$data" | grep -q "null\s100"; then
    echo "Null tile - skipping"
else
    echo "Valid tile"
    r.hydrodem  input=srcDEM output=hydrodem_5_6 size=5 mod=5 memory=3000 --overwrite
    g.region -a n=-1170000.000000 s=-1260000.000000 e=-4860000.000000 w=-4950000.000000

    r.mapcalc "diff_5_6 = hydrodem_5_6 - srcDEM" --overwrite
    r.mapcalc "fillarea_5_6 = if( abs(diff_5_6) >= 0.010000, 1, null() )" --overwrite
    r.to.vect input=fillarea_5_6 output=fillarea_5_6 type=area --overwrite
    v.to.db map=fillarea_5_6 type=centroid option=area columns=area_km2 units=kilometers
    v.db.addcolumn map=fillarea_5_6 columns="filldem DOUBLE PRECISION, area_cells INT"
    v.what.rast type=centroid map=fillarea_5_6 column=filldem raster=hydrodem_5_6
    v.db.update fillarea_5_6 column=area_cells qcol="area_km2/0.008100"

    r.to.vect input=fillarea_5_6 output=fillpt_5_6 type=point --overwrite
    v.db.addcolumn map=fillpt_5_6         columns="area_cells INT, area_km2 DOUBLE PRECISION, filldem DOUBLE PRECISION, updrain DOUBLE PRECISION"
    v.to.rast input=fillarea_5_6 output=area_km2_5_6 use=attr attribute_column=area_km2 memory=3000 --overwrite
    v.what.rast map=fillpt_5_6 column=area_km2 raster=area_km2_5_6
    v.what.rast map=fillpt_5_6 column=filldem raster=hydrodem_5_6
    v.what.rast map=fillpt_5_6 column=updrain raster=MFD_updrain

    v.db.update fillpt_5_6 column=area_cells qcol="area_km2/0.008100"

    v.out.ogr input=fillarea_5_6 type=area format=ESRI_Shapefile output=/Volumes/karttur/ease2n/ESA/tiles/demfillscript/x04y08/hydrodem_area_5_6.shp --overwrite

    g.remove -f type=raster pattern="*_5_6"
fi

```


### r.denoise

The GRASS module [r.denoise](https://grass.osgeo.org/grass78/manuals/addons/r.denoise.html) is a feature-preserving mesh denoising algorithm. It removes random noise while preserving sharp features and smoothing with minimal changes to the original data. [r.denoise](https://grass.osgeo.org/grass78/manuals/addons/r.denoise.html) is a python script that allows the algorithm to be run on DEMs from within GRASS. Denoising DEMs can improve clarity and quality of derived products such as slope and hydraulic maps.

The denoise algorithm is available as a stand alone script for all major platforms (Windows, Linux and MacOS) from [The University of Manchester - Using Sun's denoising algorithm on topographic data](https://personalpages.manchester.ac.uk/staff/neil.mitchell/mdenoise/).

The denoising smooths the data strongly. The [r.denoise GRASS page](https://grass.osgeo.org/grass78/manuals/addons/r.denoise.html), recommends setting the parameter _threshold_ to 0.99 (compared to a default of 0.93). A quick test of varying the _threshold_ parameter, I would suggest setting it between 0.999 and 0.9999 for processed DEM data like SRTM or Copernicus DEM. The advantage with denoising is that artificial bumps are removed, but also true bumps are sacrificed int he process. For hydrological modeling this can be advantageous, but requires a model that can handle the pits that form as a consequence of the smoothing. If you use GRASS and [r.watershed](#) that is not a problem. Note, however, that the surface of water bodies, and the sea, will change. At least for he sea level (0 m.a.s.l) you need to reset that to 0 if you want to use the [_basin_delineate_ package](#).
