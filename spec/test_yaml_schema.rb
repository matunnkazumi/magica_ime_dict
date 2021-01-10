# frozen_string_literal: true

require 'minitest/autorun'
require 'json_schemer'
require 'pathname'
require_relative '../lib/dict/reader'

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

  def test_yomi_hiragana
    # JSON Schema の正規表現の仕様次第ではそっちに変更
    schema_yaml_hash.each do |_schemer, yaml_list|
      yaml_list.each do |yaml|
        Reader.load(yaml).each do |person|
          assert_person_yomi person
        end
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

  PATTERN_YOMI = /^[\p{Hiragana}ー]+$/

  def assert_person_yomi(person)
    assert_match PATTERN_YOMI, person.dig(:sei, :yomi) unless person.dig(:sei, :yomi).nil?
    assert_match PATTERN_YOMI, person.dig(:mei, :yomi) unless person.dig(:mei, :yomi).nil?

    return unless person.key? :sonota

    person[:sonota].each do |pair|
      assert_match PATTERN_YOMI, pair[:yomi] if pair.key? :yomi
    end
  end
end
