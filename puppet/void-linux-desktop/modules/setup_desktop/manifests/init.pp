class setup_desktop (
	Array[Tuple[String, String]] $users = [],
	String $cpu = '',
	String $timezone = 'UTC',
	Integer $grub_timeout = 2,
	Boolean $enable_ssh = false,
) {
	if $cpu != '' and $cpu != 'intel' {
		fail('Unrecognized $cpu parameter! (Should be \'intel\' or empty string).')
	}

	$user_groups = [
		'audio',
		'bluetooth',
		'cdrom',
		'input',
		'kvm',
		'lp',
		'lpadmin',
		'network',
		'plugdev',
		'scanner',
		'users',
		'vboxusers',
		'video',
	]

	$user_directories = [
		'Dokumenty',
		'Filmy',
		'Muzyka',
		'Obrazy',
		'Pobrane',
		'Pulpit',
	]

	stage { 'repository': before => Stage[update] }
	stage { 'update': require => Stage[repository], before => Stage[main] }
	stage { 'configuration': require => Stage[main] }

	class { 'repository': stage => repository }
	class { 'update_system': stage => update }
	class { 'syslog': }
	class { 'disable_ttys': nrs => [1] }
	class { 'cron': }
	class { 'timezone': timezone => $timezone }
	class { 'ntp': }
	class { 'polkit': }
	class { 'sudo': }
	class { 'grub': timeout => $grub_timeout }
	class { 'network_manager': }
	class { 'xorg': }
	class { 'alsa': }
	class { 'bluetooth': }
	class { 'cups': }
	class { 'udisks': }
	class { 'shutdown_permission': sudo => true, polkit => true }
	class { 'firewall': }
	class { 'dbus': }
	class { 'kde': }
	class { 'sddm': }
	class { 'tools': }
	class { 'daily_programs': }
	if $cpu == 'intel' {
		class { 'thermald': }  # Only intels proccessors!
	}
	class { 'preload': }
	class { 'java': }
	class { 'ssh': enable => $enable_ssh }
	class { 'backup': }
	class { 'users':
		users => $users,
		groups => $user_groups,
		directories => $user_directories,
		stage => configuration,
	}
}
