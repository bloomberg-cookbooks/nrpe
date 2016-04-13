#
# Cookbook: nrpe-ng
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
require 'poise'

module NrpeNgCookbook
  module Provider
    # A `nrpe_installation` provider which provides package
    # installation of NRPE resource.
    # @provides nrpe_installation
    # @action create
    # @action delete
    # @since 1.0
    class NrpeInstallationPackage < Chef::Provider
      include Poise(inversion: :nrpe_installation)
      provides(:package)
      inversion_attribute 'nrpe-ng'

      # @api private
      def self.provides_auto?
        true
      end

      # Set the default inversion options.
      # @param [Chef::Node] _node
      # @param [Chef::Resource] _resource
      # @return [Hash]
      # @api private
      def self.default_inversion_options(_node, _resource)
        super.merge(
          version: resource.version,
          package_name: default_package_name
        )
      end

      def action_create
        notifying_block do
          package options[:package_name] do
            source options[:package_source]
            checksum options[:package_checksum]
            version options[:version]
            action :upgrade
          end
        end
      end

      def action_delete
        notifying_block do
          package options[:package_name] do
            source options[:package_source]
            checksum options[:package_checksum]
            version options[:version]
            action :uninstall
          end
        end
      end

      # @return [String]
      def nrpe_program
        options.fetch(:program, '/usr/sbin/nrpe')
      end

      private

      # @api private
      def default_package_name
        return 'nagios-plugins' if node.platform_family?('debian')
        'nagios'
      end
    end
  end
end
