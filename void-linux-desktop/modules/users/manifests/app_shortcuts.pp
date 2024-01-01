class users::app_shortcuts (
  Array[Tuple[String, String]] $users,
  Boolean $apulse,
) {
  $users.each |Tuple[String, String] $u| {
    $user = $u[0]

    # Firefox shortcut that enables KDE file picker
    if $apulse {
      $firefox_shortcut = 'firefox_apulse.desktop'
    } else {
      $firefox_shortcut = 'firefox.desktop'
    }
    file { "/home/${user}/.local/share/applications/firefox.desktop":
      ensure => 'file',
      backup => false,
      owner  => $user,
      group  => $user,
      mode   => '0644',
      source => "puppet:///modules/users/${firefox_shortcut}",
    }

    File["/home/${user}/.local/share/applications"] ->
    File["/home/${user}/.local/share/applications/firefox.desktop"]
  }
}
