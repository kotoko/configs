class bluetooth::service {
	void::service { 'bluetoothd':
		enable => true,
	}
}
