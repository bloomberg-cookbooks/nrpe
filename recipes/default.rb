#
# Cookbook: nrpe-ng
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
poise_service_user node['nrpe']['service_user'] do
  group node['nrpe']['service_group']
  not_if { node['nrpe']['service_user'] == 'root' }
end

config = nrpe_config node['nrpe']['service_name'] do |r|
  owner node['nrpe']['service_user']
  group node['nrpe']['service_group']

  if node['nrpe']['config']
    node['nrpe']['config'].each_pair { |k, v| r.send(k, v) }
  end
  notifies :reload, "nrpe_service[#{name}]", :delayed
end

install = nrpe_installation node['nrpe']['service_name'] do |r|
  if node['nrpe']['install']
    node['nrpe']['install'].each_pair { |k, v| r.send(k, v) }
  end

  notifies :reload, "nrpe_service[#{name}]", :delayed
end

nrpe_service node['nrpe']['service_name'] do |r|
  user node['nrpe']['service_user']
  group node['nrpe']['service_group']
  config_file config.path
  program install.nrpe_program

  if node['nrpe']['service']
    node['nrpe']['service'].each_pair { |k, v| r.send(k, v) }
  end
end
