require 'json'
require 'yaml'

directory '.build/templates'
CLOBBER << '.build'

# Records are meant to be persistent and committed.
# They are an artifact of the build that we wish to hold on to.
directory 'records'

desc 'Validate all Packer templates'
task :validate

# Generate tasks to build any Packer templates we define
FileList['templates/*.yml'].each do |template|
  name = File.basename(template, '.yml')
  next if name == 'base_vm'
  generated = ".build/templates/#{name}.json"

  CLEAN << generated

  file generated => ['.build/templates', template] do |t|
    open t.name, 'w' do |f|
      template = YAML.safe_load(File.read(template))
      f.write JSON.pretty_generate(template)
    end
  end

  directory "records/#{name}"

  desc "Run a packer build for '#{name}'"
  task name => [generated, "records/#{name}"] do
    sh 'bin/assert-host'
    sh "packer build #{generated}"
  end

  namespace name do
    desc "Validate the template for '#{name}'"
    task validate: [generated] do
      sh "packer validate -var-file .test_variables.json #{generated}"
    end
  end

  task validate: "#{name}:validate"
end
