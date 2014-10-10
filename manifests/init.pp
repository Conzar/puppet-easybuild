class easybuild {

        Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

        exec { 'install-eb':
                user    => 'swuser',
                command => "bash -c '. /usr/share/?odules/init/bash && cd /tmp && wget https://raw.github.com/hpcugent/easybuild-framework/develop/easybuild/scripts/bootstrap_eb.py && python bootstrap_eb.py /opt/apps/EasyBuild && rm bootstrap_eb.py'",
		creates => "/opt/apps/EasyBuild",
		umask   => '022',
                require => [ File [ '/opt' ], User [ 'swuser' ], Package [ 'environment-modules' ] ],
	}

        file { '/opt':
		ensure  => directory,
		owner   => 'swuser',
		require => User [ 'swuser' ],
	}

        user { 'swuser':
                ensure => 'present',
        }

        package { 'environment-modules':
		ensure          => 'installed',
		install_options => 
		require         => Package [ 'lua5.2' ],
        }

        #configure eb env
        file { '/etc/profile.d/easybuild.sh':
		ensure  => file,
		owner   => 'swuser',
		source  => "/tmp/eb_config/easybuild.sh",
		require => Exec [ 'Git' ],
	}

	# On pull, on n'a pas peur d'avoir de probleme de merge car a priori les serveurs ne modifient pas localement le fichier
        exec { 'Git':
		user    => 'swuser',
		command => "bash -c 'cd /tmp/eb_config && git pull origin master'",
		require => Exec [ 'GitInit' ],
	}

        exec { 'GitInit':
		user    => 'swuser',
		command => "bash -c 'cd /tmp/eb_config && git clone https://github.com/sylmarien/easybuild-config.git .'",
		creates => "/tmp/eb_config/.git",
		require => File [ '/tmp/eb_config' ],
	}

        file { '/tmp/eb_config':
		ensure  => directory,
		owner   => 'swuser',
		require => User [ 'swuser' ],
	}
}

