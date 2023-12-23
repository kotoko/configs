class setup_desktop (
	Array[Tuple[String, String]] $users = [],
	String $cpu = '',
	String $gpu = '',
	String $timezone = 'UTC',
	Integer $grub_timeout = 2,
	Boolean $enable_ssh = false,
	String $sound = 'pipewire',
) {
	if $cpu != '' and $cpu != 'intel' {
		fail('Unrecognized $cpu parameter! (Should be \'intel\' or empty string).')
	}
	if $gpu != '' and $gpu != 'intel' {
		fail('Unrecognized $gpu parameter! (Should be \'intel\' or empty string).')
	}
	if $sound != 'alsa' and $sound != 'pipewire' {
		fail('Unrecognized $sound parameter! (Should be \'alsa\' or \'pipewire\').')
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

	$apulse = ($sound == 'alsa')
	$pipewire = ($sound == 'pipewire')

	stage { 'repository': before => Stage[update] }
	stage { 'update': require => Stage[repository], before => Stage[main] }
	stage { 'configuration': require => Stage[main] }

	class { 'repository': stage => repository }
	class { 'update_system': stage => update }
	class { 'editor': }
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
	class { 'rtkit': }
	class { 'alsa': }
	if $apulse {
		class { 'apulse': }
	}
	if $pipewire {
		class { 'pipewire': }
	}
	class { 'bluetooth': }
	class { 'cups': }
	class { 'udisks': }
	class { 'shutdown_permission': sudo => true, polkit => true }
	class { 'firewall': }
	class { 'dbus': }
	class { 'kde': }
	class { 'fonts': }
	class { 'sddm': }
	class { 'tools': }
	class { 'daily_programs': }
	class { 'tlp': }
	if $cpu == 'intel' {
		class { 'thermald': }  # Only intels proccessors!
	}
	if $gpu == 'intel' {
		class { 'intel_gpu': }  # Only intels proccessors!
	}
	class { 'preload': }
	class { 'sysctl': }
	class { 'java': }
	class { 'void_updater': }
	class { 'ssh': enable => $enable_ssh }
	class { 'backup': }
	class { 'users':
		users => $users,
		groups => $user_groups,
		directories => $user_directories,
		apulse => $apulse,
		stage => configuration,
	}
}
