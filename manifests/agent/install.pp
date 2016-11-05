#
class mcafee::agent::install inherits mcafee::agent {

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  if($mcafee::agent::manage_package)
  {
    if($mcafee::agent::package_source==undef)
    {
      fail('undefined package url, nothing to install')
    }
    else
    {
      exec { 'mkdir p ${mcafee::agent::srcdir}':
        command => "mkdir -p ${mcafee::agent::srcdir}",
        creates => $mcafee::agent::srcdir,
      }

      if $mcafee::agent::package_source =~ /^http/
      {
        exec { 'which wget eyp-mcafee::agent':
          command => 'which wget',
          unless  => 'which wget',
          require => Exec["mkdir p ${mcafee::agent::srcdir}"],
        }

        exec { 'wget mcafee package':
          command => "wget ${mcafee::agent::package_source} -O ${mcafee::agent::srcdir}/mcafee-agent.sh",
          creates => "${mcafee::agent::srcdir}/mcafee-agent.sh",
          require => Exec['which wget eyp-mcafee::agent'],
        }
      }
      else
      {
        file { "${srcdir}/mcafee-agent.sh":
          ensure  => 'present',
          owner   => 'root',
          group   => 'root',
          mode    => '0400',
          source  => $mcafee::agent::package_source,
          require => Exec["mkdir p ${mcafee::agent::srcdir}"],
        }
      }
    }
  }

}
