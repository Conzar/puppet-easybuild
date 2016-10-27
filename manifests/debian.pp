 # ------------------------------------------------------------------------------
# = Class: easybuild::debian
#
# Specialization class for Debian systems
class easybuild::debian inherits easybuild::common {
  Package[ $easybuild::params::modulePackage ] {
    before => Package[ 'tcl-dev' ],
  }

  package { 'tcl-dev':
    ensure => $packageState,
  }
}