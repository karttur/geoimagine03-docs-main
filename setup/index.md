---
layout: page
title: Karttur's GeoImagine Framework - Setup
excerpt: "Guides for setting up Karttur's GeoImagine Framework in MacOS"
search_omit: true
---

The posts collected below will take you, step by step, through the setup of Karttur's GeoImagine Framework.

<ul class="post-list">
{% for post in site.categories.setup reversed %}
  <li><article><a href="{{ site.url }}{{ post.url }}">{{ post.title }} <span class="entry-date"><time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %d, %Y" }}</time></span>{% if post.excerpt %} <span class="excerpt">{{ post.excerpt | remove: '\[ ... \]' | remove: '\( ... \)' | markdownify | strip_html | strip_newlines | escape_once }}</span>{% endif %}</a></article></li>
{% endfor %}
</ul>
