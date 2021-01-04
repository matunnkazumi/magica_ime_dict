# frozen_string_literal: true

require 'minitest/autorun'
require 'json_schemer'
require 'pathname'

class YamlSchemaValidation < Minitest::Test
  def test_validate
    schema_yaml_hash.each do |schemer, yaml_list|
      yaml_list.each do |yaml|
        data = YAML.load_file(yaml)

        valid = schemer.valid?(data)
        msg = schemer.validate(data)

        assert valid, msg.to_a.to_s
      end
    end
  end

  private

  def schema_yaml_hash
    json_path = Pathname('.vscode/settings.json')
    settings = YAML.load_file(json_path.to_s)

    schemas = settings['yaml.schemas']
    schemas
      .reject { |schema_file| schema_file.start_with?('https://') }
      .transform_keys { |schema_file| Pathname(schema_file) }
      .transform_keys { |pathname| JSONSchemer.schema(pathname) }
  end
end
