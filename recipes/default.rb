#
# Cookbook: nrpe-ng
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
poise_service_user node['nrpe-ng']['service_user'] do
  group node['nrpe-ng']['service_group']
  home node['nrpe-ng']['service_home']
  not_if { user == 'root' }
end

install = nrpe_installation node['nrpe-ng']['service_name'] do
  version ''
  notifies :restart, "nrpe_service[#{name}]", :delayed
end

config = nrpe_config node['nrpe-ng']['service_name'] do
  owner node['nrpe-ng']['service_user']
  group node['nrpe-ng']['service_group']
  node['nrpe-ng']['config'].each_pair { |k, v| send(k, v) }
  notifies :reload, "nrpe_service[#{name}]", :delayed
end

nrpe_service node['nrpe-ng']['service_name'] do
  user node['nrpe-ng']['service_user']
  group node['nrpe-ng']['service_group']
  directory node['nrpe-ng']['service_home']
  config_file config.path
  node['nrpe-ng']['service'].each_pair { |k, v| send(k, v) }
end
