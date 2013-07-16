define noroot::file(
  $mode    = undef,
  $content = '',
  $notify  = undef
){

  # this translates it into a file save to write in one file
  # eg.g /etc/httpd/conf.d/app.conf becomes
  # -etc-httpd-conf.d-app.conf
  $tempname = regsubst($name, '/', '-', 'G')

  file { "/var/tmp/${tempname}":
    ensure  => file,
    content => $content,
  }

  exec { "copy-in-${name}":
    command   => "cat /var/tmp/${tempname} > ${name}",
    subscribe => File["/var/tmp/${tempname}"],
    notify    => $notify,
  }
}

