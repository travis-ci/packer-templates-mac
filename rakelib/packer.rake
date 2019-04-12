require 'json'
require 'yaml'

directory '.build/templates'
CLOBBER << '.build'

desc 'Validate all Packer templates'
task :validate

class PackerTemplate
  include Rake::DSL

  attr_reader :path, :data

  def initialize(path)
    @path = path
    @data = YAML.safe_load(File.read(path))
  end

  def name
    @name ||= File.basename(path, '.yml')
  end

  def json_template
    ".build/templates/#{name}.json"
  end

  def records
    "records/#{name}"
  end

  def generic?
    name == 'base_vm'
  end

  def define_tasks
    define_json_tasks
    define_validate_tasks
  end

  class << self
    def define_tasks(directory)
      FileList["#{directory}/*.yml"].each do |path|
        template = new(path)
        next if template.generic?

        template.define_tasks
      end
    end
  end

  private

  def define_json_tasks
    CLEAN << json_template
    file json_template => ['.build/templates', path] do |t|
      open t.name, 'w' do |f|
        f.write JSON.pretty_generate(data)
      end
    end
  end

  def define_validate_tasks
    desc "Validate the template for '#{name}'"
    task "#{name}:validate" => [json_template] do
      sh "packer validate -var-file .test_variables.json #{json_template}"
    end

    task validate: "#{name}:validate"
  end

  def uses_dedicated_host?
    data['builders'].any? { |b| b['host'] == 'packer_image_dev' }
  end
end

PackerTemplate.define_tasks('templates')
