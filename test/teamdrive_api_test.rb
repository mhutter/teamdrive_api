require 'test_helper'

class TestTeamdriveApi < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::TeamdriveApi::VERSION
  end

  # def test_options
  #   assert_equal '1.0.005', TeamdriveApi.options[:api_version]
  #   TeamdriveApi.options[:api_version] = 'test_mi'
  #   assert_equal 'test_mi', TeamdriveApi.options[:api_version]
  # end
end
