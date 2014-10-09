# Puppet-EasyBuild

## Summary

Puppet module that installs and configure EasyBuild.

## Implementation details

It installs Easybuild in /opt/apps/EasyBuild
Be aware that it puts /opt in mode 777 !
Install environment-modules if non present.

Configure EasyBuild and environment-module to be used "out of the box" (may need to restart your shell).

Currently optimized for bash (may work on other shell, but it is not guaranted).

