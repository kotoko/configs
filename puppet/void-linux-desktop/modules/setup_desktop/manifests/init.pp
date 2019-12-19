class setup_desktop (
	Array[Tuple[String, String]] $users = [],
	Boolean $intel = false,
) {
	stage { 'repository': before => Stage[update] }
	stage { 'update': require => Stage[repository], before => Stage[main] }
	stage { 'configuration': require => Stage[main] }

	class { 'setup_desktop::repository': stage => repository }
	class { 'setup_desktop::update_system': stage => update }
	include setup_desktop::syslog
	class { 'setup_desktop::disable_ttys': nrs => [1] }
	include setup_desktop::cron
	include setup_desktop::timezone
	include setup_desktop::ntp
	include setup_desktop::polkit
	include setup_desktop::grub_timeout
	include setup_desktop::network_manager
	include setup_desktop::xorg
	include setup_desktop::console_kit
	include setup_desktop::alsa
	include setup_desktop::bluetooth
	include setup_desktop::cups
	include setup_desktop::udisks
	include setup_desktop::shutdown_permission
	include setup_desktop::firewall
	include setup_desktop::sddm
	include setup_desktop::dbus
	include setup_desktop::kde
	include setup_desktop::tools
	include setup_desktop::daily_programs
	if $intel {
		include setup_desktop::thermald  # Only intels proccessors!
	}
	include setup_desktop::preload
	include setup_desktop::java
	include setup_desktop::ssh
	class { 'setup_desktop::users': stage => configuration, users => $users }
}
