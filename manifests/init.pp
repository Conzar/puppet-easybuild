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
    $ensure = $easybuild::params::ensure
)
inherits easybuild::params
{
    info ("Configuring easybuild (with ensure = ${ensure})")

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("easybuild 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    case $::operatingsystem {
        debian, ubuntu:         { include easybuild::debian }
        redhat, fedora, centos: { include easybuild::redhat }
        default: {
            fail("Module $module_name is not supported on $operatingsystem")
        }
    }
}

# ------------------------------------------------------------------------------
# = Class: easybuild::common
#
# Base class to be inherited by the other easybuild classes
#
# Note: respect the Naming standard provided here[http://projects.puppetlabs.com/projects/puppet/wiki/Module_Standards]
class easybuild::common {

    # Load the variables used in this module. Check the easybuild-params.pp file
    require easybuild::params

    package { 'easybuild':
        name    => "${easybuild::params::packagename}",
        ensure  => "${easybuild::ensure}",
    }
    # package { $easybuild::params::extra_packages:
    #     ensure => 'present'
    # }

    if $easybuild::ensure == 'present' {

        # Prepare the log directory
        file { "${easybuild::params::logdir}":
            ensure => 'directory',
            owner  => "${easybuild::params::logdir_owner}",
            group  => "${easybuild::params::logdir_group}",
            mode   => "${easybuild::params::logdir_mode}",
            require => Package['easybuild'],
        }

        # Configuration file
        # file { "${easybuild::params::configdir}":
        #     ensure => 'directory',
        #     owner  => "${easybuild::params::configdir_owner}",
        #     group  => "${easybuild::params::configdir_group}",
        #     mode   => "${easybuild::params::configdir_mode}",
        #     require => Package['easybuild'],
        # }
        # Regular version using file resource
        file { 'easybuild.conf':
            path    => "${easybuild::params::configfile}",
            owner   => "${easybuild::params::configfile_owner}",
            group   => "${easybuild::params::configfile_group}",
            mode    => "${easybuild::params::configfile_mode}",
            ensure  => "${easybuild::ensure}",
            #content => template("easybuild/easybuildconf.erb"),
            #source => "puppet:///modules/easybuild/easybuild.conf",
            #notify  => Service['easybuild'],
            require => [
                        #File["${easybuild::params::configdir}"],
                        Package['easybuild']
                        ],
        }

        # # Concat version
        # include concat::setup
        # concat { "${easybuild::params::configfile}":
        #     warn    => false,
        #     owner   => "${easybuild::params::configfile_owner}",
        #     group   => "${easybuild::params::configfile_group}",
        #     mode    => "${easybuild::params::configfile_mode}",
        #     #notify  => Service['easybuild'],
        #     require => Package['easybuild'],
        # }
        # # Populate the configuration file
        # concat::fragment { "${easybuild::params::configfile}_header":
        #     target  => "${easybuild::params::configfile}",
        #     ensure  => "${easybuild::ensure}",
        #     content => template("easybuild/easybuild_header.conf.erb"),
        #     #source => "puppet:///modules/easybuild/easybuild_header.conf",
        #     order   => '01',
        # }
        # concat::fragment { "${easybuild::params::configfile}_footer":
        #     target  => "${easybuild::params::configfile}",
        #     ensure  => "${easybuild::ensure}",
        #     content => template("easybuild/easybuild_footer.conf.erb"),
        #     #source => "puppet:///modules/easybuild/easybuild_footer.conf",
        #     order   => '99',
        # }

        # PID file directory
        # file { "${easybuild::params::piddir}":
        #     ensure  => 'directory',
        #     owner   => "${easybuild::params::piddir_user}",
        #     group   => "${easybuild::params::piddir_group}",
        #     mode    => "${easybuild::params::piddir_mode}",
        # }

        file { "${easybuild::params::configfile_init}":
            owner   => "${easybuild::params::configfile_owner}",
            group   => "${easybuild::params::configfile_group}",
            mode    => "${easybuild::params::configfile_mode}",
            ensure  => "${easybuild::ensure}",
            #content => template("easybuild/default/easybuild.erb"),
            #source => "puppet:///modules/easybuild/default/easybuild.conf",
            notify  =>  Service['easybuild'],
            require =>  Package['easybuild']
        }

        service { 'easybuild':
            name       => "${easybuild::params::servicename}",
            enable     => true,
            ensure     => running,
            hasrestart => "${easybuild::params::hasrestart}",
            pattern    => "${easybuild::params::processname}",
            hasstatus  => "${easybuild::params::hasstatus}",
            require    => [
                           Package['easybuild'],
                           File["${easybuild::params::configfile_init}"]
                           ],
            subscribe  => File['easybuild.conf'],
        }
    }
    else
    {
        # Here $easybuild::ensure is 'absent'

    }

}


# ------------------------------------------------------------------------------
# = Class: easybuild::debian
#
# Specialization class for Debian systems
class easybuild::debian inherits easybuild::common { }

# ------------------------------------------------------------------------------
# = Class: easybuild::redhat
#
# Specialization class for Redhat systems
class easybuild::redhat inherits easybuild::common { }



