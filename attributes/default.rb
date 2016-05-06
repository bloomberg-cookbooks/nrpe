#
# Cookbook: nrpe-ng
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
default['nrpe-ng']['nrpe']['allowed_hosts'] = %w{127.0.0.1}
default['nrpe-ng']['nrpe']['config_path'] = '/etc/nagios/nrpe.cfg'
default['nrpe-ng']['nrpe']['service_name'] = 'nrpe'
default['nrpe-ng']['nrpe']['user'] = 'nrpe'
default['nrpe-ng']['nrpe']['group'] = 'nrpe'
default['nrpe-ng']['nrpe']['directory'] = '/var/lib/nrpe'
