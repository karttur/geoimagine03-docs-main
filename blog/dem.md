---
layout: page
title: Digital Elevation Models (DEMs)
excerpt: "Working with DEM in Karttur´s GeoImagine Framework."
image: std-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
search_omit: true
---

List of tutorials and examples related to the use of Digital Elevation Models (DEMs) with Karttur's GeoImagine Framework.

### DEM

<ul class="post-list">
{% for post in site.categories.blog reversed %}

  {% if post.datasource == 'dem' %}
    <li><article><a href="{{ site.url }}{{ post.url }}">{{ post.title }} <span class="entry-date"><time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %d, %Y" }}</time></span>{% if post.excerpt %} <span class="excerpt">{{ post.excerpt | remove: '\[ ... \]' | remove: '\( ... \)' | markdownify | strip_html | strip_newlines | escape_once }}</span>{% endif %}</a></article></li>
  {% endif %}

{% endfor %}
</ul>
