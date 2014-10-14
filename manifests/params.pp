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
        default => "${easybuild_ensure}"
    }

    # The Protocol used. Used by monitor and firewall class. Default is 'tcp'
    #$protocol = $easybuild_protocol ? {
    #    ''      => 'tcp',
    #    default => "${easybuild_protocol}",
    #}
    # The port number. Used by monitor and firewall class. The default is 22.
    #$port = $easybuild_port ? {
    #    ''      => 22,
    #    default => "${easybuild_port}",
    #}
    # example of an array variable
    #$array_variable = $easybuild_array_variable ? {
    #    ''      => [],
    #    default => $easybuild_array_variable,
    #}


    #### MODULE INTERNAL VARIABLES  #########
    # (Modify to adapt to unsupported OSes)
    #######################################
    # easybuild packages
    #$packagename = $::operatingsystem ? {
    #    default => 'easybuild',
    #}
    # $extra_packages = $::operatingsystem ? {
    #     /(?i-mx:ubuntu|debian)/        => [],
    #     /(?i-mx:centos|fedora|redhat)/ => [],
    #     default => []
    # }

    # Path for the commands
    $path = $::operatingsystem ? {
	    'CentOS' => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/share/lmod/lmod/libexec/" ],
	    'Debian' => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ],
    }

    # Branch of the git repository to pull for the configuration file
    $branch = $::operatingsystem ? {
	    'CentOS' => 'feature/Lmod',
	    'Debian' => 'master',
    }

    # File to source (depend on the module command used)
    $moduleSource = $::operatingsystem ? {
	    'CentOS' => '/usr/share/lmod/lmod/init/profile',
	    'Debian' => '/usr/share/?odules/init/bash',
    }

    # Package that provide the module command
    $modulePackage = $::operatingsystem ? {
	    'CentOS' => 'Lmod',
	    'Debian' => 'environment-modules',
    }

    $installOptions = $::operatingsystem ? {
	    'CentOS' => '--enablerepo=epel-testing',
	    'Debian' => [ '-t', 'jessie' ],
    }

    # Log directory
    #$logdir = $::operatingsystem ? {
    #    default => '/var/log/easybuild'
    #}
    #$logdir_mode = $::operatingsystem ? {
    #    default => '750',
    #}
    #$logdir_owner = $::operatingsystem ? {
    #    default => 'root',
    #}
    #$logdir_group = $::operatingsystem ? {
    #    default => 'adm',
    #}

    # PID for daemons
    # $piddir = $::operatingsystem ? {
    #     default => "/var/run/easybuild",
    # }
    # $piddir_mode = $::operatingsystem ? {
    #     default => '750',
    # }
    # $piddir_owner = $::operatingsystem ? {
    #     default => 'easybuild',
    # }
    # $piddir_group = $::operatingsystem ? {
    #     default => 'adm',
    # }
    # $pidfile = $::operatingsystem ? {
    #     default => '/var/run/easybuild/easybuild.pid'
    # }

    # easybuild associated services
    #$servicename = $::operatingsystem ? {
    #    /(?i-mx:ubuntu|debian)/ => 'easybuild',
    #    default                 => 'easybuild'
    #}
    # used for pattern in a service ressource
    #$processname = $::operatingsystem ? {
    #    /(?i-mx:ubuntu|debian)/ => 'easybuild',
    #    default                 => 'easybuild'
    #}
    #$hasstatus = $::operatingsystem ? {
    #    /(?i-mx:ubuntu|debian)/        => false,
    #    /(?i-mx:centos|fedora|redhat)/ => true,
    #    default => true,
    #}
    #$hasrestart = $::operatingsystem ? {
    #    default => true,
    #}

    # Configuration directory & file
    # $configdir = $::operatingsystem ? {
    #     default => "/etc/easybuild",
    # }
    # $configdir_mode = $::operatingsystem ? {
    #     default => '0755',
    # }
    # $configdir_owner = $::operatingsystem ? {
    #     default => 'root',
    # }
    # $configdir_group = $::operatingsystem ? {
    #     default => 'root',
    # }

    #$configfile = $::operatingsystem ? {
    #    default => '/etc/easybuild.conf',
    #}
    #$configfile_init = $::operatingsystem ? {
    #    /(?i-mx:ubuntu|debian)/ => '/etc/default/easybuild',
    #    default                 => '/etc/sysconfig/easybuild'
    #}
    #$configfile_mode = $::operatingsystem ? {
    #    default => '0600',
    #}
    #$configfile_owner = $::operatingsystem ? {
    #    default => 'root',
    #}
    #$configfile_group = $::operatingsystem ? {
    #    default => 'root',
    #}


}

