# = Class: mysql::config
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
define mysql::config (
  $password = '',
  # default: bind-address = 127.0.0.1
  $bind_address = '127.0.0.1',
  # default: key_buffer_size = 16M
  $key_buffer_size = '16M',
  # default: max_allowed_packet = 16M
  $max_allowed_packet = '16M',
  # default: thread_stack = 192K
  $thread_stack = '192K',
  # default: thread_cache_size = 8
  $thread_cache_size = 8,
  # default: query_cache_limit = 1M
  $query_cache_limit = '2M',
  # default: query_cache_size = 16M
  $query_cache_size = '64M',
  $innodb_file_per_table = 'innodb_file_per_table = 1',
  $innodb_buffer_pool_size = 'innodb_buffer_pool_size = 64M',
  $innodb_log_buffer_size = 'innodb_log_buffer_size = 8M',
  $innodb_open_files = 'innodb_open_files = 16000',
  $innodb_log_file_size = 'innodb_log_file_size = 64M',
) {

  # secure mysql
  # exec { 'mysql_secure_installation' :
  #   command => 'mysql_secure_installation',
  #   require => Package['mysql-server'],
  #   notify  => Service['mysql']
  # }


  # set the root password
  exec { 'root-password' :
    command => '/usr/bin/mysqladmin -u root password "$password"',
    # require => Exec['mysql_secure_installation'],
    require => Package["mysql-server"],
    notify  => Service['mysql']
  }


  # mysql config file
  file { 'mysqld.cnf':
    # ensure     => file,
    mode       => '0644',
    path       => '/etc/mysql/mysql.conf.d/mysqld.cnf',
    content    => template('mysql/mysqld.cnf.erb'),
    require    => Package["mysql-server"],
    subscribe  => Package["mysql-server"],
  }

  # .my.cnf for mysql database password
  file { "/root/.my.cnf":
    ensure    => file,
    owner     => 'root',
    mode      => '0644',
    path      => '/root/.my.cnf',
    content   => template('mysql/.my.cnf.erb'),
    notify    => Service['mysql'],
    require   => Package['mysql-server'],
  }

}