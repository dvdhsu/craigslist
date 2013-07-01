# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name          = 'craigslist'
  s.version       = '0.0.3'
  s.platform      = Gem::Platform::RUBY
  s.summary       = %q{Unofficial Ruby DSL for programmatically accessing Craigslist listings.}
  s.license       = 'MIT'

  s.description   = %q{Unofficial Ruby DSL for programmatically accessing Craigslist listings.}

  s.files         = `git ls-files`.split($\)
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.require_paths = ['lib']
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})

  s.authors       = ['Greg Stallings']
  s.email         = ['gregstallings@gmail.com']
  s.homepage      = 'https://github.com/gregstallings/craigslist'
  s.source        = 'https://github.com/gregstallings/craigslist'

  s.add_dependency 'rake'
  s.add_dependency 'rspec'
  s.add_dependency 'nokogiri'
end
