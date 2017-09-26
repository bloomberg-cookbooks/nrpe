#
# Cookbook: blp-nrpe
# License: Apache 2.0
#
# Copyright 2015-2017, Bloomberg Finance L.P.
#

provides :nrpe_check

property :command_name, String, name_property: true
property :command, String, default: lazy { ::File.join(nrpe_plugins, command_name) }
property :parameters, [String, Array]
property :warning_condition, String
property :critical_condition, String

property :include_path, String, default: '/etc/nagios/nrpe.d'
property :service_name, String, default: lazy { node['nrpe']['service_name'] }
property :service_resource, String, default: lazy { node['nrpe']['service_resource'] }
property :service_user, String, default: lazy { node['nrpe']['service_user'] }
property :service_group, String, default: lazy { node['nrpe']['service_group'] }
property :nrpe_plugins, String, default: lazy { node['nrpe']['nrpe_plugins'] }

def content
  ["command[#{command_name}]=#{command}"].tap do |c|
    c << ['--warning', warning_condition] if warning_condition
    c << ['--critical', critical_condition] if critical_condition
    c << [parameters] if parameters
  end.flatten.join(' ').concat("\n")
end

def config_path
  ::File.join(include_path, "#{command_name}.cfg")
end

action :add do
  directory new_resource.include_path do
    recursive true
    owner new_resource.service_user
    group new_resource.service_group
  end

  file new_resource.config_path do
    content new_resource.content
    owner new_resource.service_user
    group new_resource.service_group
    mode '0440'
    notifies :restart, "#{new_resource.service_resource}[#{new_resource.service_name}]", :delayed
  end
end

action :remove do
  file new_resource.config_path do
    action :delete
    notifies :restart, "#{new_resource.service_resource}[#{new_resource.service_name}]", :delayed
  end
end
