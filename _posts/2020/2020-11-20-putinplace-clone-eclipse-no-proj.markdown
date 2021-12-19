---
layout: article
title: Git clone with Eclipse and no project
categories: putinplace
excerpt: Clone Karttur's GeoImagine Framework from GitHub using Eclipse and create the PyDev project by linking
previousurl: null
nexturl: prep/prep-dblink/
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2020-11-20 T08:17:25.000Z'
modified: '2021-10-22 T08:17:25.000Z'
comments: true
share: true
figure1: github-framework_karttur_01_openperspective
figure2: github-framework_karttur_02_select-git-perspective
figure3: github-framework_karttur_03_Git-repo-alternatives
figure301: github-framework_karttur_0301_Git-repo-alternatives
figure4a: github-framework_karttur_04_Source-Git-repo-keychain
figure4: github-framework_karttur_04_Source-Git-repo
figure5: github-framework_karttur_05_Git-branch-select
figure6a: github-framework_karttur_06a_Git-local-dst
figure7a: github-framework_karttur_07_Git-repo-proj-submodules
figure7b: github-framework_karttur_07_Git-repo-proj-workingtree
figure8: github-framework_karttur_08_eclipse-new-proj
figure10: github-framework_karttur_10_eclipse-pydev-proj2
figure11: eclipse-python-interpreter-empty
figure12: eclipse-macos-path-to-pytho-interpreter
figure13: eclipse-select-interpreter
figure14: eclipse-interpreter-selection-needed
figure15: Eclipse-prefrences-interpreter-ready-to-install
figure16: Eclipse-menu-perspective-other
figure17: Eclipse-empty-pydev-perspective
figure22: Eclipse-pydev-proj-geoimagine03
figure121: github-framework_karttur_121_package-explorer

---

## Introduction

This post explains how to clone Karttur's GeoImagine Python project from GitHub.com with <span class='app'>Eclipse</span>. The advantages include that the project is directly linked (imported) to <span class='app'>Eclipse</span> and that you can easily access Framework upgrades from within <span class='app'>Eclipse</span>. To be able to push any updates back to the online (origin) you must have the rights fot the online repo.

The alternatives are to clone or download a complete copy of the Framework using [<span class='app'>GitHub Desktop</span>](../putinplace-clone-desktop-git) or the [Git commandline tool](../putinplace-git-dcommandline) and then either [import the complete Framework](../putinplace-import-project-eclipse) or [build a backbone project and copy selected packages](../putinplace-copy-project-eclipse). The advantage with the latter solutions is that you then separate the cloning and working with the code, and <span class='app'>GitHub Desktop</span> is better than <span class='app'>Eclipse</span> for handling GitHub repositories, and if you prefer the command line, <span class='terminalapp'>git</span> is the natural choice.

