### Script for installation py37 virtual environment under Anconda ###
### macos ###
### 14 Feb 2021 ###

# Assumed default packages in -condarc
#create_default_packages:
#  - cartopy
#  - fiona
#  - gdal
#  - geopandas
#  - h5py
#  - matplotlib
#  - netcdf4
#  - numba
#  - numpy
#  - pandas
#  - pip
#  - psycopg2
#  - rasterio
#  - scipy
#  - statsmodels
#  - xmltodict

# Create the new environment
# The hyphen signs are sensitive and might not come out correct in copy paste

conda create --name geoimagine_202003_py37a python=3.7

# activate the new environment

conda activate geoimagine_202003_py37a

# pip install landsat explore

pip install landsatxplore

# conda install plotnine via conda-forge

conda install -c conda-forge plotnine

# pip install seasonal

pip install seasonal

# conda install sentinelsat via conda-forge

conda install -c conda-forge sentinelsat

# pip install svgis

pip install svgis

# conda install svgwrite via conda-forge

conda install -c conda-forge svgwrite

# pip install ggtools

pip install ggtools

# This pip updated numpy from 1.19.2 to 1.20.1

# Export the virtual environment

conda env export > geoimagine_202003_py37a.yml
