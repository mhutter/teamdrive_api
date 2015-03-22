require 'test_helper'

class TestRegister < Minitest::Test
  KLASS = ::TeamdriveApi::Register
  def r; KLASS.new('example.com', 'a1b2c3'); end

  def test_that_the_uri_is_constructed_correctly
    r = KLASS.new('example.com', '')
    assert_equal 'https://example.com/pbas/td2api/api/api.htm', r.uri

    r = KLASS.new('http://example.com/foo', '')
    assert_equal 'http://example.com/foo/pbas/td2api/api/api.htm', r.uri
  end
end
