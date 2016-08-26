#
# Cookbook: nrpe-ng
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
require 'poise'

module NrpeNgCookbook
  module Resource
    # A `nrpe_config` fused resource which manages the NRPE service
    # configuration file.
    # @provides nrpe_config
    # @action create
    # @action remove
    # @since 1.0
    class NrpeConfig < Chef::Resource
      include Poise(fused: true)
      provides(:nrpe_config)

      # @!attribute path
      # @return [String]
      attribute(:path, kind_of: String, name_attribute: true)
      # @!attribute owner
      # @return [String]
      attribute(:owner, kind_of: String, default: 'nrpe')
      # @!attribute group
      # @return [String]
      attribute(:group, kind_of: String, default: 'nrpe')
      # @!attribute mode
      # @return [String]
      attribute(:mode, kind_of: String, default: '0440')

      # @see https://github.com/NagiosEnterprises/nrpe/blob/master/sample-config/nrpe.cfg.in
      attribute(:allowed_hosts,
                kind_of: [Array, String],
                required: true,
                coerce: proc { |v| [v].flatten.join(',') })
      attribute(:allow_bash_command_substitution, equal_to: [true, false], default: false)
      attribute(:command_prefix, kind_of: String)
      attribute(:command_timeout, kind_of: Integer, default: 60)
      attribute(:connection_timeout, kind_of: Integer, default: 300)
      attribute(:debug, equal_to: [true, false], default: false)
      attribute(:dont_blame_nrpe, equal_to: [true, false], default: false)
      attribute(:include_dir, kind_of: String, default: '/etc/nrpe.d')
      attribute(:listen_queue_size, kind_of: Integer, default: 5)
      attribute(:log_facility, kind_of: String, default: 'daemon')
      attribute(:server_address, kind_of: String, default: '127.0.0.1')
      attribute(:server_port, kind_of: Integer, default: 5_666)
      attribute(:nrpe_user, kind_of: String, default: lazy { owner })
      attribute(:nrpe_group, kind_of: String, default: lazy { group })

      # @return [Hash]
      def variables
        {allowed_hosts: allowed_hosts}.tap do |h|
          h[:debug] = debug ? 1 : 0
          h[:dont_blame_nrpe] = dont_blame_nrpe ? 1 : 0
          h[:allow_bash_command_substitution] = allow_bash_command_substitution ? 1 : 0
          h[:log_facility] = log_facility if log_facility
          h[:command_prefix] = command_prefix if command_prefix
          h[:command_timeout] = command_timeout if command_timeout
          h[:include_dir] = include_dir if include_dir
          h[:server_address] = server_address if server_address
          h[:server_port] = server_port if server_port
          h[:nrpe_user] = nrpe_user if nrpe_user
          h[:nrpe_group] = nrpe_group if nrpe_group
        end
      end

      action(:create) do
        notifying_block do
          directory ::File.dirname(new_resource.path) do
            recursive true
          end

          template new_resource.path do
            source 'nrpe.cfg.erb'
            owner new_resource.owner
            group new_resource.group
            mode new_resource.mode
            variables(variables: new_resource.variables)
          end
        end
      end

      action(:remove) do
        notifying_block do
          file new_resource.path do
            action :delete
          end
        end
      end
    end
  end
end
