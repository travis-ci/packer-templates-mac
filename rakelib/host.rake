namespace :host do
  desc 'Move a dedicated image building host back into the build cluster'
  task :checkin do
    sh 'bin/checkin-host'
  end

  desc 'Alias for host:checkin'
  task ci: :checkin

  desc 'Take a host out of the build cluster for image building'
  task :checkout do
    sh 'bin/checkout-host'
  end

  desc 'Alias for host:checkout'
  task co: :checkout
end
