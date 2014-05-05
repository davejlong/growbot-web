# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'growbot/web/version'

Gem::Specification.new do |spec|
  spec.name          = 'growbot-web'
  spec.version       = Growbot::Web::VERSION
  spec.authors       = ['David Long']
  spec.email         = ['dave@davejlong.com']
  spec.summary       = %q{Web client to display Growbot metrics}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'sinatra', '~> 1.4.5'
  spec.add_runtime_dependency 'sinatra-contrib', ' ~> 1.4.2'
  spec.add_runtime_dependency 'yajl-ruby', '~> 1.2.0'
  spec.add_runtime_dependency 'ashikawa-core', '~> 0.10'
  spec.add_runtime_dependency 'haml', '~> 4.0.5'
  spec.add_runtime_dependency 'coffee-script', '~> 2.2.0'
  spec.add_runtime_dependency 'bourbon', '~> 4.0.1'
  spec.add_runtime_dependency 'neat', '~> 1.6.0'
  spec.add_runtime_dependency 'bitters', '~> 0.9.3'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.0.0.beta'
  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'yard'
end
