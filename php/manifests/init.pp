class php {
  
  yumrepo { 
    "epel":
    baseurl => "http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-7.noarch.rpm",
    descr => "IUS Community repository",
    enabled => 1,
    gpgcheck => 0
  }

  package { 
    [
      "php", 
      "php-pear",
      "php-devel",
      "php-pdo",
      "php-mysql",
      "pcre-devel",
      "php-gd",
      "php-mbstring",
      "php-pecl-apc.x86_64",
    ]: ensure => installed,
  }

  package { 
    [
      "php-mcrypt",
      "php-domxml-php4-php5", 
    ]: ensure => installed, 
    require => Yumrepo["epel"]
  }
  
}