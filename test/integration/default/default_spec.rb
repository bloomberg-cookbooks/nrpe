describe service('nrpe') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end unless (os[:family] == 'redhat' && os[:release].to_i == 6)

case os[:name]
when 'redhat', 'centos' then
  describe file('/usr/lib64/nagios') do
    it { should exist }
    it { should be_directory }
  end

  # Be sure that we're using the right process supervisor on each
  # major release of RHEL. The same versions apply to CentOS.
  case os[:release].to_i
  when 5 then
    describe service('nrpe') do
      its('type') { should eq 'sysv' }
    end
  when 6 then
    describe service('nrpe') do
      skip
      #its('type') { should eq 'upstart' }
    end
  when 7 then
    describe service('nrpe') do
      its('type') { should eq 'systemd' }
    end
  end

when 'ubuntu' then
  describe file('/usr/lib/nagios') do
    it { should exist }
    it { should be_directory }
  end

  # The LTS 16.04 release uses systemd for process supervision; prior
  # to that it was upstart. We are only testing major releases here.
  case os[:release].to_i
  when 12, 14 then
    describe service('nrpe') do
      its('type') { should eq 'upstart' }
    end
  when 16 then
    describe service('nrpe') do
      its('type') { should eq 'systemd' }
    end
  end
end

describe processes('nrpe') do
  its('entries.length') { should eq 1 }
  its('users') { should eq %w(nrpe) }
end

describe group('nrpe') do
  it { should exist }
end

describe user('nrpe') do
  it { should exist }
  its('group') { should eq 'nrpe' }
  its('home') { should eq '/var/run/nrpe' }
end

describe file('/etc/nagios/nrpe.d') do
  it { should exist }
  it { should be_directory }
  it { should be_owned_by 'nrpe' }
  it { should be_grouped_into 'nrpe' }
end

describe file('/usr/sbin/nrpe') do
  it { should exist }
  it { should be_file }
  it { should be_executable.by_user 'nrpe' }
end

describe file('/etc/nagios/nrpe.cfg') do
  it { should exist }
  it { should be_readable.by_user 'nrpe' }
end
