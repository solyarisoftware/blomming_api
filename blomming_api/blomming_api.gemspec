# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'blomming_api/version'
require 'blomming_api/help'
require 'blomming_api/config'
require 'blomming_api/private_helpers'
require 'blomming_api/oauth_endpoint'
require 'blomming_api/buy_endpoints'
require 'blomming_api/sell_endpoints'
require 'blomming_api/public_helpers'


Gem::Specification.new do |spec|
  spec.name          = "blomming_api"
  spec.version       = BlommingApi::VERSION
  spec.authors       = BlommingApi::AUTHORS
  spec.email         = BlommingApi::EMAILS
  spec.summary       = BlommingApi::SUMMARY
  spec.description   = BlommingApi::DESCRIPTION
  spec.homepage      = BlommingApi::HOMEPAGE
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  # because of local variable scope in blocks
  spec.required_ruby_version = '>= 1.9.0'
  
  # runtime dependencies, from others gem
  spec.add_runtime_dependency "rest-client" 
  spec.add_runtime_dependency "multi_json"
  spec.add_runtime_dependency "oj"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
