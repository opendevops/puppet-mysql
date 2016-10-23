# = Class: mysql::user
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#   include apache
#   apache::vhost{ 'appserver1604':
#     projectPath => '/vagrant/www/projects'
#   }
#
# === Authors
#
# Matthew Hansen
#
# === Copyright
#
# Copyright 2016 Matthew Hansen
#
define mysql::user ($username = $title, $password) {

  # source: https://github.com/alkivi-sas/puppet-mysql/tree/github/manifests

  # validate_string($domain)

  $domain = 'localhost'

  if($password)
  {

    # alkivi_base::passwd { "${title}-db":
    #   file => $title,
    #   type => 'db',
    # }
    #
    # $mysql_password = alkivi_password('mysql', 'db')
    # $user_password = alkivi_password($title, 'db')


    $mysql_password = $username
    $user_password = $password

    exec { "create-mysql_user-${title}":
      command  => "mysql -e \"CREATE USER ${title}@${domain} IDENTIFIED BY '${user_password}'\" -uroot -p${mysql_password}",
      provider => 'shell',
      path     => ['/bin', '/sbin', '/usr/bin' ],
      require  => Service["mysql"],
      unless   => "mysql -u${title} -p${user_password} -e ''",
    }
  }
  else
  {
    exec { "create-mysql_user-${title}":
      command  => "mysql -e \"CREATE USER ${title}@${domain}\" -uroot -p${mysql_password}",
      provider => 'shell',
      path     => ['/bin', '/sbin', '/usr/bin' ],
      require  => Service["mysql"],
      unless   => "mysql -u${title} -e ''",
    }
  }
}
