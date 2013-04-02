# Elasticsearch manifest
# http://www.elasticsearch.org/
# https://github.com/Aethylred/puppet-elasticsearch

class elasticsearch(
  $version      = "0.20.6",
  $install_root = "/opt"
){
  
  package { 
    [ "java-1.6.0-openjdk" ]: 
      ensure => installed
  }

  file { "${$install_root}/elasticsearch":
    ensure => "directory",
    owner  => "root",
    group  => "root",
    mode   => 755,
  }

  case $operatingsystem{
    CentOS:{
      class{'elasticsearch::install':
        version       => $version,
        install_root  => $install_root,
      }
    }
    default:{
      warning{"ElasticSearch ${version} not configured for ${operatingsystem}":}
    }
  }
}

class elasticsearch::install(
  $version      = "0.20.6",
  $install_root = "/opt",
){
  # NOTE: This is not a good way to install something.
  # It would be better to create RPM packages and put them in
  # a repository server
  # https://github.com/tavisto/elasticsearch-rpms
  # ...or use git to clone elasticsearch...

  exec { 'download_elasticsearch':
    require => File["${$install_root}/elasticsearch"],
    path    => "/bin:/usr/bin:/usr/local/bin",
    cwd     => "${install_root}/elasticsearch",
    command => "wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${version}.tar.gz",
    creates => "${install_root}/elasticsearch/elasticsearch-${version}.tar.gz",
  }

  exec { 'extract_elasticsearch':
    path    => "/bin:/usr/bin:/usr/local/bin",
    cwd     => "${install_root}/elasticsearch",
    command => "tar -xzf elasticsearch-${version}.tar.gz",
    require => Exec['download_elasticsearch'],
    creates => "${install_root}/elasticsearch/elasticsearch-${version}",
  }

  file { "${install_root}/elasticsearch/current":
    ensure  => link,
    target  => "${install_root}/elasticsearch/elasticsearch-${version}",
    require => Exec['extract_elasticsearch'],
  }

## FIXME pupper error : alias git-core already exists
#  package{ "git-core":
#    require => File["${install_root}/elasticsearch/current"],
#    ensure => installed, 
#  }

  exec{'clone_servicewrapper':
    require => File["${install_root}/elasticsearch/current"], # Package["git-core"]],
    path    => ['/usr/bin','/bin'],
    cwd     => $install_root,
    user    => root,
    command => "git clone http://github.com/elasticsearch/elasticsearch-servicewrapper.git elasticsearch-servicewrapper&& cp -R elasticsearch-servicewrapper/service elasticsearch/current/bin",
    creates => "${install_root}/elasticsearch/current/bin/service",
  } 
  
  exec{'install_servicewrapper':
    require => Exec['clone_servicewrapper'],
    user    => root,
    command => "${install_root}/elasticsearch/current/bin/service/elasticsearch install",
    creates => "/etc/init.d/elasticsearch",
  }

  service{'elasticsearch':
    require => Exec['install_servicewrapper'],
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
  }
}
