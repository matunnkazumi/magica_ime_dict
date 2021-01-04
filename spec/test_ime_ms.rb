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
end
