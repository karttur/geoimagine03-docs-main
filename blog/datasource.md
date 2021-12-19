---
layout: page
title: Data source tutorials
excerpt: "An archive of tutorials for Karttur's GeoImagine Framework."
image: std-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
search_omit: true
---

This blog lists tutorials and examples related to different kinds of data sources. If you are looking for producing specific thematic indexes for biophysical properties or want to see a list of all available tutorials, try one of these content lists instead:

[Content listed after derived biophysical properties](../biophysical)

[List of all available tuturials](../index)

### DEM

<ul class="post-list">

{% for post in site.categories.blog %}

  {% if post.datasource == 'dem' %}

    <li><article><a href="{{ site.url }}{{ post.url }}">{{ post.title }} <span class="entry-date"><time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %d, %Y" }}</time></span>{% if post.excerpt %} <span class="excerpt">{{ post.excerpt | remove: '\[ ... \]' | remove: '\( ... \)' | markdownify | strip_html | strip_newlines | escape_once }}</span>{% endif %}</a></article></li>

  {% endif %}

{% endfor %}

</ul>

### GRACE

<ul class="post-list">
{% for post in site.datasource.grace %}
  <li><article><a href="{{ site.url }}{{ post.url }}">{{ post.title }} <span class="entry-date"><time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %d, %Y" }}</time></span>{% if post.excerpt %} <span class="excerpt">{{ post.excerpt | remove: '\[ ... \]' | remove: '\( ... \)' | markdownify | strip_html | strip_newlines | escape_once }}</span>{% endif %}</a></article></li>
{% endfor %}
</ul>
