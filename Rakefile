require 'json'
require 'yaml'

require 'rake/clean'

directory '.build/templates'
CLOBBER << '.build'

# Generate tasks to build any Packer templates we define
FileList['templates/*.yml'].each do |template|
  name = File.basename(template, '.yml')
  generated = ".build/templates/#{name}.json"

  CLEAN << generated

  file generated => ['.build/templates', template] do |t|
    open t.name, 'w' do |f|
      template = YAML.safe_load(File.read(template))
      f.write JSON.pretty_generate(template)
    end
  end

  desc "Run a packer build for '#{name}'"
  task name => generated do
    sh 'bin/assert-host'
    sh "packer build #{generated}"
  end
end

task default: :base_vm
