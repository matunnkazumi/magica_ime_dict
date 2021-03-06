# frozen_string_literal: true

require 'yaml'

class Reader
  def self.load(path)
    YAML.safe_load_file(path.to_s, symbolize_names: true, freeze: true)
  end
end
