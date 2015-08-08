# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'teamdrive_api/version'

Gem::Specification.new do |s|
  s.name          = 'teamdrive_api'
  s.version       = TeamdriveApi::VERSION
  s.author        = 'Manuel Hutter'
  s.email         = 'manuel@hutter.io'

  s.summary       = 'TeamDrive API Client'
  s.description   = 'Client library for the TeamDrive XML API. Currently only supports the RegServer API'
  s.homepage      = 'https://github.com/mhutter/teamdrive_api'
  s.license       = 'MIT'

  s.files         = `git ls-files -z git ls-files -z lib/ [A-Z][A-Z]*`.split("\x0")
  s.require_paths = ['lib']

  s.add_runtime_dependency 'httparty', '~> 0.13'

  s.add_development_dependency 'bundler', '~> 1.8'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'pry', '~> 0.10'
  # Testing
  s.add_development_dependency 'codeclimate-test-reporter', '~> 0'
  s.add_development_dependency 'minitest', '~> 5.8'
  s.add_development_dependency 'minitest-reporters', '~> 1.0'
  s.add_development_dependency 'webmock', '~> 1.20'
end
