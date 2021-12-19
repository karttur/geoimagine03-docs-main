---
layout: post
title: Karttur's GeoImagine Framework
excerpt: "Introduction to Karttur's GeoImagine Framework"
image: rainfall-delta_3B43_trmm_2001-2016_mk-z-ts-model
search_omit: true
---

Karttur's GeoImagine Framework offers a semi-automated processing environment for spatial data, mainly intended for Big Data processing of satellite images and other spatial datasets. To work with the Framework your machine must first be set up with a Spatial Data Integrated Development Environment (SPIDE) as described in my blog on [Install and setup spatial data IDE](https://karttur.github.io/setup-ide/).

At the core of the Framework are object oriented processes. These processes are assembled in groups (called roots), where each group is associated with either a particular data source (e.g. MODIS, Sentinel, Landsat, ancillary etc), or a particular kind of process (e.g. time series processing, scalar, overlay, export etc). Many root processes are also associated with a specific, purpose-built, Python package. 

To search for a particular package or process, use these links to browse the content of Karttur's GeoImagine Framework:

- [Python packages](packages/index.html)
- [Root processes](rootprocesses/index.html)
- [Sub processes](subprocesses/index.html)

<h1>Preparations</h1>

If you intend to setup a clone, or your own version, of Karttur's GeoImagine Framework you first need to create a Python environment. It is strongly recommended that you do that as a [Conda virtual environment](../prep/prep-conda-environ/).

The second step is to [Get Karttur's GeoImagine Framework into Eclipse](../putinplace), where [<span class='app'>Eclipse</span> (for PyDev)](https://karttur.github.io/setup-ide/setup-ide/install-eclipse) is also part of the SPIDE installation.

Then you also have to [prepare the database connections](../prep/prep-dblink) for the PostgreSQL database installed as part of the SPIDE. Before actually running any of the processes it will help if you get acquainted with the [conceptual backbone](../concept). After that you can follow the step-by-step posts in the  [setup](../setup/) section.

The [blog](../blog/) contains various examples processing different kinds of data in the Framework. Under [Develop](../develop/) you find instructions for how to setup your own version of the Framework.

<h2>Python environment and database connection<h2>
<ul class="post-list">
{% for post in site.categories.prep reversed %}
  <li><article><a href="{{ site.url }}{{ post.url }}">{{ post.title }} <span class="entry-date"><time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %d, %Y" }}</time></span>{% if post.excerpt %} <span class="excerpt">{{ post.excerpt | remove: '\[ ... \]' | remove: '\( ... \)' | markdownify | strip_html | strip_newlines | escape_once }}</span>{% endif %}</a></article></li>
{% endfor %}
</ul>

<h2>Get Framework<h2>
<ul class="post-list">
{% for post in site.categories.putinplace reversed %}
  <li><article><a href="{{ site.url }}{{ post.url }}">{{ post.title }} <span class="entry-date"><time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %d, %Y" }}</time></span>{% if post.excerpt %} <span class="excerpt">{{ post.excerpt | remove: '\[ ... \]' | remove: '\( ... \)' | markdownify | strip_html | strip_newlines | escape_once }}</span>{% endif %}</a></article></li>
{% endfor %}
</ul>

<h2>Concept<h2>
<ul class="post-list">
{% for post in site.categories.concept reversed %}
  <li><article><a href="{{ site.url }}{{ post.url }}">{{ post.title }} <span class="entry-date"><time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %d, %Y" }}</time></span>{% if post.excerpt %} <span class="excerpt">{{ post.excerpt | remove: '\[ ... \]' | remove: '\( ... \)' | markdownify | strip_html | strip_newlines | escape_once }}</span>{% endif %}</a></article></li>
{% endfor %}
</ul>

<h2>Setup<h2>
<ul class="post-list">
{% for post in site.categories.setup reversed %}
  <li><article><a href="{{ site.url }}{{ post.url }}">{{ post.title }} <span class="entry-date"><time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %d, %Y" }}</time></span>{% if post.excerpt %} <span class="excerpt">{{ post.excerpt | remove: '\[ ... \]' | remove: '\( ... \)' | markdownify | strip_html | strip_newlines | escape_once }}</span>{% endif %}</a></article></li>
{% endfor %}
</ul>

<h2>Blog<h2>
<ul class="post-list">
{% for post in site.categories.blog limit:5 %}
  <li><article><a href="{{ site.url }}{{ post.url }}">{{ post.title }} <span class="entry-date"><time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %d, %Y" }}</time></span>{% if post.excerpt %} <span class="excerpt">{{ post.excerpt | remove: '\[ ... \]' | remove: '\( ... \)' | markdownify | strip_html | strip_newlines | escape_once }}</span>{% endif %}</a></article></li>
{% endfor %}
</ul>

<h2>Develop<h2>
<ul class="post-list">
{% for post in site.categories.develop reversed %}
  <li><article><a href="{{ site.url }}{{ post.url }}">{{ post.title }} <span class="entry-date"><time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %d, %Y" }}</time></span>{% if post.excerpt %} <span class="excerpt">{{ post.excerpt | remove: '\[ ... \]' | remove: '\( ... \)' | markdownify | strip_html | strip_newlines | escape_once }}</span>{% endif %}</a></article></li>
{% endfor %}
</ul>

<h2>Depreciated<h2>
<ul class="post-list">
{% for post in site.categories.depreciated %}
  <li><article><a href="{{ site.url }}{{ post.url }}">{{ post.title }} <span class="entry-date"><time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %d, %Y" }}</time></span>{% if post.excerpt %} <span class="excerpt">{{ post.excerpt | remove: '\[ ... \]' | remove: '\( ... \)' | markdownify | strip_html | strip_newlines | escape_once }}</span>{% endif %}</a></article></li>
{% endfor %}
</ul>
