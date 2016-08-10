#
# Cookbook: nrpe-ng
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
poise_service_user node['nrpe-ng']['nrpe']['user'] do
  group node['nrpe-ng']['nrpe']['group']
  home node['nrpe-ng']['nrpe']['directory']
  not_if { node['nrpe-ng']['service_user'] == 'root' }
end

install = nrpe_installation node['nrpe-ng']['service_name'] do
  notifies :reload, "nrpe_service[#{name}]", :delayed
end

config = nrpe_config node['nrpe-ng']['service_name'] do |r|
  node['nrpe-ng']['nrpe'].each_pair { |k, v| r.send(k, v) }
  notifies :reload, "nrpe_service[#{name}]", :delayed
end

nrpe_service node['nrpe-ng']['service_name'] do
  program install.nrpe_program
  plugin_path install.nagios_plugins
end
