# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'adequack/version'

Gem::Specification.new do |spec|
  spec.name          = "adequack"
  spec.version       = Adequack::VERSION
  spec.authors       = ["Ilya Zayats"]
  spec.email         = ["somebody32@gmail.com"]
  spec.description   = %q{Be sure that your mocks are adequate}
  spec.summary       = %q{Be sure that your mocks are adequate}
  spec.homepage      = "https://github.com/somebody32/adequack"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rspec", "~> 2.11"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "pry"
end
