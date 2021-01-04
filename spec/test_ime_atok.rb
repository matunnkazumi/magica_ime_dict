# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ime/atok'

class TestImeATOK < Minitest::Test
  def test_type_readable
    assert_equal '固有人姓', ATOK::Entry.new('hoge', 'huga', :koyujinsei).type_readable
    assert_equal '固有人名', ATOK::Entry.new('hoge', 'huga', :koyujinmei).type_readable
    assert_equal '固有人他', ATOK::Entry.new('hoge', 'huga', :koyujinhoka).type_readable
    assert_equal '名詞', ATOK::Entry.new('hoge', 'huga', :meishi).type_readable
  end
end
