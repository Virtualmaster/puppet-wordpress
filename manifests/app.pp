class wordpress::app {

  #$wordpress_archive = 'wordpress-3.4.1.zip'
  $wordpress_archive = 'wordpress-3.5.zip'

  $apache = $::operatingsystem ? {
    Ubuntu   => apache2,
    CentOS   => httpd,
    Debian   => apache2,
    default  => httpd
  }

  $phpmysql = $::operatingsystem ? {
    Ubuntu   => php5-mysql,
    CentOS   => php-mysql,
    Debian   => php5-mysql,
    default  => php-mysql
  }

  $php = $::operatingsystem ? {
    Ubuntu   => libapache2-mod-php5,
    CentOS   => php,
    Debian   => libapache2-mod-php5,
    default  => php
  }

  package { ['unzip',$apache,$php,$phpmysql]:
    ensure => latest
  }

  $vhost_path = $apache ? {
    httpd    => '/etc/httpd/conf.d/wordpress.conf',
    apache2  => '/etc/apache2/sites-enabled/000-wordpress',
    default  => '/etc/httpd/conf.d/wordpress.conf',
  }

  service { $apache:
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package[$apache, $php, $phpmysql],
    subscribe  => File['wordpress_vhost'];
  }

  file {
    # FIX ME, this is only for apache2!!!!
    '/etc/apache2/sites-enabled/000-default':
      ensure => absent;
      #target => '/etc/apache2/sites-enabled/000-default';
    'wordpress_application_dir':
      ensure  =>  directory,
      path    =>  "${wordpress::app_directory}",
      before  =>  File['wordpress_setup_files_dir'];
    'wordpress_setup_files_dir':
      ensure  =>  directory,
      path    =>  "${wordpress::app_directory}/setup_files",
      before  =>  File[
                      'wordpress_php_configuration',
                      'wordpress_themes',
                      'wordpress_plugins',
                      'wordpress_installer',
                      'wordpress_htaccess_configuration'
                      ];
    'wordpress_installer':
      ensure  =>  file,
      path    =>  "/${wordpress::app_directory}/setup_files/${wordpress_archive}",
      notify  =>  Exec['wordpress_extract_installer'],
      source  =>  "puppet:///modules/wordpress/${wordpress_archive}";
    'wordpress_php_configuration':
      ensure     =>  file,
      path       =>  "${wordpress::app_directory}/wp-config.php",
      content    =>  template('wordpress/wp-config.erb'),
      subscribe  =>  Exec['wordpress_extract_installer'];
    'wordpress_htaccess_configuration':
      ensure     =>  file,
      path       =>  "${wordpress::app_directory}/.htaccess",
      source     =>  'puppet:///modules/wordpress/.htaccess',
      subscribe  =>  Exec['wordpress_extract_installer'];
    'wordpress_themes':
      ensure     => directory,
      path       => "${wordpress::app_directory}/setup_files/themes",
      source     => 'puppet:///modules/wordpress/themes/',
      recurse    => true,
      purge      => true,
      ignore     => '.svn',
      notify     => Exec['wordpress_extract_themes'],
      subscribe  => Exec['wordpress_extract_installer'];
    'wordpress_plugins':
      ensure     => directory,
      path       => "${wordpress::app_directory}/setup_files/plugins",
      source     => 'puppet:///modules/wordpress/plugins/',
      recurse    => true,
      purge      => true,
      ignore     => '.svn',
      notify     => Exec['wordpress_extract_plugins'],
      subscribe  => Exec['wordpress_extract_installer'];
    'wordpress_vhost':
      ensure   => file,
      path     => $vhost_path,
      content  => template('wordpress/wordpress_conf.erb'),
      replace  => true,
      require  => Package[$apache];
    }

      exec {
      'wordpress_extract_installer':
        command      => "unzip -o\
                        ${wordpress::app_directory}/setup_files/${wordpress_archive}\
                        -d /opt/",
        refreshonly  => true,
        require      => Package['unzip'],
        path         => ['/bin','/usr/bin','/usr/sbin','/usr/local/bin'];
      'wordpress_extract_themes':
        command      => "/bin/sh -c \'for themeindex in `ls \
                        ${wordpress::app_directory}/setup_files/themes/*.zip`; \
                        do unzip -o \
                        \$themeindex -d \
                        ${wordpress::app_directory}/wp-content/themes/; done\'",
        path         => ['/bin','/usr/bin','/usr/sbin','/usr/local/bin'],
        refreshonly  => true,
        require      => Package['unzip'],
        subscribe    => File['wordpress_themes'];
      'wordpress_extract_plugins':
        command      => "/bin/sh -c \'for pluginindex in `ls \
                        ${wordpress::app_directory}/setup_files/plugins/*.zip`; \
                        do unzip -o \
                        \$pluginindex -d \
                        ${wordpress::app_directory}/wp-content/plugins/; done\'",
        path         => ['/bin','/usr/bin','/usr/sbin','/usr/local/bin'],
        refreshonly  => true,
        require      => Package['unzip'],
        subscribe    => File['wordpress_plugins'];
  }
}
