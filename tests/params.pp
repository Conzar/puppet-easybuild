# File::      <tt>params.pp</tt>
# Author::    M. Schmitt (maxime.schmitt@ext.uni.lu)
# Copyright:: Copyright (c) 2014 M. Schmitt
# License::   Gpl-3.0
#
# ------------------------------------------------------------------------------
# You need the 'future' parser to be able to execute this manifest (that's
# required for the each loop below).
#
# Thus execute this manifest in your vagrant box as follows:
#
#      sudo puppet apply -t --parser future /vagrant/tests/params.pp
#
#

include 'easybuild::params'

$names = [
          "ensure",
          "protocol",
          "port",
          "packagename",
          "logdir",
          "logdir_mode",
          "logdir_owner",
          "logdir_group",
          "servicename",
          "processname",
          "hasstatus",
          "hasrestart",
          "configfile",
          "configfile_init",
          "configfile_mode",
          "configfile_owner",
          "configfile_group",
          ]

each($names) |$v| {
    $var = "easybuild::params::${v}"
    notice("${var} = ", inline_template('<%= scope.lookupvar(@var) %>'))
}
