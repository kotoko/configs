class users::app_shortcuts (
  Array[Tuple[String, String]] $users,
) {
  $users.each |Tuple[String, String] $u| {
    $user = $u[0]

    # Firefox shortcut that enables KDE file picker
    file { "/home/${user}/.local/share/applications/firefox.desktop":
      ensure => 'file',
      backup => false,
      owner  => 'root',
      mode   => '0644',
      source => 'puppet:///modules/users/firefox.desktop',
    }

    File["/home/${user}/.local/share/applications"] ->
    File["/home/${user}/.local/share/applications/firefox.desktop"]
  }
}
