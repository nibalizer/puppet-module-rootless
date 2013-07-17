rootless::java { '/opt/app/place/':
  ensure              => present,
  java_major_version  => '7',
  java_update_version => '25',
  tarball_directory   => '/big/nfs/mount',
}

rootless::java { '/opt/app/other_place/':
  ensure            => present,
  tarball_directory => '/big/nfs/mount',
  java_file         => 'my-special-jdk-tarball.tar.gz',
  java_install_dir  => 'jdk1.7.0_09',    # the directory created by the untar operation
}

rootless::java { '/opt/app/yet_another_place/':
  ensure           => absent,
  java_install_dir => 'jdk-1.7.0_12',
}

rootless::java { 'my-java-install':
  ensure              => present,
  java_major_version  => '7',
  java_update_version => '25',
  tarball_directory   => '/big/nfs/mount',
  install_root        => '/opt/app/best_place',
}
