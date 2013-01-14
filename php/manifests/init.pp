class php {
  
  # Install new repo EPEL and update
  yumrepo { "epel":
    baseurl => "http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-7.noarch.rpm",
    descr => "IUS Community repository",
    enabled => 1,
    gpgcheck => 0,
    require => Exec["yum_update"],
  }

  # Install new repo REMI and update
  yumrepo { "remi-repo":
    baseurl => "http://rpms.famillecollet.com/enterprise/6/remi/x86_64/",
    descr => "Les RPM de REMI",
    enabled => 1,
    gpgcheck => 0,
    require => Exec["yum_update"],
  }
  
  # General PHP Packages from REMI
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
    require => Yumrepo["remi-repo"]
  }
  
  # PHP Mcrypt installed from EPEL (Fedora Repo)
  package { 
   [
      "php-mcrypt",
      "php-domxml-php4-php5",
    ]:
    ensure => installed, 
    require => Yumrepo["epel"]
  }

}