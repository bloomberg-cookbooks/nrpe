#
# Cookbook: blp-nrpe
# License: Apache 2.0
#
# Copyright 2015-2017, Bloomberg Finance L.P.
#

poise_service_user node['nrpe']['service_user'] do
  group node['nrpe']['service_group']
  home node['nrpe']['service_home']
  not_if { user == 'root' }
end

directory node['nrpe']['service_home'] do
  recursive true
  owner node['nrpe']['service_user']
  group node['nrpe']['service_group']
  mode '0775'
end

install = nrpe_installation node['nrpe']['service_name'] do
  notifies :restart, "poise_service[#{name}]", :delayed
end

config = nrpe_config node['nrpe']['service_name'] do
  path node['nrpe']['config_file']
  owner node['nrpe']['service_user']
  group node['nrpe']['service_group']
  node['nrpe']['config'].each_pair { |k, v| send(k, v) }
end

poise_service node['nrpe']['service_name'] do
  command "#{install.nrpe_program} -c #{config.path} -d"
  user node['nrpe']['service_user']
  directory node['nrpe']['service_home']
  options :systemd, template: 'blp-nrpe:systemd.service.erb'
  options :sysvinit, template: 'blp-nrpe:sysvinit.sh.erb'
  options :upstart, template: 'blp-nrpe:upstart.conf.erb'
  environment DIRECTORY: node['nrpe']['service_home'],
              CONFIG_FILE: config.path,
              PROGRAM: install.nrpe_program
end
