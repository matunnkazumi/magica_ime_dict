# frozen_string_literal: true

require 'csv'
require 'stringio'

module MSIME
  class Entry
    attr_accessor :yomi, :kaki, :type

    def initialize(yomi, kaki, type_)
      @yomi = yomi
      @kaki = kaki
      @type = type_
    end

    def type_readable
      case type
      when :mei
        '名'
      when :sei
        '姓'
      when :jinmei
        '人名'
      when :meishi
        '名詞'
      else
        ''
      end
    end
  end

  def self.convert(src)
    src.map do |entry|
      result = []

      sei = pair_to_entry(entry[:sei], :sei)
      result.push(sei) unless sei.nil?

      mei = pair_to_entry(entry[:mei], :mei)
      result.push(mei) unless mei.nil?

      result
    end.flatten.uniq
  end

  def self.write_file(src, path)
    io = StringIO.new
    csv = CSV.new(io, col_sep: "\t", row_sep: "\r\n")
    src.each do |entry|
      csv << [entry.yomi, entry.kaki, entry.type_readable]
    end

    path.open('wb:UTF-16LE:UTF-8') do |file|
      file.write "\uFEFF"
      file.puts io.string
    end
  end

  def self.pair_to_entry(pair, type)
    return if pair.nil?

    kaki = pair[:kaki]
    yomi = pair[:yomi]

    Entry.new(yomi, kaki, type) unless yomi.nil?
  end
end
