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

      # @param [Chef::Node] _node
      # @param [Chef::Resource] _resource
      # @api private
      def self.provides_auto?(_node, _resource)
        true
      end

      # Set the default inversion options.
      # @param [Chef::Node] node
      # @param [Chef::Resource] resource
      # @return [Hash]
      # @api private
      def self.default_inversion_options(node, resource)
        package = if node.platform_family?('debian')
                    %w{nagios-nrpe-server nagios-plugins}
                  else
                    %w{nrpe nagios-plugins}
                  end
        super.merge(version: resource.version, package: package)
      end

      def action_create
        notifying_block do
          # @see {NrpeNgCookbook::Resource::NrpeService}
          init_file = file '/etc/init.d/nrpe' do
            action :nothing
          end

          package options[:package] do
            notifies :delete, init_file, :immediately
            version new_resource.version
            if node.platform_family?('debian')
              options '-o Dpkg::Options::=--path-exclude=/etc/*'
            end
          end
        end
      end

      def action_delete
        notifying_block do
          package options[:package] do
            if node.platform_family?('debian')
              action :purge
            else
              action :remove
            end
          end
        end
      end

      # @return [String]
      def nrpe_program
        options.fetch(:program, '/usr/sbin/nrpe')
      end
    end
  end
end
