# frozen_string_literal: true

require 'csv'
require 'stringio'
require_relative './collection'

module MSIME
  def self.convert(src)
    src.map { |entry| convert_person(entry) }.flatten.uniq
  end

  def self.write_file(src, path)
    io = StringIO.new
    csv = CSV.new(io, col_sep: "\t", row_sep: "\r\n")
    src.each do |entry|
      csv << [entry.yomi, entry.kaki, entry.category]
    end

    path.open('wb:UTF-16LE:UTF-8') do |file|
      file.write "\uFEFF"
      file.puts io.string
    end
  end

  def self.convert_person(person)
    result = []

    sei = pair_to_entry(person[:sei], '姓')
    result.push(sei) unless sei.nil?

    mei = pair_to_entry(person[:mei], '名')
    result.push(mei) unless mei.nil?

    sonota = person[:sonota]
    result.concat(sonota.map { |pair| pair_to_entry(pair, '人名') }) unless sonota.nil?

    result
  end

  def self.pair_to_entry(pair, category)
    return if pair.nil?

    kaki = pair[:kaki]
    yomi = pair[:yomi]

    ::IME::Collection::Entry.new(yomi, kaki, category) unless yomi.nil?
  end
end
