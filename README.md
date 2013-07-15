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

