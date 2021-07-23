class users::psd (
	Array[Tuple[String, String]] $users,
) {
  $users.each |Tuple[String, String] $u| {
    $user = $u[0]
    file { "/home/${user}/.config/vlc":
      ensure   => 'directory',
        backup => false,
        owner  => $user,
        mode   => '0750',
      }

    file { "/home/${user}/.config/vlc/vlcrc":
      ensure => 'file',
      backup => false,
      owner => $user,
      mode => '0640',
      source => "puppet:///modules/users/vlc/vlcrc",
    }

    File["/home/${user}/.config"] ->
    File["/home/${user}/.config/vlc"] ->
    File["/home/${user}/.config/vlc/vlcrc"]
  }
}