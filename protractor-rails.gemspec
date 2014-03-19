# coding: utf-8

require File.expand_path('../lib/protractor/rails/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "protractor-rails"
  spec.version       = Protractor::Rails::VERSION
  spec.authors       = ["Tyrone Wilson"]
  spec.email         = ["tdubs241083@gmail.com"]
  spec.summary       = %q{Seemlessly run protractor for angularjs in your rails app.}
  spec.description   = %q{Protractor rails makes it a bit easier to integrate and run angularjs' protractor e2e test framework directly in your rails app.}
  spec.homepage      = "http://github.com/tyronewilson/protractor-rails"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency 'colorize'
  spec.add_runtime_dependency 'railties'
end
