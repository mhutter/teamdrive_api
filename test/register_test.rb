require 'test_helper'

class TestRegister < Minitest::Test
  KLASS = ::TeamdriveApi::Register
  def r; KLASS.new('example.com', 'a1b2c3', '1.0.005'); end

  def test_that_the_uri_is_constructed_correctly
    r = KLASS.new('example.com', '')
    assert_equal 'https://example.com/pbas/td2api/api/api.htm', r.uri

    r = KLASS.new('http://example.com/foo', '')
    assert_equal 'http://example.com/foo/pbas/td2api/api/api.htm', r.uri
  end

  def test_remove_user
    response_body = %q{<?xml version='1.0' encoding='UTF-8' ?><teamdrive><apiversion>1.0.005</apiversion><intresult>0</intresult></teamdrive>}

    request = stub_request(:post, 'https://example.com/pbas/td2api/api/api.htm?checksum=ddde6d37ff196c2bd175a76be4b7dc3d').
      with(:body => /.*removeuser.*foo.*\$false/).
      to_return(:status => 200, :body => response_body, :headers => {})

    Time.stub :now, Time.at(0) do
      res = r.remove_user('foo', false)
      assert_requested request
      assert_equal '0', res['intresult']
    end
  end

  def test_remove_invalid_user
    response_body = %q{<?xml version='1.0' encoding='UTF-8' ?><teamdrive><apiversion>1.0.005</apiversion><exception><primarycode>-30100</primarycode><secondarycode></secondarycode><message>Username does not exists</message></exception></teamdrive>}

    stub_request(:post, /example\.com/).
      with(body: /removeuser/).
      to_return(status: 200, body: response_body)

    assert_raises TeamdriveApi::Error do |e|
      r.remove_user('unknown')
      assert_equal 'Username doe not exists', e.msg
    end
  end
end
