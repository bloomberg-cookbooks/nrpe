#
# Cookbook: blp-nrpe
# License: Apache 2.0
#
# Copyright 2015-2017, Bloomberg Finance L.P.
#

provides :nrpe_installation_archive
provides :nrpe_installation do |node|
  node['nrpe']['provider'] == 'archive'
end

property :version, String, default: lazy { node['nrpe']['archive']['version'] }
property :prefix, String, default: lazy { node['nrpe']['archive']['prefix'] }
property :archive_url, String, default: lazy { node['nrpe']['archive']['url'] }
property :archive_checksum, String, default: lazy { node['nrpe']['archive']['checksum'] }
property :service_user, String, default: lazy { node['nrpe']['service_user'] }
property :service_group, String, default: lazy { node['nrpe']['service_group'] }
property :nrpe_plugins, String, default: lazy { node['nrpe']['nrpe_plugins'] }
property :nrpe_program, String, default: lazy { ::File.join(static_folder, 'sbin', 'nrpe') }

def static_folder
  ::File.join(prefix, version)
end

action :install do
  include_recipe 'build-essential::default'

  apt_package 'openssl-devel' if platform_family? 'debian'
  yum_package 'openssl-dev' if platform_family? 'rhel'

  directory new_resource.nrpe_plugins do
    recursive true
    owner new_resource.service_user
    group new_resource.service_group
    mode '0775'
  end

  directory ::File.dirname(new_resource.static_folder) do
    recursive true
  end

  url = format(new_resource.archive_url, new_resource.version)
  poise_archive url do
    notifies :run, 'bash[make-nrpe]', :immediately
    destination new_resource.static_folder
    source_properties checksum: new_resource.archive_checksum
    not_if { ::File.exist?(new_resource.nrpe_program) }
  end

  bash 'make-nrpe' do
    action :nothing
    cwd new_resource.static_folder
    code './configure && make'
    notifies :create, 'link[/usr/local/sbin/nrpe]'
  end

  link '/usr/local/sbin/nrpe' do
    action :nothing
    to new_resource.nrpe_program
    only_if { ::File.exist?(new_resource.nrpe_program) }
  end
end

action :uninstall do
  link '/usr/local/sbin/nrpe' do
    action :delete
    to new_resource.nrpe_program
  end

  directory new_resource.static_folder do
    action :delete
    recursive true
  end
end
