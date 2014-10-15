Files
=====

Puppet comes with both a client and server for copying files around. The file
serving function is provided as part of the central Puppet daemon,
puppetmasterd, and the client function is used through the source attribute of
file objects. Learn more [here](http://projects.puppetlabs.com/projects/puppet/wiki/File_Serving_Configuration)

You can use managed files like this:

    class easybuild {
      package { easybuild: ensure => latest }
      file { "/etc/easybuild.conf":
        source => "puppet://$servername/modules/easybuild/myfile"
      }
    }

The files are searched for in:
	
	$modulepath/easybuild/files/myfile

