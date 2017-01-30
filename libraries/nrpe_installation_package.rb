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
    # @action remove
    # @since 1.0
    class NrpeInstallationPackage < NrpeInstallation
      provides(:package)

      # @param [Chef::Node] _node
      # @param [Chef::Resource] _resource
      # @api private
      def self.provides_auto?(_node, _resource)
        true
      end

      # Set the default inversion options.
      # @param [Chef::Node] node
      # @param [Chef::Resource] new_resource
      # @return [Hash]
      # @api private
      def self.default_inversion_options(node, new_resource)
        package_version = if new_resource.version.nil? && new_resource.version.empty?
                            default_package_version(node)
                          else
                            new_resource.version
                          end
        super.merge(package_name: default_package_name(node),
                    version: package_version)
      end

      # @return [String]
      # @api private
      def nagios_plugins
        if node.platform_family?('debian')
          options.fetch(:plugins, '/usr/lib/nagios/plugins')
        else
          options.fetch(:plugins, '/usr/lib64/nagios/plugins')
        end
      end

      # @return [String]
      # @api private
      def nrpe_program
        options.fetch(:program, '/usr/sbin/nrpe')
      end

      # @param [Chef::Node] node
      # @return [Array]
      # @api private
      def self.default_package_name(node)
        case node['platform']
        when 'centos', 'redhat' then %w{nrpe}
        when 'ubuntu' then %w{nagios-nrpe-server}
        end
      end

      # @param [Chef::Node] node
      # @return [Array]
      # @api private
      def self.default_package_version(node)
        case node['platform']
        when 'redhat', 'centos'
          case node['platform_version'].to_i
          when 5 then %w{2.15-7.el5}
          when 6 then %w{2.15-7.el6}
          when 7 then %w{2.15-7.el7}
          end
        when 'ubuntu'
          case node['platform_version'].to_i
          when 12 then %w{2.12-5ubuntu1}
          when 14 then %w{2.15-0ubuntu1}
          when 16 then %w{2.15-1ubuntu1}
          end
        end
      end

      private

      def install_nrpe
        system_package_name = options[:package_name]
        system_package_version = options[:version]
        system_package_url = if options[:package_url] # ~FC023
                               remote_file ::File.basename(options[:package_url]) do
                                 path ::File.join(Chef::Config[:file_cache_path], name)
                                 source options[:package_url]
                                 backup false
                               end.path
                             end

        init_file = file '/etc/init.d/nrpe' do
          action :nothing
        end

        if node.platform_family?('debian')
          dpkg_autostart 'nagios-nrpe-server' do
            action :nothing
            allow false
          end
        end

        package system_package_name do
          notifies :delete, init_file, :immediately
          version system_package_version if system_package_version
          source system_package_url if system_package_url
          if node.platform_family?('debian')
            notifies :create, 'dpkg_autostart[nagios-nrpe-server]', :immediately
            options '-o Dpkg::Options::=--path-exclude=/etc/nagios/*'
          end
        end
      end

      def uninstall_nrpe
        package options[:package_name] do
          if node.platform_family?('debian')
            action :purge
          else
            action :remove
          end
        end
      end
    end
  end
end
