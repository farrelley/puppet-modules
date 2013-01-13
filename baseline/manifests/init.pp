class baseline {  
  exec { 'yum_update': 
    command => '/usr/bin/yum update -y'
  }
  
  exec { "set timezone":
    command => "/bin/ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime",
    refreshonly => true
  }

  Service {
    hasstatus => true,
    hasrestart => true
  }

  package {
    [
      "perl-Time-HiRes",
      "tree",
      "screen", 
      "git",
      "gcc",
      "make",
      "libssh2",
    ]: ensure => installed,
  }
    
  service {
   "crond": 
     enable => true, 
     ensure => running,
  }

}