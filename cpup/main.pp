include pupdup

define cpup::user($user = $title) {
	pupdup::user { $user: user => $user }

	file { "/home/$user/code":
		path   => "/home/$user/code",
		ensure => directory,
		owner  => $user,
		group  => $user,
		mode   => 0600
	}

	User <| name == $user |> {
		shell    => '/bin/zsh',
		password => sha1('testing')
	}

	vcsrepo { "/home/$user/.files":
		ensure   => present,
		provider => git,
		source   => 'git://github.com/CoderPuppy/.files.git',
		user     => $user,
		group    => $group,
		require  => File["/home/$user"]
	}

	file { "/home/$user/bin":
		ensure => directory,
		owner  => $user,
		group  => $user,
		mode   => 0600
	}

	file { "/home/$user/bin/sound-switch":
		ensure  => "/home/$user/.files/bin/sound-switch",
		owner   => $user,
		group   => $user,
		mode    => 0700,
		require => Vcsrepo["/home/$user/.files"]
	}

	file { "/home/$user/bin/launcher":
		ensure  => "/home/$user/.files/bin/launcher",
		owner   => $user,
		group   => $user,
		mode    => 0700,
		require => Vcsrepo["/home/$user/.files"]
	}

	# Install Vundle {
		file { ["/home/$user/.vim", "/home/$user/.vim/bundle"]:
			ensure  => directory,
			owner   => $user,
			group   => $user,
			mode    => 0600
		}

		vcsrepo { "/home/$user/.vim/bundle/vundle":
			ensure   => present,
			provider => git,
			source   => 'git://github.com/gmarik/vundle.git',
			user     => $user,
			group    => $group,
			require  => File["/home/$user/.vim/bundle"]
		}
	# }

	# Install Powerline Font {
		file { "/home/$user/.fonts":
			ensure => directory,
			owner  => $user,
			group  => $user,
			mode   => 0600
		}

		pupdup::download { "/home/$user/.fonts/PowerlineSymbols.otf":
			owner => $user,
			group => $user,
			mode => 0600,
			source => 'https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf'
		}

		exec { "/usr/bin/fc-cache -vf /home/$user/.fonts":
			require => Pupdup::Download["/home/$user/.fonts/PowerlineSymbols.otf"]
		}

		file { ["/home/$user/.config", "/home/$user/.config/fontconfig", "/home/$user/.config/fontconfig/conf.d"]:
			ensure => directory,
			owner  => $user,
			group  => $user,
			mode   => 0644,
		}

		pupdup::download { "/home/$user/.config/fontconfig/conf.d/10-powerline-symbols.conf":
			owner   => $user,
			group   => $user,
			mode    => 0600,
			source  => 'https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf',
			require => File["/home/$user/.config/fontconfig/conf.d"]
		}
	# }

	# # Install Nave {
	# 	pupdup::download { "/home/$user/bin/nave":
	# 		owner   => $user,
	# 		group   => $user,
	# 		mode    => 0700,
	# 		source  => 'https://github.com/isaacs/nave/raw/master/nave.sh',
	# 		require => File["/home/$user/bin"]
	# 	}
	# # }

	# Install Nodenv {
		vcsrepo { "/home/$user/.nodenv":
			ensure   => present,
			provider => git,
			source   => 'git://github.com/wfarr/nodenv.git',
			user     => $user,
			group    => $group,
			require  => File["/home/$user"]
		}
	# }

	# Install Pyenv {
		vcsrepo { "/home/$user/.pyenv":
			ensure   => present,
			provider => git,
			source   => 'git://github.com/yyuu/pyenv.git',
			user     => $user,
			group    => $group,
			require  => File["/home/$user"]
		}
	# }

	# Install RBEnv {
		vcsrepo { "/home/$user/.rbenv":
			ensure   => present,
			provider => git,
			source   => 'git://github.com/sstephenson/rbenv.git',
			user     => $user,
			group    => $group,
			require  => File["/home/$user"]
		}

		vcsrepo { "/home/$user/.rbenv/plugins/ruby-build":
			ensure   => present,
			provider => git,
			source   => 'git://github.com/sstephenson/ruby-build.git',
			user     => $user,
			group    => $group,
			require  => Vcsrepo["/home/$user/.rbenv"]
		}
	# }

	# Install Config Files {
		file { "/home/$user/.vimrc":
			ensure => "/home/$user/.files/vimrc",
			owner  => $user,
			group  => $user,
			mode   => 0600
		}
		file { "/home/$user/.zshenv":
			ensure => "/home/$user/.files/zshenv",
			owner  => $user,
			group  => $user,
			mode   => 0600
		}
		file { "/home/$user/.zshrc":
			ensure => "/home/$user/.files/zshrc",
			owner  => $user,
			group  => $user,
			mode   => 0600
		}
		file { "/home/$user/.bashrc":
			ensure => "/home/$user/.files/bashrc",
			owner  => $user,
			group  => $user,
			mode   => 0600
		}
		file { "/home/$user/.xinitrc":
			ensure => "/home/$user/.files/xinitrc",
			owner  => $user,
			group  => $user,
			mode   => 0600
		}
		file { "/home/$user/.i3status.conf":
			ensure => "/home/$user/.files/i3status.conf",
			owner  => $user,
			group  => $user,
			mode   => 0600
		}
		file { "/home/$user/.tmux.conf":
			ensure => "/home/$user/.files/tmux.conf",
			owner  => $user,
			group  => $user,
			mode   => 0600
		}

		file {
			"/home/$user/.i3":
			ensure => directory,
			owner  => $user,
			group  => $user,
			mode   => 0600;
			"/home/$user/.i3/config":
			ensure => "/home/$user/.files/i3config",
			owner  => $user,
			group  => $user,
			mode   => 0600
		}
	# }

	ssh_keygen { $user: }
}

	package {
		git: ensure  => installed;
		zsh: ensure  => installed;
		tmux: ensure => installed;
	}

# cpup::user { t: }
# cpup::user { notme: }
cpup::user { cpup: }