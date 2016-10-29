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

  # OS Specific Requirements
  case $::osfamily {
    'redhat': {
      $required_packages = []
      $path              = [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/',
        '/usr/share/lmod/lmod/libexec/'
      ]
      # Package that provide the module command
      $module_package     = 'Lmod'
      $install_options    = '--enablerepo=epel-testing'
      $py_yaml            = 'PyYAML'
    }
    'debian': {
      $required_packages = ['tcl-dev','git']
      $path              = [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/',
        '/usr/share/lmod/lmod/libexec/']
      $module_package     = 'lmod'
      $install_options    = []
      #$install_options   = [ '-t', 'sid' ]
      $py_yaml            = 'python-yaml'
    }
    default: {
      fail("Unsupported OS ${::osfamily}.  Please use a debian or \
redhat based system")
    }
  }

  # ensure the presence (or absence) of easybuild
  $ensure = present

  # Branch of the git repository to pull for the configuration file
  $branch = 'master'

  # File to source (depend on the module command used)
  $module_source = '/usr/share/lmod/lmod/init/profile'

  # The Protocol used. Used by monitor and firewall class. Default is 'tcp'
  $protocl = 'tcp'

  # The port number. Used by monitor and firewall class. The default is 22.
  $port = '22'

  # example of an array variable
  $array_variable = []

  $packagename    = 'easybuild'

  $install_dir = '/opt/easybuild'
  $python_path = '/usr/bin/python'
  $softwares   = {
    'core'         => ['GCC-4.8.1.eb', 'GCC-4.9.1.eb'],
    'experimental' => ['GCC-4.8.2.eb'],
  }

  $config_repo = 'https://github.com/sylmarien/easybuild-config.git'

}