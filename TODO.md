- [ ] Investigate using `load_current_value` with all custom resources
  instead of using lazily evaluated attributes.
  - The program, user, group and service name attributes in all custom resources.
  - The [config resource][1] instead of interating over [key/value pairs in default recipe][6].
  - The [installation package resource][4] with `node['nrpe']['package']['packages']` attribute.
  - The [installation archive resource][3] with `node['nrpe']['archive']` attribute/hash.

[1]: https://github.com/bloomberg-cookbooks/nrpe/blob/master/resources/config.rb
[2]: https://github.com/bloomberg-cookbooks/nrpe/blob/master/resources/check.rb
[3]: https://github.com/bloomberg-cookbooks/nrpe/blob/master/resources/installation_archive.rb
[4]: https://github.com/bloomberg-cookbooks/nrpe/blob/master/resources/installation_omnibus.rb
[5]: https://github.com/bloomberg-cookbooks/nrpe/blob/master/resources/installation_package.rb
[6]: https://github.com/bloomberg-cookbooks/nrpe/blob/master/recipes/default.rb#L29
