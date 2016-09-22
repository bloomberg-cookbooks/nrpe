#
# Cookbook: nrpe-ng
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
require 'poise'

module NrpeNgCookbook
  module Resource
    # A `nrpe_check` resource which manages the configuration of an
    # NRPE daemon check.
    # @provides nrpe_check
    # @action add
    # @action remove
    # @since 1.0
    class NrpeCheck < Chef::Resource
      include Poise(parent: :nrpe_service)
      provides(:nrpe_check)
      actions(:add, :remove)
      default_action(:add)

      # @!attribute command_name
      # @return [String]
      attribute(:command_name, kind_of: String, name_attribute: true)
      # @!attribute command
      # @return [String]
      attribute(:command, kind_of: String, default: lazy { default_command })
      # @!attribute parameters
      # @return [Array]
      attribute(:parameters, kind_of: [String, Array])
      # @!attribute warning_condition
      # @return [String]
      attribute(:warning_condition, kind_of: String)
      # @!attribute critical_condition
      # @return [String]
      attribute(:critical_condition, kind_of: String)
      # @!attribute plugin_path
      # @return [String]
      attribute(:plugin_path, kind_of: String, default: lazy { parent.plugin_path })

      # @return [String]
      # @api private
      def default_command
        ::File.join(plugin_path, command_name)
      end

      # @return [String]
      def content
        ["command[#{command_name}]=#{command}"].tap do |c|
          c << ['--warning', warning_condition] if warning_condition
          c << ['--critical', critical_condition] if critical_condition
          c << [parameters] if parameters
        end.flatten.join(' ').concat("\n")
      end
    end
  end

  module Provider
    # @provides nrpe_check
    # @action add
    # @action remove
    # @since 1.0
    class NrpeCheck < Chef::Provider
      include Poise
      provides(:nrpe_check)

      def action_add
        notifying_block do
          file ::File.join(new_resource.parent.include_path, "#{new_resource.command_name}.cfg") do
            content new_resource.content
            owner new_resource.parent.user
            group new_resource.parent.group
            mode '0440'
            notifies :reload, "nrpe_service[#{new_resource.parent.service_name}]", :delayed
          end
        end
      end

      def action_remove
        notifying_block do
          file ::File.join(new_resource.parent.include_path, "#{new_resource.command_name}.cfg") do
            action :delete
            notifies :reload, "nrpe_service[#{new_resource.parent.service_name}]", :delayed
          end
        end
      end
    end
  end
end
