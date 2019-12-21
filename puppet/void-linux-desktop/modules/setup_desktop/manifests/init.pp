class setup_desktop (
	Array[Tuple[String, String]] $users = [],
	Boolean $intel = false,
	String $timezone = 'UTC',
	Integer $grub_timeout = 2,
) {
	$groups = ['audio', 'bluetooth', 'cdrom', 'input', 'kvm', 'lp', 'lpadmin', 'network', 'plugdev', 'vboxusers', 'video', 'users']
	$directories = ['Dokumenty', 'Filmy', 'Muzyka', 'Obrazy', 'Pobrane', 'Pulpit']

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
	class { 'console_kit': }
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
	if $intel {
		class { 'thermald': }  # Only intels proccessors!
	}
	class { 'preload': }
	class { 'java': }
	class { 'ssh': enable => false }
	class { 'users':
		users => $users,
		groups => $groups,
		directories => $directories,
		stage => configuration,
	}
}
