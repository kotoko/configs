class void_updater {
  file { "/root/void-updater.sh":
    ensure => 'file',
    backup => false,
    owner => 'root',
    mode => '0700',
    source => "puppet:///modules/void_updater/void-updater.sh",
  }

  file { "/etc/sudoers.d/void-updater":
    ensure => 'file',
    backup => false,
    owner => 'root',
    mode => '0700',
    source => "puppet:///modules/void_updater/sudo_void-updater",
  }

  File["/etc/sudoers.d"] ->
  File["/etc/sudoers.d/void-updater"]
}
