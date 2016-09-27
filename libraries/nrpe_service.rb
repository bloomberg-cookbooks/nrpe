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
      include Poise(parent: :nrpe_installation, container: true)
      provides(:nrpe_service)
      include PoiseService::ServiceMixin

      # @!attribute user
      # @return [String]
      attribute(:user, kind_of: String, default: 'nrpe')
      # @!attribute group
      # @return [String]
      attribute(:group, kind_of: String, default: 'nrpe')
      # @!attribute directory
      # @return [String]
      attribute(:directory, kind_of: String, default: '/var/run/nrpe')
      # @!attribute config_file
      # @return [String]
      attribute(:config_file, kind_of: String, default: '/etc/nagios/nrpe.cfg')
      # @!attribute include_path
      # @return [String]
      attribute(:include_path, kind_of: String, default: '/etc/nrpe.d')
      # @!attribute include_path
      # @return [String]
      attribute(:plugin_path, kind_of: String, default: lazy { parent.nagios_plugins })
      # @!attribute command
      # @return [String]
      attribute(:command, kind_of: String, default: lazy { "#{parent.nrpe_program} -c #{config_file} -d" })
    end
  end

  module Provider
    # A `nrpe_service` provider which manages the NRPE daemon as a
    # system service.
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
          [new_resource.include_path, new_resource.directory].each do |dirname|
            directory dirname do
              recursive true
              owner new_resource.user
              group new_resource.group
            end
          end
        end
        super
      end

      # @api private
      def service_options(service)
        service.command(new_resource.command)
        service.directory(new_resource.directory)
        service.user(new_resource.user)
        service.options(:systemd, template: 'nrpe-ng:systemd.service.erb')
        service.options(:sysvinit, template: 'nrpe-ng:sysvinit.service.erb')
        service.options(:upstart, template: 'nrpe-ng:upstart.service.erb')
        service.environment('CONFIG_FILE' => new_resource.config_file,
          'DIRECTORY'   => new_resource.directory,
          'PROGRAM'     => new_resource.parent.nrpe_program)
      end
    end
  end
end
