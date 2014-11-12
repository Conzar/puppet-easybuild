# Overview EasyBuild repositories

## Overview

This file details the roles of the different repositories involved in the building of a functional EasyBuild environment using Lmod and a specific module naming scheme.

## Various remarks

There a some things that may need to be changed before using these modules in a production environment.

1) Some minor changes need to be adapted to fit the configuration already on the clusters, among else:
  - Name of the user that is used to build the software ('sw' currently, does it fit with the clusters ?)
  - Details of this user (sudoer ? Adapt the puppet file to fit the description of the actual user on the clusters)
  - names of the directories (mostly, currently build EasyBuild in /opt/apps/EasyBuild, which doesn't fit the current organization (HPCBIOS.date))

## Modules descriptions

#### [puppet-easybuild](https://github.com/sylmarien/puppet-easybuild)

It is the main module.  
This modules install EasyBuild in /opt/apps/EasyBuild using Lmod (installs it if non present. NB: Assumes that the sid repository is already in sources.list on Debian, maybe we should change that so that it adds it itself (and even deactivate it after)).  
Configure Lmod and EasyBuild with a minimal configuration (using the standard Module Naming Scheme).  
The objective should be to include all the other modules in this one (as submodules or directly, for those that can be considered "finished").  
