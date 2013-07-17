# A class to install java as user
# It essentially performes a untar of a specific java.tar.gz from
# a directory containing lots of java tarballs.
# It can also ensure that java is gone.
# It will autodetect architecture and platform

# Usage:

# rootless::java { '/opt/app/place/':
#   ensure              => present,
#   java_major_version  => '7',
#   java_update_version => '25',
#   tarball_directory   => '/big/nfs/mount',
# }

# rootless::java { '/opt/app/other_place/':
#   ensure            => present,
#   tarball_directory => '/big/nfs/mount',
#   java_file         => 'my-special-jdk-tarball.tar.gz',
#   java_create_dir   => 'jdk-1.7.0_09',    # the directory created by the untar operation
# }

# rootless::java { '/opt/app/yet_another_place/':
#   ensure            => absent,
# }

# rootless::java { 'my-java-install':
#   ensure              => present,
#   java_major_version  => '7',
#   java_update_version => '25',
#   tarball_directory   => '/big/nfs/mount',
#   install_root        => '/opt/app/best_place',
# }
define rootless::java (
  $ensure,
  $tarball_directory = '',
  $java_major_version = '',
  $java_update_version = '',
  $java_file = '',
  $java_install_dir= '',
  $install_root = $name
){

  case $ensure {
    true: {
      $real_ensure = true
    }
    /present|true/: {
      $real_ensure = true
    }
    false: {
      $real_ensure = false
    }
    /absent|false/: {
      $real_ensure = false
    }
    default: {
      fail("ensure: ${ensure} not supported.")
    }
  }

  if $real_ensure {
    if $tarball_directory == '' {
      fail('When installing java, a tarball_directory must be specified.')
    }
    if $java_file != '' {
      if $java_install_dir == '' {
        fail('When specifying a tarball via java_file, you must also speciy a java_install_dir, the directory created by the untar')
      }
    }
  }

  case $::architecture {
    'x86_64': { $java_arch = 'x64' }
    'i386':   { $java_arch = 'i586' }
    default:  {
      fail("Arch: ${::architecture} not supported, please add it.")
    }
  }

  $java_cmp_ver = "${java_major_version}u${java_update_version}"

  if $java_file == '' {
    $java_name = "jdk-${java_cmp_ver}-${::kernel}-${java_arch}"
    $juv_fmt = inline_template('<%= @java_update_version.to_s.rjust(2, '0') %>')
    $java_create_dir = "jdk-1.${java_major_version}.0_${juv_fmt}"
  } else {
    $java_name = $java_file
    $java_create_dir = $java_install_dir
  }




  if $real_ensure {

    exec {"create-java-install-${install_root}":
      command => "/bin/tar xvzf ${tarball_directory}/${java_name}",
      cwd     => $install_root,
      creates => "${install_root}/${java_create_dir}",
    }

  }
  elsif ! $real_ensure {

    exec {"create-java-install-${install_root}":
      command => "/bin/rm -fr ${java_create_dir}",
      cwd     => $install_root,
      onlyif  => "/usr/bin/stat ${install_root}/${java_create_dir}",
    }

  }

}
