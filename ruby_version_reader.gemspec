# -*- encoding: utf-8 -*-

require File.expand_path('../lib/ruby_version_reader', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "ruby_version_reader"
  gem.version       = RubyVersionReader::VERSION
  gem.summary       = 'Read .ruby-version and .ruby-gemset files.'
  gem.description   = 'Provides a RubyVersionReader class to simplify reading the .ruby-version and .ruby-gemset files.'
  gem.license       = "MIT"
  gem.authors       = ["Marcos Wright-Kuhns"]
  gem.email         = "marcos@wrightkuhns.com"
  gem.homepage      = "https://github.com/metavida/ruby_version_reader"

  gem.files         = Dir['{**/}{.*,*}'].select { |path| File.file?(path) }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'bundler', '~> 1.0'
  gem.add_development_dependency 'rake', '~> 10.1'
  gem.add_development_dependency 'rdoc', '~> 3.0'
  gem.add_development_dependency 'rspec', '~> 2.4'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
end
