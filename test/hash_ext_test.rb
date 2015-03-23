require 'test_helper'

class TestHashExt < Minitest::Test
  BEFORE = {
    'foo' => 'bar',
    'num' => {
      'first' => 1,
      'second' => 2
    }
  }

  EXPECTED = {
    foo: 'bar',
    num: {
      first: 1,
      second: 2
    }
  }

  def test_symbolize_keys
    hsh = BEFORE
    assert_equal EXPECTED, hsh.symbolize_keys
    assert_equal BEFORE, hsh
  end

  def test_symbolize_keys!
    hsh = BEFORE
    hsh.symbolize_keys!
    assert_equal EXPECTED, hsh
  end
end
