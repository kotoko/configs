class tools::package {
	$pkgs = [
		'acpi',
		'cdrskin',
		'cryptsetup',
		'ddrescue',
		'dos2unix',
		'dosfstools',
		'efitools',
		'f2fs-tools',
		'flac',
		'fuse-exfat',
		'fuse-sshfs',
		'git',
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
		'usbutils',
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
