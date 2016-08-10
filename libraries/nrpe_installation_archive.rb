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
    class NrpeInstallationArchive < Chef::Provider
      include Poise(inversion: :nrpe_installation)
      provides(:archive)
      inversion_attribute('nrpe-ng')

      # Set the default inversion options.
      # @param [Chef::Node] _node
      # @param [Chef::Resource] resource
      # @return [Hash]
      # @api private
      def self.default_inversion_options(_node, resource)
        super.merge(prefix: '/opt/nrpe',
          archive_url: "https://sourceforge.net/projects/nagios/files/nrpe-2.x/nrpe-%{version}/nrpe-%{version}.tar.gz/download",
          archive_checksum: default_archive_checksum(resource))
      end

      def action_create
        url = options[:archive_url] % {version: new_resource.version}
        notifying_block do
          include_recipe 'build-essential::default'

          directory options[:prefix] do
            recursive true
          end

          link '/usr/local/sbin/nrpe' do
            action :nothing
            to nrpe_program
            only_if { ::File.exist?(nrpe_program) }
          end

          bash 'make-nrpe' do
            action :nothing
            cwd nrpe_base
            code './configure && make'
            notifies :create, 'link[/usr/local/sbin/nrpe]'
          end

          poise_archive ::File.basename(url) do
            action :nothing
            path ::File.join(Chef::Config[:file_cache_path], name)
            destination nrpe_base
            notifies :run, 'bash[make-nrpe]', :immediately
          end

          remote_file ::File.basename(url) do
            source url
            checksum options[:archive_checksum]
            path ::File.join(Chef::Config[:file_cache_path], name)
            notifies :unpack, "poise_archive[#{name}]", :immediately
          end
        end
      end

      def action_remove
        notifying_block do
          link '/usr/local/sbin/nrpe' do
            to nrpe_program
            action :delete
          end

          directory nrpe_base do
            recursive true
            action :delete
          end
        end
      end

      # @return [String]
      # @api private
      def nrpe_base
        ::File.join(options[:prefix], new_resource.version)
      end

      # @return [String]
      # @api private
      def nagios_plugins
        options.fetch(:plugins, '/usr/local/lib64/nagios/plugins')
      end

      # @return [String]
      # @api private
      def nrpe_program
        options.fetch(:program, ::File.join(nrpe_base, 'bin', 'nrpe'))
      end

      def self.default_archive_checksum(resource)
        case resource.version
        when '2.1.1' then 'c7daf95ecbf6909724258e55a319057b78dcca23b2a6cc0a640b90c90d4feae3'
        end
      end
    end
  end
end
