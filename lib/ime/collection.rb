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

      def hash
        [@yomi, @kaki, @category].hash
      end

      def ==(other)
        [@yomi, @kaki, @category] == [other.yomi, other.kaki, other.category]
      end

      def eql?(other)
        instance_of?(other.class) && self == other
      end
    end
  end
end
