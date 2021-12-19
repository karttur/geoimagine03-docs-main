---
layout: article
title: Update submodules
categories: develop
tutorial: null
excerpt: "Update submodules belonging to git suer-project repo."
previousurl: null
nexturl: null
tags:
  - git
  - submodules
  - update
  - python
  - script
image: avg-trmm-3b43v7-precip_3B43_trmm_2001-2016_A
date: '2021-01-04 T18:17:25.000Z'
modified: '2021-11-01 T18:17:25.000Z'
comments: true
share: true
---
<script src="https://karttur.github.io/common/assets/js/karttur/togglediv.js"></script>

## Introduction

This post describes how to update submodules of a PyDev project composed of a super-project and several submodules. Specifically is deals with updating python packages in an <span class='app'>Eclipse</span> project. If you have used <span class='app'>Eclipse</span> itself for the got processing, some older isntructions are available in the post [Setup Eclipse teamed with GitHub repository](https://karttur.github.io/geoimagine/develop/develop-github-eclipse/).

This manual is for Frameworks where the clone and the development work are separate. I.e. where the <span class='app'>Eclipse</span> project is done on a copy or imported version of the cloned super-project.

## Updating submodules - the complete circle

If your work with the Framework development has been done using a copy detached from the local clone of your online (e.g. GitHub) repo of the Framework, this post describes how to

1. update your original repos
2. stage the updates to the respective submodule repos
3. Update the super-project repo, and
4. Pull the new super-project framework

When all 4 steps are completed you will have three exact copies of the project on your local machine:

- original repo,
- clone of the online repos, and
- PyDev project in the <span class='app'>Eclipse</span> workspace

### 1 Update your original submodule repos

If you have access to original repos that compose the submodules, follow the steps outlined in the post [Add, commit and push submodules](../develop-commit-push-submodules/). The python module (script) updates the original local repos, and also produces a shell script file. the shell script file will <span class='terminalapp'>add</span>, <span class='terminalapp'>commit</span> and <span class='terminalapp'>push</span> all the changes to the online repo.

### 2 stage the updates to the respective submodule repos

This is acheived by simply running the shell script file produced from the first step.

### 3 Update the super-project repo

I DO NOT KNOW HOW TO DO THIS

git submodule update --remote

git submodule update --remote --recursive

git submodule update --init --recursive

git submodule foreach git pull origin master

git submodule update --remote --merge
