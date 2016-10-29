#
#
#
class easybuild::install {
  anchor{'easybuild::install::begin':}

  ensure_packages($easybuild::params::required_packages)

  package { $easybuild::params::module_package:
    ensure          => latest,
    install_options => $easybuild::params::install_options,
    require         => [Package[$easybuild::params::required_packages],
                        Anchor['easybuild::install::begin']],
  }

  package { $easybuild::params::py_yaml:
    ensure  => installed,
    require => Package[$easybuild::params::module_package],
  }

  anchor{'easybuild::install::end':
    require => Package[$easybuild::params::py_yaml],
  }
}