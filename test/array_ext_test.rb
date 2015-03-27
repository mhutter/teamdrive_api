require 'test_helper'

class TestArrayExt < Minitest::Test
  BEFORE = [{
      'foo' => 'bar',
      'num' => {
        'first' => 1,
        'second' => 2
      }
    },
    'bar',
    :baz]

  EXPECTED = [{
      foo: 'bar',
      num: {
        first: 1,
        second: 2
      }
    },
    'bar',
    :baz]

  def test_symbolize_keys
    arr = BEFORE
    assert_equal EXPECTED, arr.symbolize_keys
    assert_equal BEFORE, arr
  end

  def test_symbolize_keys!
    arr = BEFORE
    arr.symbolize_keys!
    assert_equal EXPECTED, arr
  end
end
