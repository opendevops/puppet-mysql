# = Class: mysql::database
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
define mysql::database ($database = $title, $user) {

  # source: https://github.com/alkivi-sas/puppet-mysql/tree/github/manifests

  $charset = 'utf8'

  # validate_string($user)
  # validate_string($charset)
  #
  # mysql::user { $user: }

  exec { "create-database-${title}":
    command  => "mysql -e 'CREATE DATABASE ${title} character SET utf8; GRANT ALL on ${title}.* to ${user}@localhost; FLUSH PRIVILEGES;' -uroot -p`cat /root/.passwd/db/mysql`",
    provider => 'shell',
    path     => ['/bin', '/sbin', '/usr/bin' ],
    require  => Exec["create-mysql_user-$user"],
    unless   => "mysql -e 'SHOW DATABASES LIKE \"${title}\"' -uroot -p`cat /root/.passwd/db/mysql` | grep -q ${title}",
  }
}
