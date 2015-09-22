# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'immutabler/version'

Gem::Specification.new do |spec|
  spec.name          = 'immutabler'
  spec.version       = Immutabler::VERSION
  spec.authors       = ['Serhij Korochanskyj', 'Sergey Zenchenko']
  spec.email         = ['serge.k@techery.io', 'serge.z@techery.io']

  spec.summary       = 'Generator of Objective-C immutable models'
  spec.description   = 'Generator of Objective-C immutable models'
  spec.homepage      = 'https://github.com/techery/immutabler'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'handlebars', '~> 0.7'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
end
