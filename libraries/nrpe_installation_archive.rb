#
# Cookbook: nrpe-ng
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
require 'poise'

module NrpeNgCookbook
  module Provider
    # @provides nrpe_installation
    # @action create
    # @action remove
    # @since 1.0
    class NrpeInstallationArchive < NrpeInstallation
      provides(:archive)

      # Set the default inversion options.
      # @param [Chef::Node] _node
      # @param [Chef::Resource] resource
      # @return [Hash]
      # @api private
      def self.default_inversion_options(_node, resource)
        super.merge(prefix: '/opt/nrpe',
                    version: resource.version,
                    archive_url: 'https://github.com/NagiosEnterprises/nrpe/releases/download/%{version}/nrpe-%{version}.tar.gz',
                    archive_checksum: default_archive_checksum(resource))
      end

      # @return [String]
      # @api private
      def static_folder
        ::File.join(options[:prefix], options[:version])
      end

      # @return [String]
      # @api private
      def nagios_plugins
        options.fetch(:plugins, '/usr/local/lib64/nagios/plugins')
      end

      # @return [String]
      # @api private
      def nrpe_program
        options.fetch(:program, ::File.join(static_folder, 'sbin', 'nrpe'))
      end

      def self.default_archive_checksum(resource)
        case resource.version
        when '3.0.1' then '8f56da2d74f6beca1a04fe04ead84427e582b9bb88611e04e290f59617ca3ea3'
        end
      end

      private

      def install_nrpe
        include_recipe 'build-essential::default'

        if node.platform_family?('debian')
          apt_package 'openssl-devel'
        elsif node.platform_family?('rhel')
          yum_package 'openssl-dev'
        end

        directory ::File.dirname(static_folder) do
          recursive true
        end

        url = options[:archive_url] % {version: options[:version]}
        poise_archive url do
          notifies :run, 'bash[make-nrpe]', :immediately
          destination static_folder
          source_properties checksum: options[:archive_checksum]
          not_if { ::File.exist?(nrpe_program) }
        end

        bash 'make-nrpe' do
          action :nothing
          cwd static_folder
          code './configure && make'
          notifies :create, 'link[/usr/local/sbin/nrpe]'
        end

        link '/usr/local/sbin/nrpe' do
          action :nothing
          to nrpe_program
          only_if { ::File.exist?(nrpe_program) }
        end
      end

      def uninstall_nrpe
        link '/usr/local/sbin/nrpe' do
          action :delete
          to nrpe_program
        end

        directory static_folder do
          action :delete
          recursive true
        end
      end
    end
  end
end
