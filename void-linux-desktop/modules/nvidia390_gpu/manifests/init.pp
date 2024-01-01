class nvidia390_gpu {
	$pkgs = [
		'nvidia390',
		'nvidia390-opencl',
#		'nvidia390-libs-32bit',
		'vulkan-loader',
		'Vulkan-Tools',
	]

	$pkgs.each |String $pkg| {
		void::package { $pkg:
			ensure => 'installed',
		}
	}

	exec { "Add parameter nomodeset to kernel at boot":
		command => 'sed -i -e \'s@^\(GRUB_CMDLINE_LINUX_DEFAULT=".*\)nomodeset\(.*\)$@\1\2@\' /etc/default/grub  &&  sed -i -e \'s@^\(GRUB_CMDLINE_LINUX_DEFAULT="\)\(.*\)$@\1nomodeset \2@\' /etc/default/grub  &&  update-grub',
	}

}
