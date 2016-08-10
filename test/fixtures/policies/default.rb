name 'default'
default_source :community
default_source :chef_repo, '..'
cookbook 'nrpe-ng', path: '../../..'
run_list 'nrpe-ng::default', 'test::default'
named_run_list :centos, 'yum::default', run_list
named_run_list :debian, 'apt::default', run_list
named_run_list :freebsd, 'freebsd::default', run_list
named_run_list :windows, 'windows::default', run_list
