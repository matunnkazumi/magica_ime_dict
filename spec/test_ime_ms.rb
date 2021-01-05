# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ime/ms'

class TestImeMS < Minitest::Test
  def test_type_readable
    assert_equal '姓', MSIME::Entry.new('hoge', 'huga', :sei).type_readable
    assert_equal '名', MSIME::Entry.new('hoge', 'huga', :mei).type_readable
    assert_equal '人名', MSIME::Entry.new('hoge', 'huga', :jinmei).type_readable
    assert_equal '名詞', MSIME::Entry.new('hoge', 'huga', :meishi).type_readable
  end

  def test_convert_uniqueness
    # @type var src: Array[personal]
    src = [
      { sei: { yomi: 'aaa', kaki: 'bbb' }, mei: { yomi: 'ccc', kaki: 'ddd' } },
      { sei: { yomi: 'aaa', kaki: 'bbb' }, mei: { yomi: 'eee', kaki: 'fff' } },
      { sei: { yomi: 'eee', kaki: 'fff' }, mei: { yomi: 'ccc', kaki: 'ddd' } }
    ]

    result = MSIME.convert(src)

    assert_convert_uniqueness result, 'aaa', 'bbb', :sei
    assert_convert_uniqueness result, 'ccc', 'ddd', :mei
    assert_convert_uniqueness result, 'eee', 'fff', :sei
    assert_convert_uniqueness result, 'eee', 'fff', :mei
  end

  private

  def assert_convert_uniqueness(list, yomi, kaki, category)
    f = method(:is_same).curry.call(yomi, kaki, category)
    assert_equal 1, list.select(&f).count, "#{yomi} #{kaki} #{category}"
  end

  def is_same(yomi, kaki, type, entry)
    entry.yomi == yomi && entry.kaki == kaki && entry.type == type
  end
end
