# frozen_string_literal: true

class Changelog
  def initialize(path)
    @lines = path.open.readlines
  end

  def first_line
    @lines[0]
  end

  def enum_version_lines
    reqexp = /^\#{2}[^#]/

    @lines.select do |line|
      reqexp.match(line)
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
end
