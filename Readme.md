# Puppet-EasyBuild

## Summary

Puppet module that installs and configure EasyBuild.

## Implementation details

It installs Easybuild in /opt/apps/EasyBuild
Install environment-modules if non present on Debian. (Require the Jessie repository)
Install Lmod if non present of CentOS. (Require the epel/testing repository)

Configure EasyBuild and environment-module/Lmod to be used "out of the box" (may need to restart your shell).

Currently optimized for bash (may work on other shell, but it is not guaranted).
