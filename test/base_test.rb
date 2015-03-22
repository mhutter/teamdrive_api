require 'test_helper'

class TestTeamdriveApiBase < Minitest::Test
  KLASS = ::TeamdriveApi::Base
  def r; KLASS.new('example.com', 'salt', 'api_version'); end

  def test_that_it_creates_a_client
    assert_kind_of KLASS, r
  end

  def test_that_payload_for_includes_the_correct_command
    assert_match '<command>my_command</command>', r.payload_for(:my_command)
  end

  def test_that_payload_for_generates_the_correct_document
    expected = %q{<?xml version='1.0' encoding='UTF-8' ?><teamdrive><apiversion>api_version</apiversion><command>my_command</command><requesttime>0</requesttime></teamdrive>}

    Time.stub :now, Time.at(0) do
      assert_equal expected, r.payload_for(:my_command)
    end
  end

  def test_query_options
    expected = %q{<?xml version='1.0' encoding='UTF-8' ?><teamdrive><apiversion>api_version</apiversion><command>my_command</command><requesttime>0</requesttime><username>foo</username><second>bar</second></teamdrive>}

    Time.stub :now, Time.at(0) do
      actual = r.payload_for(:my_command, username: 'foo', second: 'bar')
      assert_equal expected, actual
    end
  end

  def test_boolean_query_options
    expected_true = %q{<?xml version='1.0' encoding='UTF-8' ?><teamdrive><apiversion>api_version</apiversion><command>my_command</command><requesttime>0</requesttime><true>$true</true></teamdrive>}
    expected_false = %q{<?xml version='1.0' encoding='UTF-8' ?><teamdrive><apiversion>api_version</apiversion><command>my_command</command><requesttime>0</requesttime><false>$false</false></teamdrive>}

    Time.stub :now, Time.at(0) do
      assert_equal expected_true, r.payload_for(:my_command, true: true)
      assert_equal expected_false, r.payload_for(:my_command, false: false)
    end
  end
end
