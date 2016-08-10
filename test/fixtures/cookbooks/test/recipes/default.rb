nrpe_check 'check_load' do
  warning_condition '6'
  critical_condition '10'
end

nrpe_check 'check_disk' do
  parameters '-A -x /dev/shm -X nfs -i /boot'
  warning_condition '8%'
  critical_condition '5%'
end

nrpe_check 'check_users'
