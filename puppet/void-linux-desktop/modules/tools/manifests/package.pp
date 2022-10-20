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
		'ffmpeg',
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
		'libfido2',
		'libjpeg-turbo-tools',
		'lvm2',
		'lz4',
		'makepasswd',
		'nano',
		'ntfs-3g',
		'p7zip',
		'rsync',
		'samba',
		'simple-mtpfs',
		'screen',
		'tar',
		'tree',
		'tpm2-tools',
		'tpm2-totp',
		'tpm2-tss',
		'u2f-hidraw-policy',
		'udftools',
		'unrar',
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

	Class['void::repo_nonfree'] ->
	Void::Package['unrar']
}
