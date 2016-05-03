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
    # @action delete
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
        super.merge(
          archive_url: "http://www.nagios-plugins.org/download/nagios-plugins-%{version}.tar.gz",
          archive_checksum: archive_checksum(resource),
          extract_to: '/opt/nrpe'
        )
      end

      def action_create
        url = options[:archive_url] % {version: new_resource.version}
        notifying_block do
          include_recipe 'build-essential::default'

          directory options[:extract_to] do
            recursive true
          end

          poise_archive ::File.join(Chef::Config[:file_cache_path], ::File.basename(url)) do
            action :nothing
            destination ::File.join(options[:extract_to], new_resource.version)
            not_if { ::File.exist?(destination) }
          end

          remote_file ::File.join(Chef::Config[:file_cache_path], ::File.basename(url)) do
            source url
            checksum options[:archive_checksum]
            notifies :unpack, "poise_archive[#{name}]", :immediately
          end

          link "#{options[:symlink_target]} -> #{nrpe_program}" do
            to nrpe_program
            only_if { ::File.exist?(to) }
            only_if { options[:symlink_target] }
          end
        end
      end

      def action_delete
        notifying_block do
          link "#{options[:symlink_target]} -> #{nrpe_program}" do
            action :delete
            to nrpe_program
            only_if { ::File.exist?(to) }
            only_if { options[:symlink_target] }
          end

          directory ::File.join(options[:extract_to], new_resource.version) do
            recursive true
            action :delete
          end
        end
      end

      # @return [String]
      # @api private
      def nagios_program
        options.fetch(:program, '/usr/local/lib64/nagios/plugins')
      end

      # @return [String]
      # @api private
      def nrpe_program
        options.fetch(:program, '/usr/local/sbin/nrpe')
      end

      def self.archive_checksum(resource)
        case resource.version
        when '2.1.1' then 'c7daf95ecbf6909724258e55a319057b78dcca23b2a6cc0a640b90c90d4feae3'
        end
      end
    end
  end
end
