require 'test_helper'

class TestRegister < Minitest::Test
  KLASS = ::TeamdriveApi::Register
  RESPONSE_OK = "<?xml version='1.0' encoding='UTF-8' ?><teamdrive><apiversion>1.0.005</apiversion><intresult>0</intresult></teamdrive>"
  URL = %r{https://example.com/yvva/td2api/api/api.htm}

  def setup
    @r = KLASS.new('example.com/yvva/td2api/api/api.htm', 'a1b2c3', '1.0.005')
  end

  def test_remove_user
    request = stub_request(:post, URL)
              .with(body: /.*removeuser.*<username>foo.*<deletelicense>\$false/)
              .to_return(status: 200, body: RESPONSE_OK, headers: {})

    Time.stub :now, Time.at(0) do
      assert @r.remove_user('foo', delete_license: false)
      assert_requested request
    end
  end

  def test_remove_invalid_user
    response_body = "<?xml version='1.0' encoding='UTF-8' ?><teamdrive><apiversion>1.0.005</apiversion><exception><primarycode>-30100</primarycode><secondarycode></secondarycode><message>Username does not exists</message></exception></teamdrive>"
    stub_request(:post, URL)
      .with(body: /removeuser/)
      .to_return(status: 200, body: response_body)

    e = assert_raises TeamdriveApi::Error do
      @r.remove_user('unknown')
    end
    assert_equal 'Username does not exists', e.message
  end

  def test_search_user
    stub = stub_request(:post, URL)
           .with(body: %r{searchuser.*\$false.*\$false.*<username>foobar<\/username>})
           .to_return(status: 200, body: xml_fixture(:search_user))
    @r.search_user(username: 'foobar')
    assert_requested stub
  end

  def test_search_user_with_boolean_params
    stub = stub_request(:post, URL)
           .with(body: %r{searchuser.*\$true.*\$false.*<email>\*@example.com<\/email>})
           .to_return(status: 200, body: xml_fixture(:search_user))
    @r.search_user(email: '*@example.com', showdevice: true, onlyownusers: false)
    assert_requested stub
  end

  def test_search_users_raises_with_empty_query
    e = assert_raises ArgumentError do
      @r.search_user {}
    end
    assert_equal 'Provide at least one of "username", "email"', e.message
  end

  def test_search_users_raises_with_missing_params
    e = assert_raises ArgumentError do
      @r.search_user(showdevice: false, onlyownusers: false)
    end
    assert_equal 'Provide at least one of "username", "email"', e.message
  end

  def test_create_license
    request = stub_request(:post, URL)
              .with(body: /createlicense.*<productname>client.*<type>monthly.*<featurevalue>professional/)
              .to_return(status: 200, body: xml_fixture(:create_license), headers: {})

    Time.stub :now, Time.at(0) do
      response = @r.create_license_without_user productname: :client,
                                                type: :monthly,
                                                featurevalue: :professional
      assert_equal 'TEST-1234-5678-0815', response
      assert_requested request
    end
  end

  def test_create_license_without_user
    request = stub_request(:post, URL)
              .with(body: /createlicensewithoutuser.*client.*permanent.*enterprise/)
              .to_return(status: 200, body: xml_fixture(:create_license), headers: {})

    Time.stub :now, Time.at(0) do
      response = @r.create_license_without_user productname: :client,
                                                type: :permanent,
                                                featurevalue: :enterprise
      assert_equal 'TEST-1234-5678-0815', response
      assert_requested request
    end
  end

  def test_create_license_without_user_raises_with_incomplete_query
    e = assert_raises ArgumentError do
      @r.create_license_without_user {}
    end
    assert_equal 'Provide all of "productname", "type", "featurevalue"', e.message
  end

  def test_assign_user_to_license
    request = stub_request(:post, URL)
              .with(body: /assignusertolicense.*<username>foo.*<number>12345/)
              .to_return(status: 200, body: RESPONSE_OK, headers: {})

    Time.stub :now, Time.at(0) do
      assert @r.assign_user_to_license('foo', 12_345)
      assert_requested request
    end
  end

  def test_assign_license_to_client
    request = stub_request(:post, URL)
              .with(body: /assignlicensetoclient.*<username>foo.*<number>12345/)
              .to_return(status: 200, body: RESPONSE_OK, headers: {})

    Time.stub :now, Time.at(0) do
      assert @r.assign_license_to_client('foo', 12_345)
      assert_requested request
    end
  end

  def test_get_usert_data
    request = stub_request(:post, URL)
              .with(body: /getuserdata.*<username>foo/)
              .to_return(status: 200, body: xml_fixture(:user_data))

    Time.stub :now, Time.at(0) do
      data = @r.get_user_data('foo')
      assert_requested request
      assert_equal(
        {
          apiversion: '1.0.005',
          userdata: {
            username: 'foo',
            email: 'foo@example.com',
            language: 'EN',
            distributor: 'EXCO',
            reference: '123',
            department: nil
          }
        },
        data)
    end
  end

  def test_register_user
    request = stub_request(:post, URL)
              .with(body: /registeruser.*<username>foo.*<useremail>foo@example.com.*<password>/)
              .to_return(status: 200, body: RESPONSE_OK, headers: {})

    Time.stub :now, Time.at(0) do
      assert @r.register_user(
        username: 'foo',
        useremail: 'foo@example.com',
        password: '$uper 5ekr1t!'
      )
      assert_requested request
    end
  end

  def test_downgrade_default_license
    request = stub_request(:post, URL)
              .with(body: /downgradedefaultlicense.*<username>foo.*<featurevalue>0/)
              .to_return(status: 200, body: RESPONSE_OK, headers: {})

    Time.stub :now, Time.at(0) do
      assert @r.downgrade_default_license(username: 'foo', featurevalue: 0)
      assert_requested request
    end
  end

  def test_upgrade_default_license
    request = stub_request(:post, URL)
              .with(body: /upgradedefaultlicense.*<username>foo.*<featurevalue>0/)
              .to_return(status: 200, body: RESPONSE_OK, headers: {})

    Time.stub :now, Time.at(0) do
      assert @r.upgrade_default_license(username: 'foo', featurevalue: 0)
      assert_requested request
    end
  end

  def test_reset_password
    request = stub_request(:post, URL)
              .with(body: /resetpassword.*<username>foo</)
              .to_return(status: 200, body: RESPONSE_OK, headers: {})

    Time.stub :now, Time.at(0) do
      assert @r.reset_password('foo')
      assert_requested request
    end
  end
end
