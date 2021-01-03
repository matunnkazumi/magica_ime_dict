# frozen_string_literal: true

require_relative './reader'

def build
  result = Reader.load Pathname('data/kazumi/puella.yaml')
  result.each do |e|
    pp e[:sei]
  end
end
