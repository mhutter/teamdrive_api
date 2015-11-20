require 'test_helper'

class TestHost < Minitest::Test
  KLASS = ::TeamdriveApi::Host
  RESPONSE_OK = "<?xml version='1.0' encoding='UTF-8' ?><teamdrive><apiversion>1.0.005</apiversion><intresult>0</intresult></teamdrive>"
  URL = %r{https://example.com/yvva/api/api.htm}

  def setup
    @h = KLASS.new('example.com/yvva/api/api.htm', 'a1b2c3', '3.0.003')
  end

  def test_set_depot
    request = stub_request(:post, URL)
              .with(body: /.*>setdepot<.*<depotid>123</)
              .to_return(status: 200, body: RESPONSE_OK, headers: {})

    Time.stub :now, Time.at(0) do
      assert @h.set_depot('foo', '123', disclimit: 3, trafficlimit: 30)
      assert_requested request
    end
  end
end
