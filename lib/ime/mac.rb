# frozen_string_literal: true

require 'csv'
require 'stringio'

module MAC
  class Entry
    attr_accessor :yomi, :kaki, :type

    def initialize(yomi, kaki, type_)
      @yomi = yomi
      @kaki = kaki
      @type = type_
    end
  end

  def self.convert(src)
    src.map { |entry| convert_person(entry) }.flatten.uniq
  end

  def self.write_file(src, path)
    io = StringIO.new
    csv = CSV.new(io)
    src.each do |entry|
      csv << [entry.yomi, entry.kaki, entry.type]
    end

    path.open('wb') do |file|
      file.puts io.string
    end
  end

  def self.convert_person(person)
    result = []

    sei = pair_to_entry(person[:sei], '人名')
    result.push(sei) unless sei.nil?

    mei = pair_to_entry(person[:mei], '人名')
    result.push(mei) unless mei.nil?

    others = person[:others]
    result.concat(others.map { |pair| pair_to_entry(pair, '人名') }) unless others.nil?

    result
  end

  def self.pair_to_entry(pair, type)
    return if pair.nil?

    kaki = pair[:kaki]
    yomi = pair[:yomi]

    Entry.new(yomi, kaki, type) unless yomi.nil?
  end
end
