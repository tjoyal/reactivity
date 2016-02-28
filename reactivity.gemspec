# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'reactivity/version'

Gem::Specification.new do |spec|
  spec.name          = "reactivity"
  spec.version       = Reactivity::VERSION
  spec.authors       = ["Thierry Joyal"]
  spec.email         = ["thierry.joyal@gmail.com"]

  spec.summary       = %q{Reactivity meteor-like support for rails stack}
  spec.description   = %q{Reactivity meteor-like support for rails stack}
  spec.homepage      = ""
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'railties', '>= 5.0.0.beta1'
  spec.add_dependency 'actioncable', '>= 5.0.0.beta1'
  spec.add_dependency 'sprockets', '>= 3.0.0'
  spec.add_dependency 'sprockets-es6'

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
