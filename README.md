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
| node['nrpe']['install']['method'] | String | package | Sets the installation method. |
| node['nrpe']['config_file'] | String | /etc/nagios/nrpe.cfg | Sets the path for base nrpe configuration. |
| node['nrpe']['service_name'] | String | nrpe | Sets the name of the service. |
| node['nrpe']['service_user'] | String | nrpe | Sets the service username. |
| node['nrpe']['service_group'] | String | nrpe | Sets the service groupname. |
| node['nrpe']['service_home'] | String | /var/run/nrpe | Sets the service directory. |

## Custom Resources

| Resource Name | Description |
| ------------- | ----------- |
| nrpe_config | Manages the configuration of the nrpe client. |
| nrpe_check | Manages an active check for the nrpe client. |
| nrpe_installation_archive | Compiles the nrpe client from an archive. |
| nrpe_installation_omnibus | Installs the nrpe client from an [Omnibus package][3]. |
| nrpe_installation_package | Installs the nrpe client from a system package. |

[0]: https://github.com/test-kitchen/test-kitchen
[1]: https://en.wikipedia.org/wiki/Nagios#NRPE
[2]: https://github.com/bloomberg-cookbooks/nrpe/blob/master/test/integration/default/default_spec.rb
[3]: https://github.com/chef/omnibus
