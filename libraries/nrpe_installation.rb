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
    # @action delete
    # @since 1.0
    class NrpeInstallation < Chef::Resource
      include Poise(inversion: true)
      provides(:nrpe_installation)
      actions(:create, :delete)
      default_action(:create)

      # @!attribute version
      # @return [String]
      attribute(:version, kind_of: String, default: '')

      # @return [String]
      def nrpe_program
        @program ||= provider_for_action(:nrpe_program).nrpe_program
      end
    end
  end
end
