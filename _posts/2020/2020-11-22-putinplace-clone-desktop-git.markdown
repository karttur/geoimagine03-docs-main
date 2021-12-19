---
layout: article
title: Git clone with GitHub Desktop or terminal
categories: putinplace
excerpt: Clone Karttur's GeoImagine Framework from GitHub using GitHub Desktop or git terminal commands
previousurl: prep/prep-conda-environ
nexturl: null
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2020-11-22 T08:17:25.000Z'
modified: '2020-11-22 T08:17:25.000Z'
comments: true
share: true
figure1: github-karttur-framework03_karttur
figure2: github-karttur-framework03_clone-to-desktop
figure4: github-framework_karttur_104_clone-repo-desktop
figure5: github-framework_karttur_105_clone-a-repo-desktop
---

## Introduction

As you (most likely) do not have the right to edit, manage and update Karttur´s GitHub repositories and it's GeoImagine Framework packages, you can not make use of <span class='app'>Eclipse</span> ability to stage, commit and push changes (unless you fork the original GeoImagine project to your own git online repo). It is instead recommended that you clone GeoImagine Framework using <span class='terminalapp'>git</span> command line or <span class='app'>GitHub Desktop</span> to a stand alone clone outside of <span class='app'>Eclipse</span>. And then transfer the Framework project to the development environment you prefer. How to [import](../putinplace-import-project-eclipse) or [copy](../putinplace-copy-project-eclipse) to <span class='app'>Eclipse</span>) are covered in separate blog posts.

### Cloning

The cloning done in this post (using <span class='app'>GitHub Deskop</span> or the command line tool <span class='terminalapp'>git</span>) resembles using <span class='app'>Eclipse</span> as in the post on [Git clone with Eclipse](../putinplace-clone-eclipse-no-proj). In general <span class='app'>GitHub Deskop</span> is a superior app for Git management compared to Eclipse. And if you prefer to run Git from the commandline, then there is <span class='terminalapp'>git</span>).

## Prerequisits

For cloning Karttur's GeoImagine Framework from [GitHub.com](https://github.com) all you need is an app that can clone the GitHub super-repo linking together all the packages that build the GeoImagine Framework. The alternatives are [<span class='app'>GitHub Desktop</span>](https://desktop.github.com) if you prefer a GUI, or the [<span class='terminalapp'>git</span> commandline tool](https://karttur.github.io/git-vcs/).

## Karttur's GitHub repository

Go to [GitHub.com](https://github.com) and to Karttur's repository containing the [complete GeoImagine Framework (geoimagine03frame)](https://github.com/karttur/geoimagine03frame). This repository is more or less an empty shell with all the GeoImagine Framework packages linked as submodules. The top level of the repository is composed of 4 files; the standard <span class='file'>README.md</span> and <span class='file'>LICENCE</span> files, a shell script <span class='file'>addsubmodules.sh</span> and then the <span class='terminalapp'>git</span> file <span class='file'>.gitmodules</span>. The last file defines all the linked submodules that you see as blue sub-directories.

<figure>
<img src="{{ site.commonurl }}/images/{{ site.data.images[page.figure1].file }}">
<figcaption> {{ site.data.images[page.figure1].caption }} </figcaption>
</figure>

### Clone the GeoImagine Framework project

This tutorial covers three routes for retrieving Karttur's complete GeoImagine Framework to your local machine:

1. Clone by linking to <span class='app'>GitHub Desktop</span> for online repo,
2. Clone directly from <span class='app'>GitHub Desktop</span>, and
3. Clone using the <span class='terminalapp'>git</span> command line tool

#### Download from online repository does not work

In your web-browser, return to the top of Karttur's assembled Framework project [https://github.com/karttur/geoimagine03frame](https://github.com/karttur/geoimagine03frame). If you click "Download ZIP", you will get a download but with **empty** submodules and this will **not** work.

#### Clone via GitHub repo using <span class='app'>GitHub Desktop</span>

In the web-browser with the [Framework superproject](https://github.com/karttur/geoimagine03frame), click the <span class='button'>Clone or Download</span> button and then click the <span class='button'>Open in Desktop</span> button.

<figure>
<img src="{{ site.commonurl }}/images/{{ site.data.images[page.figure2].file }}">
<figcaption> {{ site.data.images[page.figure2].caption }} </figcaption>
</figure>

#### Clone directly from <span class='app'>GitHub Desktop</span>

Instead of linking to <span class='app'>GitHub Desktop</span> from the online GitHub repository, you can start your copy of <span class='app'>GitHub Desktop</span> and go via the menu:

<span class='menu'>File --> Clone Repository...</span>

<figure>
<img src="{{ site.commonurl }}/images/{{ site.data.images[page.figure4].file }}">
<figcaption> {{ site.data.images[page.figure4].caption }} </figcaption>
</figure>

In the window <span class='tab'>Clone a Repository</span> that opens, fill in the <span class='textbox'>Repository URL</span> and the <span class='textbox'>Local Path</span>. When complete, press <span class='button'>Clone</span>.

<figure>
<img src="{{ site.commonurl }}/images/{{ site.data.images[page.figure5].file }}">
<figcaption> {{ site.data.images[page.figure5].caption }} </figcaption>
</figure>

#### Clone using Git command line tools

Start a <span class='app'>Terminal</span> session. Change directory <span class='terminal'>cd</span> to the parent directory where you want to save the GitHub project (repository):

<span class='terminal'>$ cd /Users/"youruser"/eclipse/git</span>

If you accept that the repo you are going to clone will have the same local name as online (recommended), execute the command:

<span class='terminal'>$ git clone https://github.com/karttur/geoimagine03frame.git</span>

If you want the local clone to have another name, instead use:

<span class='terminal'>$ git clone https://github.com/karttur/geoimagine03frame.git ["alt name"]</span>

To speed up the cloning of multiple submodules (up to 8 parallel downloads) and get all the linked submodule repositories cloned (version 2.13 and later):

<span class='terminal'>$ git clone --recurse-submodules -j8 https://github.com/karttur/geoimagine03frame.git [karttur-geoimagine-03]</span>


Check that the cloned repo actually contain all the GeoImagine Framework python modules (<span class='file'>.py</span> files). if not, <span class='terminal'>cd</span> to the top directory (geoimagine03frame or karttur-geoimagine-02). Then execute the following commands for initiating and then updating all the the submodule linked repositories.

<span class='terminal'>$ git submodule init</span>

<span class='terminal'>$ git submodule update</span>

#### Update submodules

To update all submodules to latest individual _commit_ of each, run the command:

<span class='terminal'>$ git submodule foreach git pull origin main</span>

### import or copy project to <span class='app'>Eclipse</span>

Regardless of which route you chose for cloning the GitHub super-repo containing the GeoImagine PyDev packages, you should now have a complete clone in your local machine. The next step is to either [import](../putinplace-import-project-eclipse) or [copy](../putinplace-copy-project-eclipse) the Framework project to <span class='app'>Eclipse</span>.
