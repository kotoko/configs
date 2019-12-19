# Install udisks2.
class setup_desktop::udisks {
	void::package { 'udisks2':
		ensure => 'installed',
	}

	# Allow users to manage connections.
	file { '/etc/polkit-1/rules.d/52-udisks2.rules':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0644',
		source => 'puppet:///modules/setup_desktop/udisks/52-udisks2.rules',
		require => [
			Void::Package['udisks2'],
			Void::Package['polkit'],
		],
	}
}
