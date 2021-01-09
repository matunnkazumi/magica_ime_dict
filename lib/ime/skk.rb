# frozen_string_literal: true

require 'csv'
require 'stringio'
require_relative './collection'

module IME
  module SKK
    def self.convert(src)
      src
        .map { |entry| convert_person(entry) }
        .flatten
        .reject { |entry| entry.yomi == entry.kaki }
        .uniq
    end

    SKK_FILE_HEADER = <<~HEADER
      ;;; -*- coding: utf-8 -*-
      ;; okuri-nasi entries.
    HEADER

    def self.write_file(src, path)
      path.open('wb') do |file|
        file.write SKK_FILE_HEADER

        src
          .group_by(&:yomi)
          .transform_values { |value| value.map(&:kaki).join('/') }
          .sort
          .each do |a|
            file.puts "#{a[0]} \/#{a[1]}\/"
          end
      end
    end

    def self.convert_person(person)
      result = []

      sei = pair_to_entry(person[:sei])
      result.push(sei) unless sei.nil?

      mei = pair_to_entry(person[:mei])
      result.push(mei) unless mei.nil?

      sonota = person[:sonota]
      result.concat(sonota.map { |pair| pair_to_entry(pair) }) unless sonota.nil?

      result
    end

    def self.pair_to_entry(pair)
      return if pair.nil?

      kaki = pair[:kaki]
      yomi = pair[:yomi]

      ::IME::Collection::Entry.new(yomi, kaki, nil) unless yomi.nil?
    end
  end
end
