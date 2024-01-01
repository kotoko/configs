class intel_gpu {
	$pkgs = [
		'mesa-dri',
		'vulkan-loader',
		'Vulkan-Tools',
		'mesa-vulkan-intel',
		'intel-video-accel',
	]

	$pkgs.each |String $pkg| {
		void::package { $pkg:
			ensure => 'installed',
		}
	}

	file { '/etc/X11/xorg.conf.d/20-intel.conf':
		ensure => 'file',
		backup => false,
		owner => 'root',
		group => 'root',
		mode => '0644',
		source => 'puppet:///modules/intel_gpu/20-intel.conf',
	}

	File['/etc/X11/xorg.conf.d'] ->
	File['/etc/X11/xorg.conf.d/20-intel.conf']
}
