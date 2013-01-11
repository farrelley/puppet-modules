class mysqld {
  package { 
    [
      "mysql",
      "mysql-server",
      "perl-DBD-MySQL",
    ]: ensure => installed,
  }

  service { "mysqld":
    enable     => true,
    ensure     => running,
    subscribe  => Package["mysql"],
  }     
}