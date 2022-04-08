class users::pipewire_autostart (
  Array[Tuple[String, String]] $users,
) {
  $users.each |Tuple[String, String] $u| {
    $user = $u[0]

    file { "/home/${user}/.pipewire-start.sh":
      ensure => 'file',
      backup => false,
      owner => $user,
      group => $user,
      mode => '0755',
      source => 'puppet:///modules/users/pipewire-start.sh',
    }

    file { "/home/${user}/.config/autostart/pipewire-start.sh.desktop":
      ensure => 'file',
      backup => false,
      owner => $user,
      group => $user,
      mode => '0755',
      content => epp('users/pipewire-start.sh.desktop.epp', {exec_path => "/home/${user}/.pipewire-start.sh"}),
    }

    File["/home/${user}/.config/autostart"] ->
    File["/home/${user}/.config/autostart/pipewire-start.sh.desktop"]
  }
}
