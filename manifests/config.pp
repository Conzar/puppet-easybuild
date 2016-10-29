##
#
#
class easybuild::config {
  anchor{'easybuild::config::begin': }

  $install_dir = $easybuild::params::install_dir
  $python      = $easybuild::params::python_path
  $softwares   = $easybuild::softwares
  $bootstrap_file = 'bootstrap_eb.py'
  $bootstrap_url = "https://raw.githubusercontent.com/hpcugent/easybuild-\
framework/develop/easybuild/scripts/${bootstrap_file}"

  user { 'sw':
    ensure     => present,
    home       => '/home/sw',
    managehome => true,
    shell      => '/bin/bash',
    require    => Anchor['easybuild::config::begin'],
  }

#  file { '/opt':
#    ensure  => directory,
#    #owner   => 'sw',
#    require => User[ 'sw' ],
#  }

  file {$install_dir:
    ensure  => directory,
    require => User['sw'],
  }

  file {'/opt/apps':
    ensure => directory,
    owner  => 'sw',
    require => File[$install_dir],
  }

  # use vcsrepo instead of exec
  vcsrepo { "${install_dir}/easybuild_config":
    ensure   => latest,
    provider => git,
    source   => $easybuild::params::config_repo,
    revision => $easybuild::params::branch,
    require  => File['/opt/apps'],
  }


  # Configure environment variables for the module command
  file { '/etc/profile.d/easybuild.sh':
    ensure  => file,
    owner   => 'sw',
    source  => "${install_dir}/easybuild_config/easybuild.sh",
    require => Vcsrepo["${install_dir}/easybuild_config"],
  }

  # wget
  wget::fetch { 'bootstrap':
    source      => $bootstrap_url,
    destination => "${install_dir}/easybuild_config/${bootstrap_file}",
    timeout     => 0,
    verbose     => false,
    require     => File['/etc/profile.d/easybuild.sh'],
  }

  # install easy build
  exec { 'install_easybuild':
    user    => 'sw',
    command => "/bin/bash -c 'source ${easybuild::params::module_source} &&\
 python ${bootstrap_file} /opt/apps/EasyBuild'",
    creates => '/opt/apps/EasyBuild',
    umask   => '022',
    cwd     => "${install_dir}/easybuild_config",
    require => Wget::Fetch['bootstrap'],
  }

  file { 'install.py':
    ensure  => present,
    path    => "${install_dir}/install.py",
    owner   => 'sw',
    mode    => '0755',
    source  => 'puppet:///modules/easybuild/install.py',
    #require => File['/etc/profile.d/easybuild.sh'],
    require => Exec['install_easybuild'],
  }

  file { 'softwares.yaml':
    ensure  => present,
    path    => "${install_dir}/softwares.yaml",
    owner   => 'sw',
    mode    => '0755',
    content => template('easybuild/softwares.yaml.erb'),
    require => File['install.py'],
  }

  file { 'variables.sh':
    ensure  => present,
    path    => "${install_dir}/variables.sh",
    owner   => 'sw',
    mode    => '0755',
    source  => '/etc/profile.d/easybuild.sh',
    require => File['softwares.yaml'],
  }

  # only run install if something has changed
  exec { 'install':
    user        => 'sw',
    path        => $easybuild::params::path,
    command     => "${python} install.py ${easybuild::branch}\
 ${easybuild::easybuild_version}",
    umask       => '022',
    cwd         => $install_dir,
    environment => 'HOME=/home/sw',
    refreshonly => true,
    subscribe   => File[ 'install.py','softwares.yaml', 'variables.sh' ],
  }

  anchor{'easybuild::config::end':
    require => Exec['install'],
  }
}