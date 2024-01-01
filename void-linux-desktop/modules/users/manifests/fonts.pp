class users::fonts (
  Array[Tuple[String, String]] $users,
) {
  $users.each |Tuple[String, String] $u| {
    $user = $u[0]
    file { "/home/${user}/.fonts/alte_haas_grotesk":
      ensure   => 'directory',
        backup => false,
        owner  => $user,
        group  => $user,
        mode   => '0750',
      }

    [
      "AlteHaasGroteskBold.ttf",
      "AlteHaasGroteskRegular.ttf",
      "Alte Haas Grotesk licence.rtf",
      "Alte Haas Grotesk example.jpg",
    ].each |String $f| {
      file { "/home/${user}/.fonts/alte_haas_grotesk/${f}":
        ensure => 'file',
        backup => false,
        owner  => $user,
        group  => $user,
        mode   => '0640',
        source => "puppet:///modules/users/fonts/alte_haas_grotesk/${f}",
      }

      File["/home/${user}/.fonts/alte_haas_grotesk"] ->
      File["/home/${user}/.fonts/alte_haas_grotesk/${f}"]
    }

    File["/home/${user}/.fonts"] ->
    File["/home/${user}/.fonts/alte_haas_grotesk"]
  }
}