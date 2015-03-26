require 'test_helper'

class TestRegister < Minitest::Test
  KLASS = ::TeamdriveApi::Register
  def r; KLASS.new('example.com', 'a1b2c3', '1.0.005'); end
  RESPONSE_OK = "<?xml version='1.0' encoding='UTF-8' ?><teamdrive><apiversion>1.0.005</apiversion><intresult>0</intresult></teamdrive>"

  def test_that_the_uri_is_constructed_correctly
    r = KLASS.new('example.com', '')
    assert_equal 'https://example.com/pbas/td2api/api/api.htm', r.uri

    r = KLASS.new('http://example.com/foo', '')
    assert_equal 'http://example.com/foo/pbas/td2api/api/api.htm', r.uri
  end

  def test_remove_user
    request = stub_request(:post, 'https://example.com/pbas/td2api/api/api.htm?checksum=ddde6d37ff196c2bd175a76be4b7dc3d').
      with(:body => /.*removeuser.*foo.*\$false/).
      to_return(:status => 200, :body => RESPONSE_OK, :headers => {})

    Time.stub :now, Time.at(0) do
      assert r.remove_user('foo', false)
      assert_requested request
    end
  end

  def test_remove_invalid_user
    response_body = %q{<?xml version='1.0' encoding='UTF-8' ?><teamdrive><apiversion>1.0.005</apiversion><exception><primarycode>-30100</primarycode><secondarycode></secondarycode><message>Username does not exists</message></exception></teamdrive>}

    stub_request(:post, /example\.com/).
      with(body: /removeuser/).
      to_return(status: 200, body: response_body)

    e = assert_raises TeamdriveApi::Error do
      r.remove_user('unknown')
    end
    assert_equal 'Username does not exists', e.message
  end

  def test_search_user
    response_body = '<teamdrive><apiversion>1.0.005</apiversion></teamdrive>'

    stub = stub_request(:post, /example\.com/).
      with(body: /searchuser.*\$false.*\$false.*<username>foobar<\/username>/).
      to_return(status: 200, body: response_body)
    r.search_user(username: 'foobar')
    assert_requested stub

    stub = stub_request(:post, /example\.com/).
      with(body: /searchuser.*\$true.*\$true.*<email>\*@example.com<\/email>/).
      to_return(status: 200, body: response_body)
    r.search_user(email: '*@example.com', showdevice: true, onlyownusers: true)
    assert_requested stub
  end

  def test_search_users_raises_with_empty_query
    e = assert_raises ArgumentError do
      r.search_user {}
    end
    assert_equal 'Provide at least one of "username", "email"', e.message
    e = assert_raises ArgumentError do
      r.search_user({showdevice: false, onlyownusers: false})
    end
    assert_equal 'Provide at least one of "username", "email"', e.message
  end

  def test_create_license_without_user
    request = stub_request(:post, 'https://example.com/pbas/td2api/api/api.htm?checksum=df78f7da006e99930a2b5e9c741b08a5').
      with(:body => /createlicensewithoutuser.*client.*permanent.*enterprise/).
      to_return(:status => 200, :body => RESPONSE_OK, :headers => {})

    Time.stub :now, Time.at(0) do
      assert r.create_license_without_user(productname: :client, type: :permanent, featurevalue: :enterprise)
      assert_requested request
    end
  end

  def test_create_license_without_user_raises_with_incomplete_query
    e = assert_raises ArgumentError do
      r.create_license_without_user {}
    end
    assert_equal 'Provide all of "productname", "type", "featurevalue"', e.message
  end

  def test_assign_user_to_license
    request = stub_request(:post, 'https://example.com/pbas/td2api/api/api.htm?checksum=b6266e47a8fc75be2cc791e47621c4b7').
      with(:body => /assignusertolicense.*<username>foo.*<number>12345/).
      to_return(:status => 200, :body => RESPONSE_OK, :headers => {})

    Time.stub :now, Time.at(0) do
      assert r.assign_user_to_license('foo', 12345)
      assert_requested request
    end
  end

  def test_get_usert_data
    response_body = "<?xml version='1.0' encoding='UTF-8' ?><teamdrive><apiversion>1.0.005</apiversion><userdata><username>foo</username><email>foo@example.com</email><language>EN</language><distributor>EXCO</distributor><reference>123</reference><department></department></userdata></teamdrive>"
    request = stub_request(:post, 'https://example.com/pbas/td2api/api/api.htm?checksum=ed5ad65edd718cda603e1a24567408f7').
      with(body: /getuserdata.*<username>foo/).
      to_return(status: 200, body: response_body)

    Time.stub :now, Time.at(0) do
      data = r.get_user_data('foo')
      assert_requested request
      assert_equal({
        apiversion: "1.0.005",
        userdata: {
          username: "foo",
          email: "foo@example.com",
          language: "EN",
          distributor: "EXCO",
          reference: "123",
          department: nil
        }}, data)
    end
  end
end
