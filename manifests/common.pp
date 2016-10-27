# ------------------------------------------------------------------------------
# = Class: easybuild::common
#
# Base class to be inherited by the other easybuild classes
#
# Note: respect the Naming standard provided
# here[http://projects.puppetlabs.com/projects/puppet/wiki/Module_Standards]
class easybuild::common {

  # Load the variables used in this module. Check the easybuild-params.pp file
  require easybuild::params

  Exec { path => $easybuild::params::path }

  $localOwner = $easybuild::ensure ? {
    'present' => 'sw',
    'absent'  => 'root',
  }

  $directoryState = $easybuild::ensure ? {
    'present' => 'directory',
    'absent'  => 'absent',
  }

  $packageState = $easybuild::ensure ? {
    'present' => 'latest',
    'absent'  => 'purged',
  }

  if $easybuild::ensure == 'present' {

    $bootstrap_file = 'bootstrap_eb.py'
    $bootstrap_url = "https://raw.githubusercontent.com/hpcugent/easybuild-\
framework/develop/easybuild/scripts/${bootstrap_file}"

    exec { 'install-easybuild':
      user    => $localOwner,
      command => "bash -c 'source ${easybuild::params::moduleSource} &&\
 cd /tmp && wget ${bootstrap_url} && python ${bootstrap_file}\
 /opt/apps/EasyBuild && rm ${bootstrap_file}'",
      creates => '/opt/apps/EasyBuild',
      umask   => '022',
      require => [ File[ '/opt' ],
        User[ 'sw' ],
        Package[ $easybuild::params::modulePackage ]
      ],
    }

    # Configure environment variables for the module command
    file { '/etc/profile.d/easybuild.sh':
      ensure  => file,
      owner   => 'sw',
      source  => '/tmp/eb_config/easybuild.sh',
      require => Exec[ 'Git' ],
    }

    exec { 'Git':
      user    => 'sw',
      command => "bash -c 'cd /tmp/eb_config && git checkout\
 ${easybuild::params::branch} && git pull origin ${easybuild::params::branch}'",
      require => Exec[ 'GitInit' ],
    }

    exec { 'GitInit':
      user    => 'sw',
      command => "bash -c 'cd /tmp/eb_config &&\
 git clone https://github.com/sylmarien/easybuild-config.git . &&\
 git checkout ${easybuild::params::branch}'",
      creates => '/tmp/eb_config/.git',
      require => File[ '/tmp/eb_config' ],
    }

  } else {

    notify { 'easybuild-directory':
      message => "The /opt/apps/EasyBuild directory has not been removed\
 since it may contain some user files.",
    }

    file { '/etc/profile.d/easybuild.sh':
      ensure  => absent,
    }
  }

  file { '/opt':
    ensure  => directory,
    owner   => $localOwner,
    require => User[ 'sw' ],
  }

  user { 'sw':
    ensure     => $easybuild::ensure,
    home       => '/home/sw',
    managehome => true,
    shell      => '/bin/bash',
  }

  package { $easybuild::params::modulePackage:
    ensure          => $packageState,
    install_options => $easybuild::params::installOptions,
  }

  file { '/tmp/eb_config':
    ensure  => directory,
    owner   => $localOwner,
    require => User[ 'sw' ],
  }
}