# frozen_string_literal: true

require 'csv'
require 'stringio'
require_relative './collection'

module ATOK
  def self.convert(src)
    src.map { |entry| convert_person(entry) }.flatten.uniq
  end

  def self.write_file(src, path)
    io = StringIO.new
    csv = CSV.new(io, col_sep: "\t", row_sep: "\r\n")
    src.each do |entry|
      csv << [entry.yomi, entry.kaki, entry.type]
    end

    path.open('wb:UTF-16LE:UTF-8') do |file|
      file.write "\uFEFF"
      file.write "!!ATOK_TANGO_TEXT_HEADER_1\r\n"
      file.write io.string
    end
  end

  def self.convert_person(person)
    result = []

    sei = pair_to_entry(person[:sei], '固有人姓')
    result.push(sei) unless sei.nil?

    mei = pair_to_entry(person[:mei], '固有人名')
    result.push(mei) unless mei.nil?

    others = person[:others]
    result.concat(others.map { |pair| pair_to_entry(pair, '固有人他') }) unless others.nil?

    result
  end

  def self.pair_to_entry(pair, type)
    return if pair.nil?

    kaki = pair[:kaki]
    yomi = pair[:yomi]

    ::IME::Collection::Entry.new(yomi, kaki, type) unless yomi.nil?
  end
end
