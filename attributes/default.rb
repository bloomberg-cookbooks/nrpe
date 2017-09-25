#
# Cookbook: blp-nrpe
# License: Apache 2.0
#
# Copyright 2015-2017, Bloomberg Finance L.P.
#

default['nrpe']['provider'] = 'package'
default['nrpe']['program'] = '/usr/sbin/nrpe'
default['nrpe']['config_file'] = '/etc/nagios/nrpe.cfg'
default['nrpe']['config'] = {}

default['nrpe']['service_name'] = 'nrpe'
default['nrpe']['service_user'] = 'nrpe'
default['nrpe']['service_group'] = 'nrpe'
default['nrpe']['service_home'] = '/var/run/nrpe'

default['nrpe']['service_resource'] = 'poise_service'

if platform_family? 'debian'
  default['nrpe']['nrpe_plugins'] = '/usr/lib/nagios/plugins'

  default['nrpe']['package']['packages'] = %w(nagios-nrpe-server nagios-plugins-basic)
elsif platform_family? 'rhel'
  default['nrpe']['nrpe_plugins'] = '/usr/lib64/nagios/plugins'

  default['nrpe']['package']['packages'] = %w(nrpe nagios-plugins)
end

default['nrpe']['archive']['prefix'] = '/opt/nrpe'
default['nrpe']['archive']['version'] = '3.0.1'
default['nrpe']['archive']['checksum'] = '8f56da2d74f6beca1a04fe04ead84427e582b9bb88611e04e290f59617ca3ea3'
default['nrpe']['archive']['url'] = 'https://github.com/NagiosEnterprises/nrpe/releases/download/%{version}/nrpe-%{version}.tar.gz'
