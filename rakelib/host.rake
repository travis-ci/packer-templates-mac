desc 'Move a dedicated image building host back into the build cluster'
remote_task 'host:checkin' do
  sh 'bin/checkin-host'
end

desc 'Alias for host:checkin'
task 'host:ci' => 'host:checkin'

desc 'Take a host out of the build cluster for image building'
remote_task 'host:checkout' do
  sh 'bin/checkout-host'
end

desc 'Alias for host:checkout'
task 'host:co' => 'host:checkout'
