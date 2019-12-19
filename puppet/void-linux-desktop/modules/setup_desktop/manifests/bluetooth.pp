# Install blueetoth.
class setup_desktop::bluetooth {
	void::package { 'bluez':
		ensure => 'installed',
	}

	void::service { 'bluetoothd':
		enable => true,
		require => Void::Package['bluez']
	}
}
