# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ime/atok'

class TestImeATOK < Minitest::Test
  def test_convert_category_mapping
    # @type var src: Array[personal]
    src = [{
      sei: { yomi: 'aaa', kaki: 'bbb' },
      mei: { yomi: 'ccc', kaki: 'ddd' },
      others: [{ yomi: 'eee', kaki: 'fff' }, { yomi: 'ggg', kaki: 'hhh' }]
    }]

    result = ATOK.convert(src)

    assert_convert_mapping result, 'aaa', 'bbb', '固有人姓'
    assert_convert_mapping result, 'ccc', 'ddd', '固有人名'
    assert_convert_mapping result, 'eee', 'fff', '固有人他'
    assert_convert_mapping result, 'ggg', 'hhh', '固有人他'
  end

  def test_convert_uniqueness
    # @type var src: Array[personal]
    src = [
      { sei: { yomi: 'aaa', kaki: 'bbb' }, mei: { yomi: 'ccc', kaki: 'ddd' } },
      { sei: { yomi: 'aaa', kaki: 'bbb' }, mei: { yomi: 'eee', kaki: 'fff' } },
      { sei: { yomi: 'eee', kaki: 'fff' }, mei: { yomi: 'ccc', kaki: 'ddd' } }
    ]

    result = ATOK.convert(src)

    assert_convert_uniqueness result, 'aaa', 'bbb', '固有人姓'
    assert_convert_uniqueness result, 'ccc', 'ddd', '固有人名'
    assert_convert_uniqueness result, 'eee', 'fff', '固有人姓'
    assert_convert_uniqueness result, 'eee', 'fff', '固有人名'
  end

  private

  def assert_convert_mapping(list, yomi, kaki, category)
    f = method(:is_same).curry.call(yomi, kaki, category)
    assert list.any?(&f), "#{yomi} #{kaki} #{category}"
  end

  def assert_convert_uniqueness(list, yomi, kaki, category)
    f = method(:is_same).curry.call(yomi, kaki, category)
    assert_equal 1, list.select(&f).count, "#{yomi} #{kaki} #{category}"
  end

  def is_same(yomi, kaki, type, entry)
    entry.yomi == yomi && entry.kaki == kaki && entry.type == type
  end
end
