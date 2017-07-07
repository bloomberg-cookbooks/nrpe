# blp-nrpe cookbook

[![Build Status](https://img.shields.io/travis/bloomberg-cookbooks/blp-nrpe-cookbook.svg)](https://travis-ci.org/bloomberg-cookbooks/blp-nrpe-cookbook)
[![Cookbook Version](https://img.shields.io/cookbook/v/blp-nrpe.svg)](https://supermarket.chef.io/cookbooks/blp-nrpe)
[![License](https://img.shields.io/github/license/bloomberg-cookbooks/blp-nrpe-cookbook.svg?maxAge=2592000)](http://www.apache.org/licenses/LICENSE-2.0)

The blp-nrpe cookbook is a library cookbook that provides custom
resources for installing, configuring and managing
the [nrpe client][1]

## Platforms

The following platforms are tested automatically
using [Test Kitchen][0], using Docker, with
the [default suite of integration tests][2]:

- Ubuntu 12.04/14.04/16.04
- CentOS (RHEL) 6/7

Additionally, the platforms below are also known to work:

- AIX 7.1
- Solaris 5.11

## Resources

- **nrpe_config**: Manages configuration of the nrpe client.
- **nrpe_check**: Manages an active check for nrpe client.
- **nrpe_installation_archive**: Compiles the nrpe client from an archive.
- **nrpe_installation_omnibus**: Installs the nrpe client as an [Omnibus package][3].
- **nrpe_installation_package**: Installs the nrpe client as a system package.

[0]: https://github.com/test-kitchen/test-kitchen
[1]: https://en.wikipedia.org/wiki/Nagios#NRPE
[2]: test/integration/default/default_spec.rb
[3]: https://github.com/chef/omnibus
