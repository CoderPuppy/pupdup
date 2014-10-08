define pupdup::download($path = $title, $owner, $group, $source, $mode) {
	exec { "/usr/bin/wget -O $path $source":
		creates => $path,
		user    => $owner,
		group   => $group,
		before  => File[$path]
	}

	file { $path:
		ensure => $ensure,
		owner  => $owner,
		group  => $group,
		mode   => $mode
	}
}