#
# Cookbook: blp-nrpe
# License: Apache 2.0
#
# Copyright 2015-2017, Bloomberg Finance L.P.
#

provides :nrpe_installation_package
provides :nrpe_installation do |node|
  node['nrpe']['provider'] == 'package'
end

property :service_user, String, default: lazy { node['nrpe']['service_user'] }
property :service_group, String, default: lazy { node['nrpe']['service_group'] }
property :nrpe_program, String, default: lazy { node['nrpe']['program'] }
property :nrpe_plugins, String, default: lazy { node['nrpe']['nrpe_plugins'] }
property :packages, [String, Array], default: lazy { node['nrpe']['package']['packages'] }

action :install do
  directory new_resource.nrpe_plugins do
    recursive true
    owner new_resource.service_user
    group new_resource.service_group
    mode '0775'
  end

  file '/etc/init.d/nrpe' do
    action :nothing
  end

  if platform_family? 'debian'
    cookbook_file '/etc/dpkg/dpkg.cfg.d/nagios-nrpe-server' do
      source 'nagios-nrpe-server.conf'
      owner 'root'
      group node['root_group']
      mode '0444'
    end
  end

  package "install #{new_resource.packages}" do
    package_name new_resource.packages
    notifies :delete, 'file[/etc/init.d/nrpe]', :immediately
  end
end

action :uninstall do
  if platform_family? 'debian'
    cookbook_file '/etc/dpkg/dpkg.cfg.d/nagios-nrpe-server' do
      action :delete
    end
  end

  package "remove #{new_resource.packages}" do
    package_name new_resource.packages

    if platform_family? 'debian'
      action :purge
    else
      action :remove
    end
  end
end
