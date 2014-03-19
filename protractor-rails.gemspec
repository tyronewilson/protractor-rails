# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'protractor/rails/version'

Gem::Specification.new do |spec|
  spec.name          = "protractor-rails"
  spec.version       = Protractor::Rails::VERSION
  spec.authors       = ["Tyrone Wilson"]
  spec.email         = ["tdubs241083@gmail.com"]
  spec.summary       = %q{Seemlessly run protractor for angularjs in your rails app.}
  spec.description   = %q{Protractor rails makes it a bit easier to integrate and run angularjs' protractor e2e test framework directly in your rails app.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency 'colorize'
end
