---
layout: article
title: Sphinx python documentation
categories: develop
excerpt: Use Sphinx for documenting python packages and modules
previousurl: develop/develop-github-eclipse
nexturl: prep/prep-dblink/
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2022-09-27'
modified: '2022-09-27'
comments: true
share: true
figure15: github-framework_karttur_15_new-other
figure16: github-framework_karttur_16_pydev-package
figure17: github-framework_karttur_17_pydev-package2
---

## Introduction

Having spent 6 months trying to develop the business side of my projects while leaving my python programming untouched, I realise that the documentation of my python projects, packages and modules have much to desire. This post lists some options for documentation of python code and explains how to install the python package [<span class='package'>sphinx</span>](https://www.sphinx-doc.org) and then use it for html documentation of packages and modules.

## Python documentation generators

Looking for a python documentation generator I searched for reviews and comparisons. I only knew about [Doxygen](https://doxygen.nl/manual/docblocks.html), but then also found [Sphinx](http://www.sphinx-doc.org/en/master/index.html), [pdoc](https://github.com/BurntSushi/pdoc) and [pydoctor](https://github.com/twisted/pydoctor).

For a comparing review see [Peter Kong (2018) Comparison of Python documentation generators](https://medium.com/@peterkong/comparison-of-python-documentation-generators-660203ca3804). For a more complete (but still not up-to-date) list see [python wiki page on Documentation tools](https://wiki.python.org/moin/DocumentationTools).

Having looked around, I chose [Sphinx](http://www.sphinx-doc.org/en/master/index.html) as the documentation generator for my python coding.

## Install Sphinx

[<span class='package'>Sphinx</span>](https://www.sphinx-doc.org) is installed using the <span class='app'>Terminal</span>. The <span class='package'>Sphinx</span> package is not part of Karttur´s Geoimagine Framework, it is thus better to setup a separate [virtual python environment](https://karttur.github.io/geoimagine03-docs-main/prep/prep-conda-environ/) that is only used for <span class='package'>Sphinx</span>. Note, however that this environment also must contain all the python packages used by the packages and modules you intend to document. Thus if you have a default environment for your virtual python environment, keep it. Otherwise you can add the missing packages as they are requested by Sphinx.

<span class='terminal'>(base) user ~ % conda create -n sphinx python </span>

Activate the new environment

<span class='terminal'>% conda activate sphinx </span>

Install <span class='package'>Sphinx</span> to your new environment using either <span class='terminalapp'>conda</span> or <span class='package'>pip</span>.

### Conda

Install <span class='package'>Sphinx</span> using [conda](https://anaconda.org/anaconda/sphinx):

<span class='terminal'>(sphinx) user ~ % conda install -c anaconda sphinx</span>

Then also install the add-on packages <span class='package'>sphinx_rtd_theme</span>, <span class='package'>autodocsumm</span> and <span class='package'>nbsphinx</span>:

<span class='terminal'>(sphinx) user ~ % conda install -c conda-forge sphinx_rtd_theme</span>

<span class='terminal'>(sphinx) user ~ % conda install -c conda-forge autodocsumm</span>

<span class='terminal'>(sphinx) user ~ % conda install -c conda-forge nbsphinx</span>

### Pip

With [pip](https://pypi.org/project/Sphinx/) you can install both <span class='package'>sphinx</span> and <span class='package'>sphinx_rtd_theme</span> with a single command:

<span class='terminal'>(sphinx) user ~ % pip install sphinx sphinx_rtd_theme</span>

And then separately install <span class='package'>autodocsumm</span> and <span class='package'>nbsphinx</span>:

<span class='terminal'>(sphinx) user ~ % pip install autodocsumm</span>

<span class='terminal'>(sphinx) user ~ % pip install nbsphinx</span>

## Generate python documentation with Sphinx

This part of the post was inspired by the article [Documenting Python code with Sphinx](https://towardsdatascience.com/documenting-python-code-with-sphinx-554e1d6c4f6d) by Yash Salvi. I also looked at the youtube instruction [Auto-Generated Python Documentation with Sphinx](https://www.youtube.com/watch?v=b4iFyrLQQh4) by avcourt. If you want to get a better grip on Sphinx I suggest that you follow the [hands-on manual by Yash Salvi](https://towardsdatascience.com/documenting-python-code-with-sphinx-554e1d6c4f6d). The [3-part tutorial by Kay Jan Wong](https://towardsdatascience.com/advanced-code-documentation-beyond-comments-and-docstrings-2cc5b2ace28a) is more up to date.

### Prepare your python package and modules

My python projects are built using clusters of packages linked together using a git hyperproject. I save the packages as separate [GitHub](https://github.com) repos. Consequently, the documentation is also created and saved on a per package (repo) basis. Thus the title of this section package in singular and modules in plural.

To make use of <span class='package'>Sphinx</span> you need to prepare your python modules by writing [_Docstrings_](https://sphinx-rtd-tutorial.readthedocs.io/en/latest/docstrings.html).

#### Docstrings

Sphinx can be parameterised to produce different types of documentation (html, latex or linkcheck) with different formats and contents. But regardless of how you parameterise and which extensions or themes (extensions and themes are introduced further down) you use, you must have created strictly defined comments, or _Docstrings_ for Sphinx to read.

For Sphinx to work, a typical python class ("class") or function ("def") must start with an initial, triple quote (\"\"\") enclosed _Docstring_. This comment is read and interpreted by Sphinx. As we are going to use the _theme_ "read_the_docs" or _rtd_ to generate the documentation in this tutorial, we need to use a syntax format that fits the _rtd_ theme. We can choose between the [default format](https://sphinx-rtd-tutorial.readthedocs.io/en/latest/docstrings.html), a [google format](https://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_google.html) or a [numpy format](https://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_numpy.html#example-numpy). Kay Jan Wong [summarises the differences in syntax](https://towardsdatascience.com/advanced-code-documentation-beyond-comments-and-docstrings-2cc5b2ace28a#c256).

##### Sphinx rtd theme default format

The Sphinx _rtd_ theme standard format syntax (called _sphinx_) looks like the example below (see [Sphinx-RTD-Tutorial on Writing Docstrings](https://sphinx-rtd-tutorial.readthedocs.io/en/latest/docstrings.html) for details):

```
def ReadImportParamsJson(jsonFPN):
    """ Read the parameters for importing OSSL data

    :param jsonFPN: path to json file
    :type jsonFPN: str

    :return paramD: nested parameters
    :rtype: dict
   """

    with open(jsonFPN) as jsonF:

        paramD = json.load(jsonF)

    return (paramD)
```

##### Sphinx rtd theme numpy format

The [numpy format](https://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_numpy.html#example-numpy) for the Sphinx rtd theme is more comprehensive. But also more demanding. Here is the numpy format syntax using the same example as above:

```
def ReadImportParamsJson(jsonFPN):
    """ Read the parameters for importing OSSL data

    Parameters
    ----------
    jsonFPN : str
        path to json file.

    Returns
    -------
    paramD
        nested paramters
   """

    with open(jsonFPN) as jsonF:

        paramD = json.load(jsonF)

    return (paramD)
```

The advantage with the numpy and google formats are that more complex information can be conveyed by extending the underscored heading system. For complex packages and packages assembled into projects, this is an advantage. The rest of this post will thus use the [numpy format syntax](https://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_numpy.html#example-numpy).

### Quickstart sphinx

Open a <span class='app'>Terminal</span> window. To do the following operations you need to activate the conda environment with sphinx, e.g.:

<span class='terminal'>% conda activate sphinx </span>

<span class='terminalapp'>cd</span> to the parent folder of the python package you want to document. Create a sibling folder to the actual package folder, and call the sibling <span class='file'>docs</span>.

<span class='terminal'>(sphinx) pythonPackageParentFolder % mkdir docs</span>

<span class='terminalapp'>cd</span> to the <span class='file'>docs</span> directory:

<span class='terminal'>(sphinx) pythonPackageParentFolder % cd docs</span>

Create the back-bone for a sphinx documentation by running <span class='terminalapp'>sphinx-quickstart</span>:

<span class='terminal'>(sphinx) docs % sphinx-quickstart</span>

A set of interactive questions follows, accept any default suggested and add the project name and yourself as the author.

```
docs % sphinx-quickstart
Welcome to the Sphinx 5.0.0 quickstart utility.

Please enter values for the following settings (just press Enter to
accept a default value, if one is given in brackets).

Selected root path: .

You have two options for placing the build directory for Sphinx output.
Either, you use a directory "_build" within the root path, or you separate
"source" and "build" directories within the root path.
> Separate source and build directories (y/n) [n]:

The project name will occur in several places in the built documentation.
> Project name: sphinx-test
> Author name(s): Thomas G
> Project release []:

If the documents are to be written in a language other than English,
you can select a language here by its language code. Sphinx will then
translate text that it generates into that language.

For a list of supported codes, see
https://www.sphinx-doc.org/en/master/usage/configuration.html#confval-language.
> Project language [en]:

Creating file /Users/.../docs/conf.py.
Creating file /Users.../docs/index.rst.
Creating file /Users/.../docs/Makefile.
Creating file /Users/.../docs/make.bat.

Finished: An initial directory structure has been created.

You should now populate your master file /Users/.../docs/index.rst and create other documentation
source files. Use the Makefile to build the docs, like so:
   make builder
where "builder" is one of the supported builders, e.g. html, latex or linkcheck.
```

Check out the directory and file structure created with the <span class='terminalapp'>tree</span> command:

<span class='terminal'>% tree</span>

```
.
├── Makefile
├── _build
├── _static
├── _templates
├── conf.py
├── index.rst
└── make.bat
```

To put on flesh (that is create an output document) on this back-bone, the following steps are required:

- edit the configuration file (conf.py),
- generate .rst files,
- edit the .rst files, and
- build ("make") the output files.

### Edit conf.py

The configuration file contains information and instructions for the generation of the <span class='file'>rst</span> files. Thus you need to make some edits in <span class='file'>conf.py</span>.

1. Uncomment the three lines (while changing the last to have double dots):
   - import os
   - import sys
   - sys.path.insert(0, os.path.abspath('..'))
2. Edit project information (in case you did a typo):
   - project = 'sphinx-test'
   - copyright = '2022, Thomas G'
   - author = 'Thomas G'
3. Add extensions (in our case that should include):
   - 'sphinx.ext.autodoc',
   - 'sphinx.ext.viewcode',
   - 'sphinx.ext.napoleon',
   - 'autodocsumm'
4. Change the html_theme:
  - html_theme = 'sphinx_rtd_theme'

You should recognise the extension _autodocsumm_ and the html_theme _sphinx_rtd_theme_ as the two add-on packages we installed before. <span class='file'>conf.py</span> should now look like this:

```
# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Path setup --------------------------------------------------------------

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#
import os
import sys
sys.path.insert(0, os.path.abspath('..'))


# -- Project information -----------------------------------------------------

project = 'OSSL-import'
copyright = '2022, Thomas Gumbricht'
author = 'Thomas Gumbricht'


# -- General configuration ---------------------------------------------------

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = [
    'sphinx.ext.autodoc',
    'sphinx.ext.viewcode',
    'sphinx.ext.napoleon',
    'autodocsumm'
]

autodoc_default_options = {"autosummary": True}

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']


# -- Options for HTML output -------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
html_theme = 'sphinx_rtd_theme'

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['_static']
```

### Generare restructred text (rst) files

To use the configuration that you set above and let sphinx create the content (but not the skin so to say), run the command [<span class='terminalapp'>sphinx-apidoc</span>](https://www.sphinx-doc.org/en/master/man/sphinx-apidoc.html). We just want to create a set of output (option: \-o) files; we want them to be saved in the directory we are in, and the source is the parent folder. The default extension for the output files is <span class='file'>.rst</span>. The command then becomes:

<span class='terminal'>(sphinx) docs % sphinx-apidoc -o . ..</span>

If your terminal cursor is not in the <span class='file'>docs</span> sibling folder to the python package that you are documenting you need to adjust the command.

If you rerun the <span class='terminalapp'>tree</span> command you should see how <span class='terminalapp'>sphinx-apidoc</span> generated a new set of <span class='file'>rst</span> and (empty) directories :

<span class='terminal'>% tree</span>

```
.
├── Makefile
├── _build
├── _static
├── _templates
├── conf.py
├── index.rst
├── make.bat
├── maths.rst
└── modules.rst
```

### Edit rst files

Designing the final documentation content, style and layout is done by editing the <span class='file'>rst</span> files. For our first trial we are just going to add the package modules (<span class='file'>modules.rst</span>) to the front (main) page (<span class='file'>index.rst</span>). Open <span class='file'>index.rst</span> and add the line
```
modules
```
```
.. sphinx-test documentation master file, created by
   sphinx-quickstart on Wed Sep 28 14:29:36 2022.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome to sphinx-test's documentation!
=======================================

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   modules

Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
```

### Generate output

You are now ready to generate the output, for instance html pages. To do that you run the <span class='file'>make.bat</span> file created by sphinx in the <span class='file'>docs</span> folder:

<span class='terminal'>(sphinx) docs % make html</span>

### Regenerate output

If you make changes and want to regenerate the output, you should first clean the existing output:

<span class='terminal'>(sphinx) docs % make clean html</span>

followed by

<span class='terminal'>(sphinx) docs % make html</span>

### Publish on GitHub

If you want to publish your documentation on [GitHub](https://github.com), you should have a separate _gh-pages_ repo just for the documentation where you need to add an empty file called <span class='file'>.nojekyll</span> in the root.

<span class='terminal'>% touch .nojekyll</span>

With the file <span class='file'>.nojekyll</span> in the root you can upload (_git push_) the local repo to your online _gh-pages_ GitHub repo.

## Resources

[Sphinx](http://www.sphinx-doc.org/en/master/index.html)

[Documenting Python code with Sphinx](https://towardsdatascience.com/documenting-python-code-with-sphinx-554e1d6c4f6d) by Yash Salvi.

[Auto-Generated Python Documentation with Sphinx](https://www.youtube.com/watch?v=b4iFyrLQQh4) by avcourt.

[Publishing sphinx-generated docs on github](https://daler.github.io/sphinxdoc-test/includeme.html).

[virtual python environment](https://karttur.github.io/geoimagine03-docs-main/prep/prep-conda-environ/)
