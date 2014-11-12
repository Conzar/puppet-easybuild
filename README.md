# Overview EasyBuild repositories

## Overview

This file details the roles of the different repositories involved in the building of a functional EasyBuild environment using Lmod and a specific module naming scheme.

## Various remarks

There a some things that may need to be changed before using these modules in a production environment.

1) Some minor changes need to be adapted to fit the configuration already on the clusters, among else:
  - Name of the user that is used to build the software ('sw' currently, does it fit with the clusters ?)
  - Details of this user (sudoer ? Adapt the puppet file to fit the description of the actual user on the clusters)
  - names of the directories (mostly, currently build EasyBuild in /opt/apps/EasyBuild, which doesn't fit the current organization (HPCBIOS.date))
  
2) On Debian, there seems to be a problem to build GCC-4.7.2 which is used in the most used version of goolf. We should check if it works on the cluster (because it could be a problem coming from some packages from sid that were installed for Lmod, but I am not sure at the moment).

## Modules descriptions

#### [puppet-easybuild](https://github.com/sylmarien/puppet-easybuild)

It is the main module.  
This modules install EasyBuild in /opt/apps/EasyBuild using Lmod (installs it if non present. NB: Assumes that the sid repository is already in sources.list on Debian, maybe we should change that so that it adds it itself (and even deactivate it after)).  
Configure Lmod and EasyBuild with a minimal configuration (using the standard Module Naming Scheme).  
The objective should be to include all the other modules (except maybe puppet-softwareAutoInstall) in this one (as submodules or directly, for those that can be considered "finished"). For that purpose, new class parameters can be created to allow different configurations (e.g: choosing a naming scheme, a installation directory, etc)

#### [easybuild-config](https://github.com/sylmarien/easybuild-config)

This module contains only two files that matter:  
- _easybuild.sh_ wich is the initialization of the environment variables necessary for EasyBuild and Lmod to work properly.  
It is currently placed in the /etc/profile.d directory, but this location is subject to change to fit the inteded behavior on the clusters (so that it is only loaded when launching a job for exemple).  
A good behavior would maybe be to put a copy of it at the root of the EasyBuild installation it has been written for (so that if we want to use an old build, we just load this file)  
This file is not currently sufficient to use EasyBuild with the configuration we want (specifically concerning the Module Naming Scheme). As soon as we are satisfied with the modification done to this file in the puppet-easybuildThematicMNS module, we should include these modifications directly to this file.
- _libc6.preseed_ which is the preseed file to fully automatize the installation of libc6 on Debian.

Both these files should be put in the _files_ directory of the puppet-easybuild module (which should be modified accordingly) as a submodule or directly.

#### [puppet-easybuildThematicMNS](https://github.com/sylmarien/puppet-easybuildThematicMNS)

This module modify the configuration of EasyBuild and Lmod to use the Thematic Module Naming Scheme.  
It is not currently finished. The major thing to be modified is the place where the new naming scheme will be put (and modify the PYTHONPATH accordingly). It is currently put in the home directory (so the home directory of the sw user) which is not a good place (not accessible by all the users, and not sure that this home directory should be in the PYTHONPATH).  
Also, this module still considers that the _easybuild.sh_ file is in /etc/profile.d and should be modified when this will no longer be correct.  
When this module is completely ready, we should include the changes it does to the puppet-easybuild module.

#### [puppet-softwareAutoInstall](https://github.com/sylmarien/puppet-softwareAutoInstall)

This module takes a list of softwares (in a YAML file) and installs it.  
To know where it installs the softwares, you can put a file named _variables.sh_ in the _files_ directory in which you set the environment variables of EasyBuild to fit the installation you want to do.  
If no such file is present in the _files_ directory, the module will try to use the _easybuild.sh_ file located in /etc/profile.d. (When we will have changed the location of the _easybuild.sh_ file as said previously, we would change the location in this module too).  
If neither of these two files is found, the execution will fail.  
Either this module should be included or not in the puppet-easybuild module is open to discussion, since we may not want to install a new EasyBuild environment each time we install a list of softwares (in which case, we should keep these modules seperated).

#### [easybuild-modules](https://github.com/sylmarien/easybuild-modules)

This module contains the python script that implements the automatic installation of a set of software defined in a YAML file, and a example YAML file to show an example of software set definition.  
This module should be included in the previous module as a submodule in the _files_ directory. (Currently, a copy of the files is in the _files_ directory of the puppet-softwareAutoInstall module)
