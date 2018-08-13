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
  records = "records/#{name}"

  CLEAN << generated

  file generated => ['.build/templates', template] do |t|
    open t.name, 'w' do |f|
      template = YAML.safe_load(File.read(template))
      f.write JSON.pretty_generate(template)
    end
  end

  directory records

  desc "Run a packer build for '#{name}'"
  remote_task name => [generated, records] do
    uses_dedicated_host = template_data['builders'].any? do |b|
      b['host'] == 'packer_image_dev'
    end
    sh 'bin/assert-host' if uses_dedicated_host
    sh "packer build #{generated}"
  end

  task "#{name}:local" => [records] do
    Rake::Task["#{name}:records"].invoke
  end

  namespace name do
    desc "Validate the template for '#{name}'"
    task validate: [generated] do
      sh "packer validate -var-file .test_variables.json #{generated}"
    end

    desc "Copy records for '#{name}' from the image builder"
    task :records do
      sh "rsync -av packer@image-builder.macstadium-us-se-1.travisci.net:packer-templates-mac/#{records}/ #{records}"
    end
  end

  task validate: "#{name}:validate"
end
