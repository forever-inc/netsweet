# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'netsweet/version'

Gem::Specification.new do |spec|
  spec.name          = "netsweet"
  spec.version       = Netsweet::VERSION
  spec.authors       = ["Alex Burkhart", 'Aaron Christy', 'David Watson']
  spec.email         = ["saterus@gmail.com"]
  spec.description   = 'Sweet ruby wrapper for Netsuite E-Commerce and SSO APIs'
  spec.summary       = 'Netsweet hides the details of the Netsuite API behind a minimal interface. Interact with RESTlets or SOAP without changing Ruby bindings.'
  spec.homepage      = "https://github.com/forever-inc/netsweet"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "dotenv"

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-given"

  spec.add_runtime_dependency "netsuite"
  spec.add_runtime_dependency "netsuite-rest-client"
  spec.add_runtime_dependency "soap2r"
end
