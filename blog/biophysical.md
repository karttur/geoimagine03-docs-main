---
layout: page
title: Biophysical index tutorials
excerpt: "An archive of tutorials for Karttur's GeoImagine Framework."
image: std-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
search_omit: true
---

This blog lists tutorials and examples related to the kind of biophysical products you can derive. If you are looking for processing a particular data source or want to see a list of all available tutorials, try one of these content lists instead:

[Content listed after data source](../datasource)

[List of all available tutorials](../index)

### Soil water content

<ul class="post-list">
{% for post in site.categories.blog %}

  {% if post.biophysical == 'soilwater' %}
    <li><article><a href="{{ site.url }}{{ post.url }}">{{ post.title }} <span class="entry-date"><time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %d, %Y" }}</time></span>{% if post.excerpt %} <span class="excerpt">{{ post.excerpt | remove: '\[ ... \]' | remove: '\( ... \)' | markdownify | strip_html | strip_newlines | escape_once }}</span>{% endif %}</a></article></li>
  {% endif %}

{% endfor %}
</ul>
