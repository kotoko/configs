class intel_cpu {
	void::package { 'intel-ucode':
		ensure => 'installed',
	}
}
