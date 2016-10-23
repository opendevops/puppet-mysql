# == Class: mysql
#
# Full description of class mysql here.
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
# include mysql
# mysql::config { 'mysql_config': password => 'verystrongpassword' }
# mysql::user { 'dbuser': password => 'strongpassword' }
# mysql::database { 'appserver': user => 'dbuser' }
#
# === Authors
#
# Matthew Hansen
#
# === Copyright
#
# Copyright 2016 Matthew Hansen
#
class mysql () {


  # install mysql-server package
  package { 'mysql-server':
    ensure  => installed,
    require => Exec['apt-update'],
  }

  # install mysql-client package
  package { 'mysql-client':
    ensure  => installed,
    require => Package['mysql-server'],
  }

  # install mysql-common package
  package { 'mysql-common':
    ensure  => installed,
    require => Package['mysql-server'],
  }

  # ensure mysql service is running
  service { 'mysql':
    ensure  => running,
    enable  => true,
    require => Package["mysql-server"],
  }


}
