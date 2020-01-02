class intel_gpu {
	$pkgs = [
		'mesa-dri',
		'vulkan-loader',
		'mesa-vulkan-intel',
		'intel-video-accel',
	]

	$pkgs.each |String $pkg| {
		void::package { $pkg:
			ensure => 'installed',
		}
	}
}