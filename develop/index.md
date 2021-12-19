---
layout: page
title: Develop Karttur's GeoImagine Framework
excerpt: "An archive of articles on how to develop Karttur's GeoImagine Framework."
search_omit: true
---

This post is for programmers who either want to contribute towards improving the GeoImagine Framework, or create there own repo version of the complete Framework.

Karttur's GeoImagine Framework is built in Python using the <span class='app'>Eclipse</span> Integrated Development Environment (IDE) and postreSQL as database. The setup of this integrated Spatial Data IDE (SPIDE) with all its components is covered in the blog [Install and setup SPIDE](https://karttur.github.io/setup-ide/).

This development section of the blog on the [GeoImagine Framework](../) primarily covers how to create a GitHub repository for storing and accessing the complete Framework as a hierarchical set of repositories (repos for short). Each repo contains one package and all packages are attached to the  Framework container as submodules.

Some additional posts deal with particular aspects for the Framework.

<ul class="post-list">
{% for post in site.categories.develop reversed %}
  <li><article><a href="{{ site.url }}{{ post.url }}">{{ post.title }} <span class="entry-date"><time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %d, %Y" }}</time></span>{% if post.excerpt %} <span class="excerpt">{{ post.excerpt | remove: '\[ ... \]' | remove: '\( ... \)' | markdownify | strip_html | strip_newlines | escape_once }}</span>{% endif %}</a></article></li>
{% endfor %}
</ul>
