---
layout: page
title: Karttur's GeoImagine Framework - Concept
excerpt: "An archive of articles on the concept of Karttur's GeoImagine Framework."
search_omit: true
---

The core of the Framework are object oriented processes. The processes are assembled in groups (called roots), where each group is associated with either a particular data source (e.g. MODIS, Sentinel, Landsat, ancillary etc), or particular kinds of processes (e.g. time series processing, scalar, overlay, export etc). Many root processes are also associated with a specific, purpose-built, python package.

The posts below explain the basic concepts of the Framework and how that translates into actual running the processes.

<ul class="post-list">
{% for post in site.categories.concept reversed %}
  <li><article><a href="{{ site.url }}{{ post.url }}">{{ post.title }} <span class="entry-date"><time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %d, %Y" }}</time></span>{% if post.excerpt %} <span class="excerpt">{{ post.excerpt | remove: '\[ ... \]' | remove: '\( ... \)' | markdownify | strip_html | strip_newlines | escape_once }}</span>{% endif %}</a></article></li>
{% endfor %}
</ul>
