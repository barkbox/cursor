# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cursor/version"

Gem::Specification.new do |s|
  s.name        = 'cursor'
  s.version     = Cursor::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Becky Carella']
  s.email       = ['becarella@barkbox.com']
  s.homepage    = 'https://github.com/becarella/cursor'
  s.summary     = 'A cursor pagination engine for Rails 3+'
  s.description = 'Cursor is a fork of Kaminari ripped apart and put back together for cursor pagination only for Rails and ActiveRecord'

  s.rubyforge_project = 'cursor'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']

  s.licenses = ['MIT']

  s.add_dependency 'activesupport', ['>= 3.0.0']
  s.add_dependency 'actionpack', ['>= 3.0.0']

  s.add_development_dependency 'bundler', ['>= 1.0.0']
  s.add_development_dependency 'rake', ['>= 0']
  s.add_development_dependency 'tzinfo', ['>= 0']
  s.add_development_dependency 'rspec', ['>= 0']
  s.add_development_dependency 'rspec-its', '~> 1.0.0.pre'
  s.add_development_dependency 'rr', ['>= 0']
  s.add_development_dependency 'database_cleaner', ['~> 1.2.0']
  s.add_development_dependency 'rdoc', ['>= 0']
end
