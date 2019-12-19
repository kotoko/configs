class setup_desktop::tools {
	$pkgs = [
		'acpi',
		'cryptsetup',
		'ddrescue',
		'dos2unix',
		'dosfstools',
		'f2fs-tools',
		'fuse-exfat',
		'fuse-sshfs',
		'git',
		'gnupg',
		'gnupg2',
		'gptfdisk',
		'gzip',
		'exiftool',
		'hfsutils',
		'inotify-tools',
		'lvm2',
		'lz4',
		'makepasswd',
		'ntfs-3g',
		'p7zip',
		'pm-utils',
		'rsync',
		'samba',
		'screen',
		'sudo',
		'tar',
		'tree',
		'udftools',
		'unzip',
		'wget',
		'vim',
		'xtools',
		'xz',
		'zip',
		'zsync',
	]

	$pkgs.each |String $pkg| {
		void::package { $pkg:
			ensure => 'installed',
		}
	}
}
