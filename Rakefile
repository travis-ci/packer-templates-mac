require 'json'
require 'yaml'
require 'rake/clean'

desc 'Run checks against scripts and templates'
task :default do
  sh "git grep -l '^#!/bin/bash' | xargs shellcheck"
  sh "git grep -l '^#!/bin/bash' | xargs shfmt -i 2 -w"
  Rake::Task[:validate].invoke
end

directory '.build/templates'
directory '.build/variables'
CLOBBER << '.build'

desc 'Validate all Packer templates'
task :validate

# Generate tasks to build any Packer templates we define
FileList['templates/*.yml'].each do |template|
  name = File.basename(template, '.yml')
  generated = ".build/templates/#{name}.json"
  variables = ".build/variables/#{name}.json"

  CLEAN << generated

  file generated => ['.build/templates', template] do |t|
    open t.name, 'w' do |f|
      template = YAML.safe_load(File.read(template))
      f.write JSON.pretty_generate(template)
    end
  end

  # Use task here instead of file so that this task always runs
  task variables, %i[xcode] => ['.build/variables'] do |t, args|
    vars = { xcode_version: args.xcode }
    File.write t.name, JSON.pretty_generate(vars)
  end

  desc "Run a packer build for '#{name}'"
  task name, %i[xcode] => [generated, variables] do
    sh 'bin/assert-host'
    sh "packer build -var-file #{variables} #{generated}"
  end

  namespace name do
    desc "Validate the template for '#{name}'"
    task validate: [generated] do
      sh "packer validate -var-file .test_variables.json #{generated}"
    end
  end

  task validate: "#{name}:validate"
end
