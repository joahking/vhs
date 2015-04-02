# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vhs/version'

Gem::Specification.new do |spec|
  spec.name          = "vhs"
  spec.version       = VHS::VERSION
  spec.authors       = ["Joaquin Rivera Padron"]
  spec.email         = ["joaquin.rivera@xing.com"]
  spec.summary       = %q{Automatic stubs of all API calls in your test suite.}
  spec.description   = %q{Intelligent handling of VCR cassettes to automatically record and replay all API calls in your tests.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  #TODO do not add the *.sh files, only the ruby ones
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "thor", "~> 0.19.1"
  spec.add_runtime_dependency "typhoeus", "~> 0.2.1"  #XING's old libraries
  spec.add_runtime_dependency "vcr", "2.0.0.beta1.vhs.pre.0.2.0"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end

