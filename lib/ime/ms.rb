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

    TYPE_TABLE = {
      sei: '姓',
      mei: '名',
      jinmei: '人名',
      meishi: '名詞'
    }.freeze

    def type_readable
      TYPE_TABLE[type]
    end
  end

  def self.convert(src)
    src.map { |entry| convert_person(entry) }.flatten.uniq
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

  def self.convert_person(person)
    result = []

    sei = pair_to_entry(person[:sei], :sei)
    result.push(sei) unless sei.nil?

    mei = pair_to_entry(person[:mei], :mei)
    result.push(mei) unless mei.nil?

    others = person[:others]
    result.concat(others.map { |pair| pair_to_entry(pair, :jinmei) }) unless others.nil?

    result
  end

  def self.pair_to_entry(pair, type)
    return if pair.nil?

    kaki = pair[:kaki]
    yomi = pair[:yomi]

    Entry.new(yomi, kaki, type) unless yomi.nil?
  end
end
