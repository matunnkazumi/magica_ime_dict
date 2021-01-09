# frozen_string_literal: true

require 'csv'
require 'stringio'
require_relative './collection'

module IME
  module SKK
    class Entry2 < ::IME::Collection::Entry
      def initialize(yomi, kaki)
        super(yomi, kaki, nil)
      end

      def identical?
        yomi == kaki
      end
    end

    module_function

    def convert(src)
      src
        .map { |entry| convert_person(entry) }
        .flatten
        .reject(&:identical?)
        .uniq
    end

    def write_file(src, path)
      path.open('wb') do |file|
        file.puts ';; okuri-nasi entries.'

        src
          .group_by(&:yomi)
          .transform_values { |value| value.map(&:kaki).join('/') }
          .sort
          .each do |(yomi, kaki)|
            file.puts "#{yomi} \/#{kaki}\/"
          end
      end
    end

    def convert_person(person)
      result = []

      sei = pair_to_entry(person[:sei])
      result.push(sei) unless sei.nil?

      mei = pair_to_entry(person[:mei])
      result.push(mei) unless mei.nil?

      sonota = person[:sonota]
      result.concat(sonota.map { |pair| pair_to_entry(pair) }) unless sonota.nil?

      result
    end

    def pair_to_entry(pair)
      return if pair.nil?

      kaki = pair[:kaki]
      yomi = pair[:yomi]

      Entry2.new(yomi, kaki) unless yomi.nil?
    end
  end
end
