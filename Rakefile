require 'yaml'
require 'rake/clean'

desc 'Run checks against scripts and templates'
task :default do
  sh "git grep -l '^#!/bin/bash' | xargs shellcheck"
  sh "git grep -l '^#!/bin/bash' | xargs shfmt -i 2 -w"
  Rake::Task[:validate].invoke
end
