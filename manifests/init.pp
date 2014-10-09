class easybuild {

        Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

        exec { 'install-eb':
                user    => 'swuser',
                command => "bash -c 'cd /tmp && wget https://raw.githubusercontent.com/sylmarien/easybuild-install/feature/autoinstall/install-EasyBuild-develop.sh && mkdir /opt/apps/EasyBuild && sh install-EasyBuild-develop.sh /opt/apps/EasyBuild && rm install-EasyBuild-develop.sh'",
		creates => "/opt/apps/EasyBuild",
		umask   => '022',
                require => [ File [ '/opt/apps' ],
                        User [ 'swuser' ],
                        Package [ 'environment-modules' ],
                        ]
        }

	file { '/opt/apps':
		ensure  => directory,
		owner   => 'swuser',
		require => File [ '/opt' ],
	}

        file { '/opt':
                ensure => directory,
                owner => 'swuser',
        }

        user { 'swuser':
                ensure => 'present',
        }

        package { 'environment-modules':
                ensure => latest,
		install_options => [ '-t', 'wheezy-backports' ],
        }

        #configure eb env
        file { '/etc/profile.d/easybuild.sh':
                ensure => file,
                owner => 'swuser',
                source => "/tmp/eb_config/easybuild.sh",
                require => [ Exec [ 'Git' ], User [ 'swuser' ] ],
        }

        exec { 'Git':
		user => 'swuser',
                # On pull, on n'a pas peur d'avoir de probleme de merge car a priori les serveurs ne modifient pas localement le fichier
                command => "bash -c 'cd /tmp/eb_config && git pull origin master'",
                require => Exec [ 'GitInit' ],
        }

        exec { 'GitInit':
		user => 'swuser',
                command => "bash -c 'cd /tmp/eb_config && git clone https://github.com/sylmarien/easybuild-config.git .'",
                creates => "/tmp/eb_config/.git",
                require => File [ '/tmp/eb_config' ],
        }

        file { '/tmp/eb_config':
                ensure => directory,
		owner => 'swuser',
		require => User [ 'swuser' ],
        }
}

