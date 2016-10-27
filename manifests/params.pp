# File::      <tt>params.pp</tt>
# Author::    M. Schmitt (maxime.schmitt@ext.uni.lu)
# Copyright:: Copyright (c) 2014 M. Schmitt
# License::   Gpl-3.0
#
# ------------------------------------------------------------------------------
# = Class: easybuild::params
#
# In this class are defined as variables values that are used in other
# easybuild classes.
# This class should be included, where necessary, and eventually be enhanced
# with support for more OS
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# The usage of a dedicated param classe is advised to better deal with
# parametrized classes, see
# http://docs.puppetlabs.com/guides/parameterized_classes.html
#
# [Remember: No empty lines between comments and class definition]
#
class easybuild::params {

  ######## DEFAULTS FOR VARIABLES USERS CAN SET ##########################
  # (Here are set the defaults, provide your custom variables externally)
  # (The default used is in the line with '')
  ###########################################

  # ensure the presence (or absence) of easybuild
  $ensure = $easybuild_ensure ? {
    ''      => 'present',
    default => $easybuild_ensure
  }

  # Path for the commands
  $path = $::osfamily ? {
    'redhat' => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/',
    '/usr/share/lmod/lmod/libexec/'
    ],
    'debian' => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/',
    '/usr/share/lmod/lmod/libexec/'
    ],
  }

  # Branch of the git repository to pull for the configuration file
  $branch = $::osfamily ? {
    'redhat' => 'master',
    'debian' => 'master',
  }

  # File to source (depend on the module command used)
  $moduleSource = $::osfamily ? {
    'redhat' => '/usr/share/lmod/lmod/init/profile',
    'debian' => '/usr/share/lmod/lmod/init/profile',
  }

  # Package that provide the module command
  $modulePackage = $::osfamily ? {
    'redhat' => 'Lmod',
    'debian' => 'lmod',
  }

  $installOptions = $::osfamily ? {
    'redhat' => '--enablerepo=epel-testing',
    #'debian' => [ '-t', 'sid' ],
    'debian' => [ ],
  }

  # OS Specific Requirements
  case $::osfamily {
    'redhat': {
      $required_packages = []
    }
    'debian': {
      $required_packages = ['tcl-dev','git']
    }
    default: {
      fail("Unsupported OS ${::osfamily}.  Please use a debian or \
redhat based system")
    }
  }
}