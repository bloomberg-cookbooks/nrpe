require 'serverspec'
set :backend, :exec

describe service('nrpe') do
  it { be_enabled }
  it { be_running }
end
