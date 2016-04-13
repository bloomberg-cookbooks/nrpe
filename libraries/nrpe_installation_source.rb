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
    class NrpeInstallationSource < Chef::Provider
      include Poise(inversion: :nrpe_installation)
      provides(:source)
      inversion_attribute 'nrpe-ng'

      # Set the default inversion options.
      # @param [Chef::Node] _node
      # @param [Chef::Resource] _resource
      # @return [Hash]
      # @api private
      def self.default_inversion_options(node, resource)
        super.merge(
          version: resource.version,
          archive_url: default_archive_url % {version: resource.version},
          archive_basename: "nagios-plugins-%{version}.tar.gz" % {version: resource.version},
          archive_checksum: archive_checksum(resource),
          extract_to: '/opt/nrpe'
        )
      end

      def action_create
        notifying_block do
          include_recipe 'build-essential::default'

          directory ::File.join(options[:extract_to], new_resource.version) do
            recursive true
          end

          poise_archive options[:archive_basename] do
            action :nothing
            destination ::File.join(options[:extract_to], new_resource.version)
            not_if { ::File.exist?(nrpe_program) }
          end

          remote_file options[:archive_basename] do
            path ::File.join(Chef::Config[:file_cache_path], options[:archive_basename])
            source options[:archive_url]
            checksum options[:archive_checksum]
            notifies :unpack, "poise_archive[#{name}]", :immediately
          end
        end
      end

      def action_delete
        notifying_block do
          directory options[:extract_to] do
            recursive true
            action :delete
          end
        end
      end

      def self.default_archive_url
        "http://www.nagios-plugins.org/download/nagios-plugins-%{version}.tar.gz" # rubocop:disable Style/StringLiterals
      end

      def self.archive_checksum(resource)
        case resource.version
        when '2.1.1' then 'c7daf95ecbf6909724258e55a319057b78dcca23b2a6cc0a640b90c90d4feae3'
        end
      end

      def nrpe_program
        ::File.join(options[:extract_to], 'bin', 'nrpe')
      end
    end
  end
end
