name 'default'
default_source :community
default_source :chef_repo, '..'

default_source :chef_repo, ".." do |s|
  s.preferred_for "test"
end

cookbook 'blp-nrpe', path: '../../..'
run_list 'blp-nrpe::default', 'test::default'
named_run_list :centos, 'sudo::default', 'yum::default', 'yum-epel::default', run_list
named_run_list :debian, 'sudo::default', 'apt::default', run_list
named_run_list :freebsd, 'freebsd::default', run_list
named_run_list :windows, 'windows::default', run_list

default['authorization']['sudo']['passwordless'] = true
default['authorization']['sudo']['users'] = %w(vagrant kitchen)
