#
# Cookbook: nrpe-ng
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
require 'poise'

module NrpeNgCookbook
  module Resource
    # @provides nrpe_config
    # @action create
    # @action delete
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
      attribute(:mode, kind_of: String, default: '0444')

      # @see https://github.com/NagiosEnterprises/nrpe/blob/master/sample-config/nrpe.cfg.in
      attribute(:allowed_hosts, kind_of: Array, required: true)
      attribute(:command_prefix, kind_of: String)
      attribute(:command_timeout, kind_of: Integer, default: 60)
      attribute(:connection_timeout, kind_of: Integer, default: 300)
      attribute(:debug, equal_to: [true, false], default: false)
      attribute(:dont_blame_nrpe, equal_to: [true, false], default: false)
      attribute(:include_dir, kind_of: String, default: '/etc/nrpe/nrpe.d')
      attribute(:log_facility, kind_of: String, default: 'daemon')
      attribute(:server_address, kind_of: Integer, default: '127.0.0.1')
      attribute(:server_port, kind_of: Integer, default: 5_666)
      attribute(:nrpe_user, kind_of: String, default: lazy { owner })
      attribute(:nrpe_group, kind_of: String, default: lazy { group })

      # @return [Hash]
      def variables
      end

      action(:create) do
        notifying_block do
          template new_resource.path do
            source 'nrpe.cfg.erb'
            owner new_resource.owner
            group new_resource.group
            mode new_resource.mode
            variables(variables: new_resource.variables)
          end
        end
      end

      action(:delete) do
        notifying_block do
          file new_resource.path do
            action :delete
          end
        end
      end
    end
  end
end
