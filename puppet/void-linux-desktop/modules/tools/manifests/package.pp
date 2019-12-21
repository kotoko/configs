class tools::package {
	$pkgs = [
		'acpi',
		'cryptsetup',
		'ddrescue',
		'dos2unix',
		'dosfstools',
		'efitools',
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
		'nano',
		'ntfs-3g',
		'p7zip',
		'pm-utils',
		'rsync',
		'samba',
		'simple-mtpfs',
		'screen',
		'tar',
		'tree',
		'udftools',
		'unzip',
		'wget',
		'vim',
		'xtools',
		'xz',
		'zip',
		'zpaq',
		'zsync',
	]

	$pkgs.each |String $pkg| {
		void::package { $pkg:
			ensure => 'installed',
		}
	}
}
