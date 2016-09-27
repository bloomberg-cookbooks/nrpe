#
# Cookbook: nrpe-ng
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
default['nrpe-ng']['provider'] = 'auto'

default['nrpe-ng']['service_name'] = 'nrpe'
default['nrpe-ng']['service_user'] = 'nrpe'
default['nrpe-ng']['service_group'] = 'nrpe'
default['nrpe-ng']['service_home'] = '/var/run/nrpe'
default['nrpe-ng']['config']['allowed_hosts'] = %w{127.0.0.1}
default['nrpe-ng']['config']['path'] = '/etc/nagios/nrpe.cfg'

default['nrpe-ng']['service'] = {}
