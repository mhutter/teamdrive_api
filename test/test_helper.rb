require 'bundler/setup'
require 'pry'

require 'simplecov'
SimpleCov.add_filter '.bundle'
if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
else
  SimpleCov.start
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'teamdrive_api'

require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require 'webmock/minitest'
WebMock.disable_net_connect! allow: 'codeclimate.com'

# read and return the contents of an xml file
def xml_fixture(name)
  open(File.expand_path("../fixtures/#{name}.xml", __FILE__)).read
end
