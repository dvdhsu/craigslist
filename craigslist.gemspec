# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = 'craigslist'
  s.version = '0.0.4'
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = ">= 1.9.3"
  s.license = 'MIT'
  s.summary = %q{Unofficial Ruby DSL for programmatically accessing Craigslist listings.}
  s.description = %q{Unofficial Ruby DSL for programmatically accessing Craigslist listings.}
  s.homepage = 'https://github.com/gregstallings/craigslist'

  s.authors = ['Greg Stallings']
  s.email = ['gregstallings@gmail.com']

  s.files = `git ls-files`.split($\)
  s.executables = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.require_paths = ['lib']
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  s.add_runtime_dependency 'nokogiri', '~> 1.6.0'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 2.14.1'
  s.add_development_dependency 'nokogiri', '~> 1.6.0'
end
