name 'nrpe-ng'
default_source :community
cookbook 'nrpe-ng', path: '.'
named_run_list :freebsd, 'freebsd::default', 'nrpe-ng::default'
named_run_list :redhat, 'redhat::default', 'nrpe-ng::default'
named_run_list :ubuntu, 'ubuntu::default', 'nrpe-ng::default'