The remaining part of this post is similar to the post [Clone PyDev project from GitHub](https://karttur.github.io/setup-ide/setup-ide/install-with-conda-env/) in the blog on [Install and setup SPIDE](https://karttur.github.io/setup-ide/).

## Prerequisits

You can clone Karttur´s GeoImagine Python project as described in here as long as you have <span class='app'>Eclipse</span> installed. To create a fully functional GeoImagine Framework you must also have installed the Spatial Data Integrated Development Environment (SPIDE) as outlined in the blog [Install and setup spatial data IDE](https://karttur.github.io/setup-ide/).

## Add GitHub repo to <span class='app'>Eclipse</span>

There are many online tutorials for cloning GitHub projects into <span class='app'>Eclipse</span>, but I have not found any that deals with cloning a PyDev project. And that is what is outlined in the rest of this post.

### Clone GitHub repository with Eclipse

Start <span class='app'>Eclipse</span>. Once in, click the <span class='icon'>Open Perspective</span> icon and select Git, or start writing "Git" in <span class='textbox'>Quick access</span> textbox.

<figure>
<img src="{{ site.commonurl }}/images/{{ site.data.images[page.figure1].file }}">
<figcaption> {{ site.data.images[page.figure1].caption }} </figcaption>
</figure>

If you get different options for which perspective to select, click the alternative for Git and then <span class='button'>Open</span> it.

<figure>
<img src="{{ site.commonurl }}/images/{{ site.data.images[page.figure2].file }}">
<figcaption> {{ site.data.images[page.figure2].caption }} </figcaption>
</figure>

The view <span class='tab'>Git repositories</span> should open (if not use the <span class='textbox'>Quick access</span> textbox and type Git, then select <span class='menu'>View --> Git repositories</span>). In the <span class='tab'>Git repositories</span> view you should click the alternative _Clone a Git repository_ (if no text appears slide the cursor over the icons to get the alternative _Clone a Git repository and add the clone to this view_).

<figure>
<img src="{{ site.commonurl }}/images/{{ site.data.images[page.figure3].file }}">
<figcaption> {{ site.data.images[page.figure3].caption }} </figcaption>
</figure>

<figure>
<img src="{{ site.commonurl }}/images/{{ site.data.images[page.figure301].file }}">
<figcaption> {{ site.data.images[page.figure301].caption }} </figcaption>
</figure>

You might be asked for Authentication to give the credentials for the selected online repo (depends on the version of <span class='app'>Eclipse</span>) before the dialogue window is accessible. You can always enter the Authentication directly in the window.

<figure>
<img src="{{ site.commonurl }}/images/{{ site.data.images[page.figure4a].file }}">
<figcaption> {{ site.data.images[page.figure4a].caption }} </figcaption>
</figure>

In the dialogue window for <span class='tab'>Source Git Repository</span>, fill in the url to the repository (you can copy the path from your GitHub.com account).

<figure>
<img src="{{ site.commonurl }}/images/{{ site.data.images[page.figure4].file }}">
<figcaption> {{ site.data.images[page.figure4].caption }} </figcaption>
</figure>

Click the <span class='button'>Next ></span> button. This will take you to the <span class='tab'>Branch Selection window</span>. Make sure _main_ is selected and again click <span class='button'>Next ></span>.

<figure>
<img src="{{ site.commonurl }}/images/{{ site.data.images[page.figure5].file }}">
<figcaption> {{ site.data.images[page.figure5].caption }} </figcaption>
</figure>

Click <span class='button'>Next ></span> to continue.

The next view is for <span class='tab'>Local Destination</span>. **Do not** accept the default path (e.g. /localuser/git) as this interferes with <span class='terminalapp'>git</span> itself. I use the solution of a <span class='file'>git</span> sibling directory to the <span class='app'>Eclipse</span> Working directory. I use a hierarchical system of working directories, with one directory linked to one version of <span class='app'>Eclipse</span>. Also tick the checkbox for <span class='checkbox'>Clone submodules</span>.

<figure>
<img src="{{ site.commonurl }}/images/{{ site.data.images[page.figure6a].file }}">
<figcaption> {{ site.data.images[page.figure6a].caption }} </figcaption>
</figure>



When ready, click <span class='button'>Finish</span> and the GitHub remote repository should be cloned to your local machine. If it worked properly you should see the cloned repository in the <span class='tab'>Git Repositories</span> view.

<figure>
<img src="{{ site.commonurl }}/images/{{ site.data.images[page.figure7a].file }}">
<figcaption> {{ site.data.images[page.figure7a].caption }} </figcaption>
</figure>

<figure>
<img src="{{ site.commonurl }}/images/{{ site.data.images[page.figure7b].file }}">
<figcaption> {{ site.data.images[page.figure7b].caption }} </figcaption>
</figure>

### Python interpreter

Before you can start working with the GeoImagine Framework you need to set the Python interpreter to use. From the main menu of <span class='app'>Eclipse</span> go to:

<span class='menu'>Eclipse --> Preferences... --> PyDev --> Interpreters --> Python Interpreter</span>

<figure>
<img src="{{ site.commonurl }}/images/{{ site.data.images[page.figure11].file }}">
<figcaption> {{ site.data.images[page.figure11].caption }} </figcaption>
</figure>

Click on the <span class='button'>New</span> button towards the upper right corner in the Preferences window. Select the option _Browse for python/pypy exe_ (shown above). If you have followed the blog on [Install and setup SPIDE](https://karttur.github.io/setup-ide/) you should have a virtual Python environment setup under [<span class='app'>Anaconda</span>](https://karttur.github.io/setup-ide/setup-ide/install-anaconda/) that you installed as part of the blog on [Install and setup SPIDE](https://karttur.github.io/setup-ide/). This virtual environment is the Python Interpreter that you are looking for.

By default the virtual environments created by <span class='terminalapp'>conda</span> are stored under the subdirectory <span class='file'>envs</span> under the <span class='file'>AnacondaX</span> main directory. The <span class='file'>python.exe</span> file you need is then under the folder <span class='file'>bin</span> inside the particular virtual environment you want to load.

<figure>
<img src="{{ site.commonurl }}/images/{{ site.data.images[page.figure12].file }}">
<figcaption> {{ site.data.images[page.figure12].caption }} </figcaption>
</figure>

When you have found the interpreter you are looking for, fill in a name, and click <span class='button'>OK</span>.

<figure>
<img src="{{ site.commonurl }}/images/{{ site.data.images[page.figure13].file }}">
<figcaption> {{ site.data.images[page.figure13].caption }} </figcaption>
</figure>

In the next dialogue window, _Selection needed_, make sure all options are selected and click <span class='button'>OK</span>.

<figure>
<img src="{{ site.commonurl }}/images/{{ site.data.images[page.figure14].file }}">
<figcaption> {{ site.data.images[page.figure14].caption }} </figcaption>
</figure>

When you get back to the _Preferences_ window, click <span class='button'>Apply and Close</span> button to finish setting up the Python interpreter.

<figure>
<img src="{{ site.commonurl }}/images/{{ site.data.images[page.figure15].file }}">
<figcaption> {{ site.data.images[page.figure15].caption }} </figcaption>
</figure>

### Create a new PyDev project

You should now have a local clone of the remote GitHub repository with the local clone also added to <span class='app'>Eclipse</span>. The next step is to create a PyDev project in <span class='app'>Eclipse</span> and team it to the cloned GitHub repository.

Shift to the PyDev perspective, for example via the main menu:

<span class='menu'>Window --> Perspective --> Open perspective --> Other</span>

<figure>
<img src="{{ site.commonurl }}/images/{{ site.data.images[page.figure16].file }}">
<figcaption> {{ site.data.images[page.figure16].caption }} </figcaption>
</figure>

and then select PyDev in the window that opens.

Unless you did not already have another PyDev project in the <span class='app'>Eclipse</span> workspace, the PyDev perspective is empty (below).

<figure>
<img src="{{ site.commonurl }}/images/{{ site.data.images[page.figure17].file }}">
<figcaption> {{ site.data.images[page.figure17].caption }} </figcaption>
</figure>

To create a new project in <span class='app'>Eclipse</span>, either use the main menu:

<span class='menu'>File --> New --> Project --> PyDev --> PyDev project</span>,

or right click in <span class='tab'>Package Explorer</span> (navigation) window, and select the same sequence but starting with _New_. In either case you will end up with the <span class='window'>Select a wizard</span> window where _PyDev project_ should be an alternative. If you do not get the _PyDev project_ alternative it is most likely because you did not install <span class='app'>Eclipse</span> with PyDev support as outlined in the post on [Setup Eclipse for PyDev](https://karttur.github.io/setup-ide/setup-ide/install-eclipse/).

<figure>
<img src="{{ site.commonurl }}/images/{{ site.data.images[page.figure8].file }}">
<figcaption> {{ site.data.images[page.figure8].caption }} </figcaption>
</figure>

<figure>
<img src="{{ site.commonurl }}/images/{{ site.data.images[page.figure22].file }}">
<figcaption> {{ site.data.images[page.figure22].caption }} </figcaption>
</figure>

In the <span class='tab'>PyDev Project</span> window you only have to fill in the <span class='textbox'>Project name</span>. You can leave all other entries with the default values, setting a <span class='textbox'>Working set</span> is optional. Click <span class='button'>Finish</span> to create the PyDev project.

<figure>
<img src="{{ site.commonurl }}/images/{{ site.data.images[page.figure10].file }}">
<figcaption> {{ site.data.images[page.figure10].caption }} </figcaption>
</figure>

### Link GitHub repository and Eclipse project

You should now have an added (cloned) GitHub repository as well as an empty PyDev project in <span class='app'>Eclipse</span>. It is time to link the the empty PyDev project to the cloned GitHub project.

Select (click on) the newly created PyDev project in the <span class='tab'>Package Explorer</span> (navigation) window in <span class='app'>Eclipse</span>, then right click and in the pop-out menu that sequentially appears select:

<span class='menu'>Team --> Share Project...</span>

<figure>
<img src="{{ site.commonurl }}/images/{{ site.data.images[page.figure11].file }}">
<figcaption> {{ site.data.images[page.figure11].caption }} </figcaption>
</figure>

In the window <span class='tab'>Configure Git Repository</span> that opens, you should see a <span class='textbox'>Repository</span>. If not, make sure the checkbox <span class='checkbox'>Use or create repository in parent folder of project</span> is **un-checked**.

<figure>
<img src="{{ site.commonurl }}/images/{{ site.data.images[page.figure12].file }}">
<figcaption> {{ site.data.images[page.figure12].caption }} </figcaption>
</figure>

In the textbox <span class='textbox'>Repository</span> select the repository that you just cloned. Also make sure that the target project is selected. click <span class='button'>Finish</span>.

In the <span class='app'>Eclipse</span> <span class='tab'>Package Explorer</span> (navigation) window, your PyDev project should now be indicated as linked (or piped ">") to the [repository branch] (e.g. [kt-gi-test01 master]).

<figure>
<img src="{{ site.commonurl }}/images/{{ site.data.images[page.figure121].file }}">
<figcaption> {{ site.data.images[page.figure121].caption }} </figcaption>
</figure>
