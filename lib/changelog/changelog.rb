# frozen_string_literal: true

class Changelog
  PATTERN_VERSION_LINE = /^\#{2}[^#]/
  PATTERN_LABEL_LINK = /^\[(?<label>[^\[\]]+)\]: (?<link>\S+)/

  def initialize(path)
    @lines = path.open.readlines
  end

  def first_line
    @lines[0]
  end

  def enum_version_lines
    @lines.select do |line|
      PATTERN_VERSION_LINE.match(line)
    end
  end

  def enum_versions
    extract_version = /\[(?<version>[^\[\]]+)\]/

    enum_version_lines
      .map { |line| extract_version.match(line) }
      .map { |matched| matched.nil? ? nil : matched[:version] }
      .compact
  end

  def enum_type_lines
    reqexp = /^\#{3}[^#]/

    @lines.select do |line|
      reqexp.match(line)
    end
  end

  def enum_link_label_definitions
    reqexp = /^\[[^\[\]]+\]/

    @lines.select do |line|
      reqexp.match(line)
    end
  end

  def link_label_dict
    enum_link_label_definitions.map do |line|
      matched = PATTERN_LABEL_LINK.match(line)
      [matched[:label], matched[:link]] unless matched.nil?
    end.compact.to_h
  end

  def enum_version_sections
    # @type var state: String | nil
    state = nil

    @lines.chunk do |line|
      if PATTERN_VERSION_LINE.match(line)
        state = line
      elsif PATTERN_LABEL_LINK.match(line)
        state = nil
      end
      state
    end.to_h
  end
end
