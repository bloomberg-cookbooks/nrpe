name 'default'
default_source :community
cookbook 'apt'
cookbook 'freebsd'
cookbook 'nrpe-ng', path: File.expand_path('../../../..', __FILE__)
run_list 'nrpe-ng::default'
