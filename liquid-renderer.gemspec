# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'liquid-renderer/version'

Gem::Specification.new do |spec|
  spec.name          = "liquid-renderer"
  spec.version       = LiquidRenderer::VERSION
  spec.authors       = ["Kelley Reynolds"]
  spec.email         = ["kelley@bigcartel.com"]
  spec.description   = %q{Add liquid renderer to action controller}
  spec.summary       = %q{Add liquid renderer to action controller}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "actionpack", ">= 3.0"
  spec.add_dependency "activesupport", ">= 3.0"
  spec.add_dependency "liquid"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "rspec", ">= 2.6.0"
end
