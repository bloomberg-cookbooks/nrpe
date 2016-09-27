#
# Cookbook: nrpe-ng
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
require 'poise'

module NrpeNgCookbook
  module Resource
    # A `nrpe_installation` resource which manages NRPE installations.
    # @provides nrpe_installation
    # @action create
    # @action remove
    # @since 1.0
    class NrpeInstallation < Chef::Resource
      include Poise(container: true, inversion: true)
      provides(:nrpe_installation)
      actions(:create, :remove)
      default_action(:create)

      # @!attribute version
      # The version of NRPE to install on the system.
      # @return [String, Array, NilClass]
      attribute(:version, kind_of: String, name_attribute: true)

      # @return [String]
      def nagios_plugins
        provider_for_action(:nagios_plugins).nagios_plugins
      end

      # @return [String]
      def nrpe_program
        provider_for_action(:nrpe_program).nrpe_program
      end
    end
  end

  module Provider
    # @abstract
    # @since 1.0
    class NrpeInstallation < Chef::Provider
      include Poise(inversion: :nrpe_installation)
      inversion_attribute('nrpe-ng')

      # Set the default inversion options.
      # @private
      def self.default_inversion_options(_node, new_resource)
        super.merge(version: new_resource.version)
      end

      def action_create
        notifying_block { install_nrpe }
      end

      def action_remove
        notifying_block { uninstall_nrpe }
      end

      # @abstract
      def nagios_plugins
        raise NotImplementedError
      end

      # @abstract
      def nrpe_program
        raise NotImplementedError
      end

      private

      # @abstract
      def install_nrpe
        raise NotImplementedError
      end

      # @abstract
      def uninstall_nrpe
        raise NotImplementedError
      end
    end
  end
end
