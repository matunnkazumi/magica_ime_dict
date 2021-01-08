# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../lib/ime/collection'

class TestImeCollection < Minitest::Test
  def test_eql
    e1 = IME::Collection::Entry.new('aa', 'bb', 'cc')
    e2 = IME::Collection::Entry.new('aa', 'bb', 'cc')

    assert e1 == e2
    assert e1.eql?(e2)
  end

  def test_not_eql
    e1 = IME::Collection::Entry.new('aa', 'bb', 'cc')
    e2 = IME::Collection::Entry.new('AA', 'bb', 'cc')
    e3 = IME::Collection::Entry.new('aa', 'BB', 'cc')
    e4 = IME::Collection::Entry.new('aa', 'bb', 'CC')

    refute e1 == e2
    refute e1.eql?(e2)
    refute e1 == e3
    refute e1.eql?(e3)
    refute e1 == e4
    refute e1.eql?(e4)
  end

  def test_eql_to_other_class
    e = IME::Collection::Entry.new('aa', 'bb', 'cc')
    other = Struct.new('Dummy', :yomi, :kaki, :category, :extra).new('aa', 'bb', 'cc', 'dd')

    assert e == other
    refute e.eql?(other)
  end
end
