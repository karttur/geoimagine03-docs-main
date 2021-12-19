---
layout: page
title: Tutorials
excerpt: "An archive of tutorials for Karttur's GeoImagine Framework."
image: std-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
search_omit: true
---

This blog contains various tutorials and examples on how to use Karttur´s GeoImagine Framework and what kind of spatial data and indexes you can derive from the Framework. This page lists all the tutorials available without any particular order. If you are looking for processing a particular data source or want to calculate a specific biophysical property, try one of these links listing thematic content instead:

[Content listed after data source](datasource)

[Content listed after derived biophysical properties](biophysical)

### List of all tutorials

<ul class="post-list">
{% for post in site.categories.blog reversed %}
  <li><article><a href="{{ site.url }}{{ post.url }}">{{ post.title }} <span class="entry-date"><time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %d, %Y" }}</time></span>{% if post.excerpt %} <span class="excerpt">{{ post.excerpt | remove: '\[ ... \]' | remove: '\( ... \)' | markdownify | strip_html | strip_newlines | escape_once }}</span>{% endif %}</a></article></li>
{% endfor %}
</ul>
