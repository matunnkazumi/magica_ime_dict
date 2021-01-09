# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../lib/ime/skk'

class TestImeSKK < Minitest::Test
  def test_convert_category_mapping
    # @type var src: Array[personal]
    src = [{
      sei: { yomi: 'aaa', kaki: 'bbb' },
      mei: { yomi: 'ccc', kaki: 'ddd' },
      sonota: [{ yomi: 'eee', kaki: 'fff' }, { yomi: 'ggg', kaki: 'hhh' }]
    }]

    result = IME::SKK.convert(src)

    assert_convert_mapping result, 'aaa', 'bbb'
    assert_convert_mapping result, 'ccc', 'ddd'
    assert_convert_mapping result, 'eee', 'fff'
    assert_convert_mapping result, 'ggg', 'hhh'
  end

  def test_convert_uniqueness
    # @type var src: Array[personal]
    src = [
      { sei: { yomi: 'aaa', kaki: 'bbb' }, mei: { yomi: 'ccc', kaki: 'ddd' } },
      { sei: { yomi: 'aaa', kaki: 'bbb' }, mei: { yomi: 'eee', kaki: 'fff' } },
      { sei: { yomi: 'eee', kaki: 'fff' }, mei: { yomi: 'ccc', kaki: 'ddd' } }
    ]

    result = IME::SKK.convert(src)

    assert_convert_uniqueness result, 'aaa', 'bbb'
    assert_convert_uniqueness result, 'ccc', 'ddd'
    assert_convert_uniqueness result, 'eee', 'fff'
  end

  private

  def assert_convert_mapping(list, yomi, kaki)
    f = method(:is_same).curry.call(yomi, kaki)
    assert list.any?(&f), "#{yomi} #{kaki}"
  end

  def assert_convert_uniqueness(list, yomi, kaki)
    f = method(:is_same).curry.call(yomi, kaki)
    assert_equal 1, list.select(&f).count, "#{yomi} #{kaki}"
  end

  def is_same(yomi, kaki, entry)
    entry.yomi == yomi && entry.kaki == kaki
  end
end
