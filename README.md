#Rootless

A puppet module providing types and providers to enable puppet to be 
functional without running as root.

One goal is to produce near-normal puppet types so that regular puppet 
manifests can be written in the regular style.

Another goal is to integrate well with sudo functionality.


##Types

###rootless::file

A file type that overcomes the limitiation of creating the file. This 
assumes that the file is writeable by the user puppet is running as. It 
overcomes the problem where the containing directory of the file is not
writeable by the user running puppet.

    rootless::file {'/etc/httpd/conf.d/app.conf':
      content => template('application.apache.erb'),
      notify  => Service['httpd'],
    }

###rootless::jdk

A type that will install a jdk based on major and minor version number from
a tarball found somewhere else on the filesystem(often an nfs mount).

    rootless::jdk { '/opt/app/place/':
      ensure              => present,
      jdk_major_version  => '7',
      jdk_update_version => '25',
      tarball_directory   => '/big/nfs/mount',
    }

    rootless::jdk { '/opt/app/other_place/':
      ensure            => present,
      tarball_directory => '/big/nfs/mount',
      jdk_file         => 'my-special-jdk-tarball.tar.gz',
      jdk_install_dir  => 'jdk1.7.0_09',    # the directory created by the untar operation
    }

    rootless::jdk { '/opt/app/yet_another_place/':
      ensure           => absent,
      jdk_install_dir => 'jdk-1.7.0_12',
    }

    rootless::jdk { 'my-jdk-install':
      ensure              => present,
      jdk_major_version  => '7',
      jdk_update_version => '25',
      tarball_directory   => '/big/nfs/mount',
      install_root        => '/opt/app/best_place',
    }


##Facts

###var_tmp_rw

A fact checking if /var/tmp is writable by the puppet user. Var/tmp is a good place to
store permanent temporary files, for the rootless::file type for instance. This will help
us pick a tempdir to create things. Var/tmp is preferable to /tmp since /var/tmp usually
persists after reboot.



#Requirements

* puppetlabs-stdlib
