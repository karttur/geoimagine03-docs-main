---
layout: page
title: Data access
excerpt: "An archive of tutorials for accessing data for Karttur's GeoImagine Framework."
image: std-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
search_omit: true
---

This blog covers how to access data from and for Karttur´s GeoImagine Framework.

### List of all tutorials

<ul class="post-list">
{% for post in site.categories.access %}
  <li><article><a href="{{ site.url }}{{ post.url }}">{{ post.title }} <span class="entry-date"><time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %d, %Y" }}</time></span>{% if post.excerpt %} <span class="excerpt">{{ post.excerpt | remove: '\[ ... \]' | remove: '\( ... \)' | markdownify | strip_html | strip_newlines | escape_once }}</span>{% endif %}</a></article></li>
{% endfor %}
</ul>
