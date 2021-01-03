# frozen_string_literal: true

require 'yaml'
require 'active_support/core_ext/hash'

class Reader
  def self.load(path)
    YAML.load_file(path.to_s).map(&:deep_symbolize_keys)
  end
end
