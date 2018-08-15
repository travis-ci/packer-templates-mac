require 'yaml'
require 'rake/clean'

# We make certain tasks run differently if they are on the image-builder or not
HOSTNAME = `hostname`.strip
def remote?
  HOSTNAME.start_with? 'image-builder'
end

def remote_dep(task)
  "#{task}:#{remote? ? 'remote' : 'local'}"
end

# Define a task that needs to be run on the image-builder.
#
# If the task runs on the image-builder, it will run the block provided.
#
# If the task runs on any other machine, it will instead call the
# bin/rake-remote script to run the task on the image-builder.
#
# This means you can just run a rake task and not worry about where you are, and
# it will Do The Right Thing.
def remote_task(*args, &block)
  task_name, arg_name_list, prereqs = Rake.application.resolve_args(args)

  task task_name => remote_dep(task_name)

  namespace task_name do
    task :local do
      sh 'bin/rake-remote', task_name
    end
    task(:remote, arg_name_list => prereqs, &block)
  end
end

desc 'Run checks against scripts and templates'
task :default do
  sh "git grep -l '^#!/bin/bash' | xargs shellcheck"
  sh "git grep -l '^#!/bin/bash' | xargs shfmt -i 2 -w"
  Rake::Task[:validate].invoke
end
