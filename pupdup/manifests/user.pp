define pupdup::user($user = $title) {
	group { $user:
		name   => $user,
		ensure => present
	}

	user { $user:
		name   => $user,
		gid    => $user,
		home   => "/home/$user",
		ensure => present
	}

	file { "/home/$user":
		path   => "/home/$user",
		ensure => directory,
		owner  => $user,
		group  => $user,
		mode   => 0600
	}
}