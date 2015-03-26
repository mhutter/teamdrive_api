require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'teamdrive_api'

gem 'minitest'
require 'minitest/autorun'
require 'pry'
require 'webmock/minitest'

WebMock.disable_net_connect! allow: 'codeclimate.com'
