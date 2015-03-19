class install_virtualclonedrive (
  $installer = $install_virtualclonedrive::params::installer,
) inherits install_virtualclonedrive::params {
  include staging

  if $::operatingsystem == 'windows' {

    $exe = inline_template('<%= File.basename(@installer) %>')

    acl { "${staging_windir}/install_virtualclonedrive/${exe}":
      purge => false,
      permissions => [ { identity => 'Administrators', rights => ['full'] },],
      }

      staging::file { $exe:
        source => $installer,
        }


        package { 'VirtualCloneDrive':
          ensure => installed,
          source => "${staging_windir}\\install_virtualclonedrive\\${exe}",
          require => [ Staging::File[$exe], Acl["${staging_windir}/install_virtualclonedrive/${exe}"] ],
          install_options => '/S /noreboot',
          }
  }
}
