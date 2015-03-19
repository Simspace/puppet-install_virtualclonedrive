class install_virtualclonedrive (
  $installer = $install_virtualclonedrive::params::installer,
  $certificate = $install_virtualclonedrive::params::cert,
) inherits install_virtualclonedrive::params {
  include staging
  $syspath = $::hardwaremodel ? {
    'x64' => 'C:\windows\sysnative',
    'i686' => 'C:\windows\system32',
  }

  if $::operatingsystem == 'windows' {

    $exe = inline_template('<%= File.basename(@installer) %>')
    $cert = inline_template('<%= File.basename(@certificate) %>')

    acl { "${staging_windir}/install_virtualclonedrive/${exe}":
      purge => false,
      permissions => [ { identity => 'Administrators', rights => ['full'] },],
      }
    acl { "${staging_windir}/install_virtualclonedrive/${cert}":
      purge => false,
      permissions => [ { identity => 'Administrators', rights => ['full'] },],
      }

      staging::file { $exe:
        source => $installer,
      }
      staging::file { $cert:
        source => $certificate,
      }

      exec {'Install Hardware Cert':
        command     => "certutil.exe -addstore \"TrustedPublisher\" \"${staging_windir}/install_virtualclonedrive/${cert}\"",
        path        => $syspath,
        require     => [Staging::File[$cert], Acl["${staging_windir}/install_virtualclonedrive/${cert}"]],
        notify      => Package['VirtualCloneDrive'],
        unless      => "cmd.exe /c dir \"${::programfilesx86}\\Elaborate Bytes\"",
      }

        package { 'VirtualCloneDrive':
          ensure => installed,
          source => "${staging_windir}\\install_virtualclonedrive\\${exe}",
          require => [ Exec['Install Hardware Cert'], Staging::File[$exe], Acl["${staging_windir}/install_virtualclonedrive/${exe}"] ],
          install_options => ['/S', 'noreboot'],
        }
  }
}
