require 'json'
require 'yaml'

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
  task variables, %i[vanilla_vm xcode] => ['.build/variables'] do |t, args|
    vanilla_vm = VANILLA_VMS[args.vanilla_vm.to_s]
    macos_version = vanilla_vm['version']
    timestamp = Time.now.to_i
    image_name = "travis-ci-macos#{macos_version}-xcode#{args.xcode}-#{timestamp}"
    vars = {
      xcode_version: args.xcode,
      template_image_name: vanilla_vm['name'],
      dirty_image_name: "#{image_name}-dirty",
      final_image_name: image_name
    }
    File.write t.name, JSON.pretty_generate(vars)
  end

  desc "Run a packer build for '#{name}'"
  task name, %i[vanilla_vm xcode] => [generated, variables] do
    sh 'bin/assert-host'
    sh "packer build -var-file #{variables} #{generated}"
  end

  namespace name do
    desc "Validate the template for '#{name}'"
    task validate: [generated] do
      Rake::Task[variables].invoke('10.13', '9.4.1')
      sh "packer validate -var-file .test_variables.json -var-file #{variables} #{generated}"
    end
  end

  task validate: "#{name}:validate"
end

