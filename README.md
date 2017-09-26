# blp-nrpe cookbook

[![Build Status](https://img.shields.io/travis/bloomberg-cookbooks/nrpe.svg)](https://travis-ci.org/bloomberg-cookbooks/nrpe)
[![Cookbook Version](https://img.shields.io/cookbook/v/blp-nrpe.svg)](https://supermarket.chef.io/cookbooks/blp-nrpe)
[![License](https://img.shields.io/github/license/bloomberg-cookbooks/nrpe.svg?maxAge=2592000)](http://www.apache.org/licenses/LICENSE-2.0)

The blp-nrpe cookbook is a library cookbook that provides custom
resources for installing, configuring and managing
the [nrpe client][1]

## Platforms

The following platforms are tested automatically
using [Test Kitchen][0], in Docker, with
the [default suite of integration tests][2]:

- Ubuntu 12.04/14.04/16.04
- CentOS (RHEL) 6/7

Additionally, the platforms below are also known to work:

- AIX 7.1
- Solaris 5.11

## Attributes

| Attribute Name | Type | Default Value | Description |
| -------------- | ---- | ------------- | ----------- |
| node['nrpe']['archive']['version'] | String | see [attributes/default.rb][4] | Sets the verison of nrpe archive. |
| node['nrpe']['archive']['checksum'] | String | see [attributes/default.rb][4] | Sets the nrpe archive checksum. |
| node['nrpe']['archive']['url'] | String | see [attributes/default.rb][4] | Sets the nrpe archive download URL. |
| node['nrpe']['config_file'] | String | /etc/nagios/nrpe.cfg | Sets the path for base nrpe configuration. |
| node['nrpe']['nrpe_plugins'] | String | see [attributes/default.rb][4] | Sets path for nrpe plugins. |
| node['nrpe']['package']['packages'] | String, Array | see [attributes/default.rb][4] | Sets the path for nrpe plugins. |
| node['nrpe']['program'] | String | /usr/sbin/nrpe | Sets the location or nrpe program. |
| node['nrpe']['provider'] | String | package | Sets the nrpe installation provider. |
| node['nrpe']['service_name'] | String | nrpe | Sets the name of the service. |
| node['nrpe']['service_user'] | String | nrpe | Sets the service username. |
| node['nrpe']['service_group'] | String | nrpe | Sets the service groupname. |
| node['nrpe']['service_home'] | String | /var/run/nrpe | Sets the service directory. |
| node['nrpe']['service_resource'] | String | `poise_service` | Set the service resource to use to control/reload the NRPE service |

## Custom Resources

| Resource Name | Description |
| ------------- | ----------- |
| nrpe_config | Manages the configuration of the nrpe client. |
| nrpe_check | Manages an active check for the nrpe client. |
| [nrpe_installation_archive](#archive-installation) | Compiles the nrpe client from an archive. |
| [nrpe_installation_omnibus](#omnibus-installation) | Installs the nrpe client from an [Omnibus package][3]. |
| nrpe_installation_package | Installs the nrpe client from a system package. |

### Archive Installation

``` ruby
node.override['nrpe']['config']['debug'] = true

node.override['nrpe']['provider'] = 'archive'
node.override['nrpe']['archive']['version'] = '2.0.0'
include_recipe 'blp-nrpe::default'
```

### Omnibus Installation

``` ruby
include_recipe 'chef-sugar::default'

node.override['nrpe']['config']['debug'] = true

node.override['nrpe']['provider'] = 'omnibus'
node.override['nrpe']['omnibus']['package_source'] = 'https://artifactory.bigco.com/.../inf-nrpe-3.0.1.pkg' if solaris?
node.override['nrpe']['omnibus']['package_source'] = 'https://artifactory.bigco.com/.../inf-nrpe-3.0.1.bff' if aix?
node.override['nrpe']['omnibus']['package_source'] = 'https://artifactory.bigco.com/.../inf-nrpe-3.0.1.rpm' if rhel?
node.override['nrpe']['omnibus']['package_source'] = 'https://artifactory.bigco.com/.../inf-nrpe-3.0.1.deb' if ubuntu?
node.override['nrpe']['program'] = '/opt/inf/inf-nrpe/sbin/nrpe'
node.override['nrpe']['nrpe_plugins'] = '/opt/inf/inf-nrpe/lib/nagios/plugins'
include_recipe 'blp-nrpe::default'
```

[0]: https://github.com/test-kitchen/test-kitchen
[1]: https://en.wikipedia.org/wiki/Nagios#NRPE
[2]: https://github.com/bloomberg-cookbooks/nrpe/blob/master/test/integration/default/default_spec.rb
[3]: https://github.com/chef/omnibus
[4]: https://github.com/bloomberg-cookbooks/nrpe/blob/master/attributes/default.rb
