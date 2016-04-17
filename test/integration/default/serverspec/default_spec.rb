require 'serverspec'
set :backend, :exec

describe service('nrpe') do
  it { should be_enabled }
  it { should be_running }
end

describe process('nrpe') do
  its(:count) { should eq 1 }
  its(:user) { should eq 'nagios' }
  its(:args) { should match %r{-c /etc/nagios/nrpe.cfg -d} }
  it { should be_running }
end

describe user('nagios') do
  it { should exist }
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
  it { should be_executable.by_user('nagios') }
end

describe file('/etc/nagios/nrpe.cfg') do
  it { should exist }
  it { should be_readable.by_user('nagios') }
end
