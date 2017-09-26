#
# Cookbook: blp-nrpe
# License: Apache 2.0
#
# Copyright 2015-2017, Bloomberg Finance L.P.
#

provides :nrpe_config

property :path, String, name_property: true
property :owner, String, default: lazy { node['nrpe']['service_user'] }
property :group, String, default: lazy { node['nrpe']['service_group'] }
property :mode, String, default: '0440'

# @see https://github.com/NagiosEnterprises/nrpe/blob/master/sample-config/nrpe.cfg.in
property :allowed_hosts,
         [Array, String],
         default: ['127.0.0.1', '::1'],
         coerce: proc { |v| [v].flatten.join(',') }
property :allow_bash_commands, [true, false, 0, 1], default: false, coerce: proc { |v| v.to_i }
property :command_prefix, String
property :command_timeout, Integer, default: 60
property :connection_timeout, Integer, default: 300
property :debug, [true, false, 0, 1], default: false, coerce: proc { |v| v.to_i }
property :dont_blame_nrpe, [true, false, 0, 1], default: false, coerce: proc { |v| v.to_i }
property :include_dir, String, default: '/etc/nagios/nrpe.d'
property :pid_file, String, default: '/var/run/nrpe/nrpe.pid'
property :listen_queue_size, Integer, default: 5
property :log_facility, String, default: 'daemon'
property :server_address, String, default: '127.0.0.1'
property :server_port, Integer, default: 5_666
property :nrpe_user, String, default: lazy { owner }
property :nrpe_group, String, default: lazy { group }

def content
  properties = self.class.properties(false).values.reject { |v| %i(path owner group mode).include?(v.name) }

  properties.map do |p|
    next unless p.get(self)
    "#{p.name}=#{p.get(self)}"
  end.compact.join("\n")
end

action :create do
  directory ::File.dirname(new_resource.path) do
    recursive true
  end

  file new_resource.path do
    content new_resource.content
    owner new_resource.owner
    group new_resource.group
    mode new_resource.mode
  end
end

action :delete do
  file new_resource.path do
    action :delete
  end
end
