# frozen_string_literal: true

module IME
  module Collection
    class Entry
      attr_accessor :yomi, :kaki, :type

      def initialize(yomi, kaki, type_)
        @yomi = yomi
        @kaki = kaki
        @type = type_
      end
    end
  end
end
