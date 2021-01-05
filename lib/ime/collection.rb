# frozen_string_literal: true

module IME
  module Collection
    class Entry
      attr_accessor :yomi, :kaki, :category

      def initialize(yomi, kaki, category)
        @yomi = yomi
        @kaki = kaki
        @category = category
      end
    end
  end
end
