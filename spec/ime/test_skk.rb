# frozen_string_literal: true

require 'tempfile'
require 'minitest/autorun'
require_relative '../../lib/ime/skk'
require_relative '../../lib/dict/reader'

class TestImeSKK < Minitest::Test
  def test_convert
    # @type var src: Array[personal]
    src = [{
      sei: { yomi: 'aaa', kaki: 'bbb' },
      mei: { yomi: 'ccc', kaki: 'ddd' },
      sonota: [{ yomi: 'eee', kaki: 'fff' }, { yomi: 'ggg', kaki: 'hhh' }]
    }]

    result = IME::SKK.convert(src)

    assert_convert_exist result, 'aaa', 'bbb'
    assert_convert_exist result, 'ccc', 'ddd'
    assert_convert_exist result, 'eee', 'fff'
    assert_convert_exist result, 'ggg', 'hhh'
  end

  def test_convert_remove_same_entry
    # @type var src: Array[personal]
    src = [{
      sei: { yomi: 'aaa', kaki: 'aaa' },
      mei: { yomi: 'ccc', kaki: 'ccc' },
      sonota: [{ yomi: 'eee', kaki: 'eee' }]
    }]

    result = IME::SKK.convert(src)

    refute_convert_exist result, 'aaa', 'aaa'
    refute_convert_exist result, 'ccc', 'ccc'
    refute_convert_exist result, 'eee', 'eee'
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

  TEST_WRITEFILE_SOURCE = <<~TESTFILE
    - sei:
        yomi: aaa
        kaki: bbb
      mei:
        yomi: ccc
        kaki: ddd
      sonota:
        - yomi: eee
          kaki: fff
    - sei:
        yomi: aaa
        kaki: bbb
    - sei:
        yomi: aaa
        kaki: ccc
  TESTFILE

  TEST_WRITEFILE_EXPECTED = <<~TESTFILE
    ;;; -*- coding: utf-8 -*-
    ;; okuri-nasi entries.
    aaa /bbb/ccc/
    ccc /ddd/
    eee /fff/
  TESTFILE

  def test_writefile
    file_check(TEST_WRITEFILE_SOURCE, TEST_WRITEFILE_EXPECTED) do |yaml, dest|
      src = Reader.load(yaml)
      result = IME::SKK.convert(src)
      IME::SKK.write_file(result, dest)
    end
  end

  private

  def assert_convert_exist(list, yomi, kaki)
    f = method(:is_same).curry.call(yomi, kaki)
    assert list.any?(&f), "#{yomi} #{kaki}"
  end

  def refute_convert_exist(list, yomi, kaki)
    f = method(:is_same).curry.call(yomi, kaki)
    refute list.any?(&f), "#{yomi} #{kaki}"
  end

  def assert_convert_uniqueness(list, yomi, kaki)
    f = method(:is_same).curry.call(yomi, kaki)
    assert_equal 1, list.select(&f).count, "#{yomi} #{kaki}"
  end

  def is_same(yomi, kaki, entry)
    entry.yomi == yomi && entry.kaki == kaki
  end

  def file_check(source, expected)
    tmp_src = Tempfile.open('temp_source') do |fp|
      fp.write source
      fp
    end
    tmp_result = Tempfile.open('temp_result')

    yield Pathname.new(tmp_src.path), Pathname.new(tmp_result.path)

    assert_equal expected, tmp_result.read

    tmp_result.close
    tmp_src.close
  end
end
