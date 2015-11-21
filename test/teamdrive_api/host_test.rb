require 'test_helper'

class TestHost < Minitest::Test
  KLASS = ::TeamdriveApi::Host
  BODY_OK = "<?xml version='1.0' encoding='UTF-8' ?><teamdrive><apiversion>3.0.003</apiversion><intresult>0</intresult></teamdrive>"
  URL = %r{https://example.com/yvva/api/api.htm}

  def setup
    @h = KLASS.new('example.com/yvva/api/api.htm', 'a1b2c3', '3.0.003')
  end

  def test_set_depot
    stub_request(:post, URL).to_return(status: 200, body: BODY_OK)

    Time.stub :now, Time.at(0) do
      assert @h.set_depot('foo', '123', disclimit: 3, trafficlimit: 30)
    end

    assert_requested(:post, URL) do |req|
      req.body =~ />setdepot</ &&
        req.body =~ /<username>foo</ &&
        req.body =~ /<depotid>123</ &&
        req.body =~ /<disclimit>3</ &&
        req.body =~ /<trafficlimit>30</
    end
  end
end
