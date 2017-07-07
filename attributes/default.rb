#
# Cookbook: blp-nrpe
# License: Apache 2.0
#
# Copyright 2015-2017, Bloomberg Finance L.P.
#

default['nrpe']['install']['provider'] = 'package'

default['nrpe']['service_name'] = 'nrpe'
default['nrpe']['service_user'] = 'nrpe'
default['nrpe']['service_group'] = 'nrpe'
default['nrpe']['service_home'] = '/var/run/nrpe'

default['nrpe']['config_file'] = '/etc/nagios/nrpe.cfg'
