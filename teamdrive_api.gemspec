# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'teamdrive_api/version'

Gem::Specification.new do |spec|
  spec.name          = "teamdrive_api"
  spec.version       = TeamdriveApi::VERSION
  spec.authors       = ["Manuel Hutter"]
  spec.email         = ["git@mhutter.net"]

  if spec.respond_to?(:metadata)
    # spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.summary       = %q{TeamDrive API Client}
  spec.description   = %q{Client library for the TeamDrive XML API. Currently only supports the RegServer API}
  spec.homepage      = "https://github.com/mhutter/teamdrive_api"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "httparty", "~> 0.13"

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "minitest", "~> 5.5"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "webmock", "~> 1.20"
end
