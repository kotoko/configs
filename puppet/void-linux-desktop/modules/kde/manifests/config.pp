class kde::config {
	# Remove 'nox11' (from pam config) from line with 'pam_ck_connector.so'.
	exec { 'sed_system-login':
		command => '/sbin/sed -i -r "s/(pam_ck_connector\.so)(.*)nox11(.*)$/\1\2\3/" /etc/pam.d/system-login',
	}
}
