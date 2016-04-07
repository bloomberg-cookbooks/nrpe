#
# Cookbook: nrpe-ng
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
require 'poise_service/service_mixin'

module NrpeNgCookbook
  module Resource
    # A `nrpe_service` resource which manages NRPE daemon as a system
    # service using poise-service.
    # @provides nrpe_service
    # @action enable
    # @action disable
    # @action start
    # @action stop
    # @action restart
    # @action reload
    # @since 1.0
    class NrpeService < Chef::Resource
      include Poise(container: true)
      provides(:nrpe_service)
      include PoiseService::ServiceMixin

      # @!attribute user
      # @return [String]
      attribute(:user, kind_of: String, default: 'nrpe')
      # @!attribute group
      # @return [String]
      attribute(:group, kind_of: String, default: 'nrpe')
      # @!attribute config_file
      # @return [String]
      attribute(:config_file, kind_of: String, default: '/etc/nrpe/nrpe.cfg')
      # @!attribute include_dir
      # @return [String]
      attribute(:include_path, kind_of: String)
      # @!attribute plugin_dir
      # @return [String]
      attribute(:plugin_path, kind_of: String, default: '/etc/nrpe/nrpe.d')
      # @!attribute program
      # @return [String]
      attribute(:program, kind_of: String, default: '/usr/sbin/nagios')

      # @return [String]
      def command
        "#{program} -c #{config_file} -d"
      end
    end
  end

  module Provider
    # @provides nrpe_service
    # @action enable
    # @action disable
    # @action start
    # @action stop
    # @action restart
    # @action reload
    # @since 1.0
    class NrpeService < Chef::Provider
      include Poise
      provides(:nrpe_service)
      include PoiseService::ServiceMixin

      def action_enable
        notifying_block do
          directory new_resource.plugin_path do
            recursive true
          end
        end
        super
      end

      # @api private
      def service_options(service)
        service.command(new_resource.command)
        service.directory(new_resource.directory)
        service.user(new_resource.user)
        service.restart_on_update(true)
        service.options(:systemd, template: 'consul:systemd.service.erb')
        service.options(:sysvinit, template: 'consul:sysvinit.service.erb')

        if node.platform_family?('rhel') && node.platform_version.to_i == 6
          service.provider(:sysvinit)
        end
      end
    end
  end
end
