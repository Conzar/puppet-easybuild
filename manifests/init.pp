# File::      <tt>init.pp</tt>
# Author::    M. Schmitt (maxime.schmitt@ext.uni.lu)
# Copyright:: Copyright (c) 2014 M. Schmitt
# License::   Gpl-3.0
#
# ------------------------------------------------------------------------------
# = Class: easybuild
#
# rtfm
#
# == Parameters:
#
# $ensure:: *Default*: 'present'. Ensure the presence (or absence) of easybuild
#
# == Actions:
#
# Install and configure easybuild
#
# == Requires:
#
# n/a
#
# == Sample Usage:
#
#     import easybuild
#
# You can then specialize the various aspects of the configuration,
# for instance:
#
#         class { 'easybuild':
#             ensure => 'present'
#         }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
#
# [Remember: No empty lines between comments and class definition]
#
class easybuild(
  $ensure            = $easybuild::params::ensure,
  $softwares         = $easybuild::params::softwares,
  $branch            = 'core',
  $easybuild_version = ''
)
inherits easybuild::params {
  anchor{'easybuild::begin':}
  info ("Configuring easybuild (with ensure = ${ensure})")

  if !($ensure in [ 'present', 'absent' ]) {
    fail(
  "easybuild 'ensure' parameter must be set to either 'absent' or 'present'")
  }

  class{'easybuild::install':
    require => Anchor['easybuild::begin'],
  }
  class{'easybuild::config':
    require => Class['easybuild::install'],
  }

  anchor{'easybuild::end':
    require => Class['easybuild::config'],
  }
}