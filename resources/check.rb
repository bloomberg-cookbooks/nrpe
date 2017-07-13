#
# Cookbook: blp-nrpe
# License: Apache 2.0
#
# Copyright 2015-2017, Bloomberg Finance L.P.
#

include NrpeCookbook::Resource

provides :nrpe_check

property :command_name, String, name_property: true
property :command, String, default: lazy { ::File.join(nrpe_plugins, command_name) }
property :parameters, [String, Array]
property :warning_condition, String
property :critical_condition, String

# TODO: Move into some kind of helpers and include into resource.
property :include_path, String, default: '/etc/nagios/nrpe.d'
property :service_name, String, default: 'nrpe'
property :service_user, String, default: 'nrpe'
property :service_group, String, default: 'nrpe'
property :nrpe_plugins, String, default: lazy { default_nrpe_plugins }

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

load_current_value do
  current_value_does_not_exist! if node.run_state['nrpe'].nil?
  service_name node.run_state['nrpe']['service_name']
  service_user node.run_state['nrpe']['service_user']
  service_group node.run_state['nrpe']['service_group']
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
    notifies :reload, "poise_service[#{new_resource.service_name}]", :delayed
  end
end

action :remove do
  file new_resource.config_path do
    action :delete
    notifies :reload, "poise_service[#{new_resource.service_name}]", :delayed
  end
end
