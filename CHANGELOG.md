# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## 2.2.0 - 2017-09-28

### Changed
- solaris/aix: Add `node['nrpe']['service_resource']` to control
  notifies calls from within custom resources.

## 2.1.0 - 2017-09-19

### Changed
- Add basic support for configuring via node attributes for Solaris/AIX.
- upstart: Fix issue where reboot fails to start nrpe due to run directory not created.
- Update readme with examples on how to use Archive and Omnibus provider.

## 2.0.1 - 2017-07-13

### Changed
- Update readme documentation to fix errors in hyperlinks.

## 2.0.0 - 2017-07-13

### Changed
- Rename cookbook to _blp-nrpe_ from _nrpe-ng_ and move under _bloomberg-cookbooks organization_.
- ci: Automated pull-request testing with Test Kitchen and Docker for Linux.
- Minimum requirement of Chef Client 12.5.
- Custom resources modified to use the ["Chef Client" native syntax](https://docs.chef.io/custom_resources.html).

### Removed
- Support for CentOS (RHEL) 5.x series.
