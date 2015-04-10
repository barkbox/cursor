# encoding: utf-8

require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task default: "spec:all"

namespace :spec do
  mappers = [
    ['2.2.1', 'active_record_edge'],
    ['2.1.2', 'active_record_42'],
    ['2.1.2', 'active_record_41'],
    ['2.1.2', 'active_record_40'],
    ['1.9.3-p551', 'active_record_32']
  ]

  mappers.each do |ruby, gemfile|
    desc "Run Tests against #{gemfile}"
    task gemfile do
      sh "BUNDLE_GEMFILE='gemfiles/#{gemfile}.gemfile' bundle --quiet"
      sh "BUNDLE_GEMFILE='gemfiles/#{gemfile}.gemfile' bundle exec rake -t spec"
    end
  end

  desc "Run Tests against all ORMs"
  task :all do
    mappers.each do |ruby, gemfile|
      sh %Q{
if hash rvm 2>/dev/null 
then
  echo "Using #{ruby} with RVM"
  rvm use #{ruby}
fi
if hash rbenv 2>/dev/null 
then
  echo "Using #{ruby} with RBENV"
  rbenv local #{ruby}
fi
BUNDLE_GEMFILE='gemfiles/#{gemfile}.gemfile' bundle --quiet
BUNDLE_GEMFILE='gemfiles/#{gemfile}.gemfile' bundle exec rake spec
      }
    end
  end
end

begin
  require 'rdoc/task'

  Rake::RDocTask.new do |rdoc|
    require 'cursor/version'

    rdoc.rdoc_dir = 'rdoc'
    rdoc.title = "cursor #{Cursor::VERSION}"
    rdoc.rdoc_files.include('lib/**/*.rb')
  end
rescue LoadError
  puts 'RDocTask is not supported on this VM and platform combination.'
end
