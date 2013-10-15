# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'craigslist/version'

Gem::Specification.new do |s|
  s.name = 'craigslist'
  s.version = Craigslist::Version
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = ">= 1.9.3"
  s.licenses = ['MIT']
  s.summary = %q{Unofficial Ruby interface for programmatically accessing Craigslist listings.}
  s.description = s.summary
  s.homepage = 'https://github.com/gregstallings/craigslist'

  s.authors = ['Greg Stallings']
  s.email = ['gregstallings@gmail.com']

  s.files = `git ls-files`.split($\)
  s.executables = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.require_paths = ['lib']
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  s.add_runtime_dependency 'nokogiri', '~> 1.6.0'

  s.add_development_dependency 'rake', '~> 10.1.0'
  s.add_development_dependency 'rspec', '~> 2.14.1'
  s.add_development_dependency 'nokogiri', '~> 1.6.0'
end
