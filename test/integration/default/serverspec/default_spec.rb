require 'serverspec'
set :backend, :exec

describe service('nrpe') do
  it { should be_enabled }
  it { should be_running }
end

describe process('nrpe') do
  its(:count) { should eq 1 }
  its(:user) { should eq 'nrpe' }
  its(:args) { should match %r{-c /etc/nagios/nrpe.cfg -d} }
  it { should be_running }
end

describe user('nrpe') do
  it { should exist }
  it { should belong_to_primary_group 'nrpe' }
  it { should have_home_directory '/var/run/nrpe' }
end

describe file('/etc/nrpe.d') do
  it { should exist }
  it { should be_directory }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/usr/sbin/nrpe') do
  it { should exist }
  it { should be_file }
  it { should be_executable.by_user 'nrpe' }
end

describe file('/usr/lib64/nagios') do
  it { should exist }
  it { should be_directory }
end

describe file('/etc/nagios/nrpe.cfg') do
  it { should exist }
  it { should be_readable.by_user 'nrpe' }
end
