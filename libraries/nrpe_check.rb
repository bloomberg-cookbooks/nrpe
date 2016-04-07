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
      attribute(:command, kind_of: String, required: true)
      # @!attribute parameters
      # @return [Array]
      attribute(:parameters, kind_of: Array)
      # @!attribute warning_condition
      # @return [String]
      attribute(:warning_condition, kind_of: String)
      # @!attribute critical_condition
      # @return [String]
      attribute(:critical_condition, kind_of: String)

      # @return [String]
      def content
        ["command[#{command_name}]=/usr/lib64/nagios/plugins/#{command}"].tap do |c|
          c << ['--warning', warning_condition] if warning_condition
          c << ['--critical', critical_condition] if critical_condition
          c << parameters if parameters
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
        plugin_path = new_resource.parent.plugin_path
        notifying_block do
          file ::File.join(plugin_path, "#{new_resource.command_name}.cfg") do
            content new_resource.content
            owner new_resource.parent.user
            group new_resource.parent.group
            mode '0444'
          end
        end
      end

      def action_remove
        plugin_path = new_resource.parent.plugin_path
        notifying_block do
          file ::File.join(plugin_path, "#{new_resource.command_name}.cfg") do
            action :delete
          end
        end
      end
    end
  end
end
