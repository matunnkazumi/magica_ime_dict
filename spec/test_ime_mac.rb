# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ime/mac'

class TestImeMAC < Minitest::Test
  def test_type_readable
    assert_equal '人名', MAC::Entry.new('hoge', 'huga', :jinmei).type_readable
    assert_equal '名詞', MAC::Entry.new('hoge', 'huga', :meishi).type_readable
  end
end
