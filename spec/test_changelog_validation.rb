# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'
require_relative '../lib/changelog/changelog'

class TestChangeLogValidation < Minitest::Test
  def setup
    path = Pathname.new('CHANGELOG.md')
    @changelog = Changelog.new(path)
  end

  def test_first_unreleased
    first = @changelog.enum_version_lines[0]
    assert_match(/^\#{2} \[Unreleased\]/, first, 'バージョンの最初が Unreleased ではありません')
  end

  def test_versions
    format = /^\#{2} \S+ - \d{4}-\d{2}-\d{2}$/

    lines = @changelog.enum_version_lines[Range.new(1, nil)] # 型エラー回避のためRange.new
    lines&.each do |line|
      assert_match format, line, 'バージョンの行のフォーマットが不正です'
    end
  end

  def test_change_types
    extract_type = /^\#{3} (?<type>\S+)/
    expected = %w[Added Changed Deprecated Removed Fixed Security]

    lines = @changelog.enum_type_lines
    lines.each do |line|
      matched = extract_type.match(line)

      assert(!matched.nil?, "変更種類の行のフォーマットが不正です #{line}")
      assert_includes(expected, matched[:type], '変更種類が不正です')
    end
  end

  def test_link_label_definition_format
    label_lines = @changelog.enum_link_label_definitions
    format = /^\[[^\[\]]+\]: \S+$/

    label_lines.each do |line|
      assert_match format, line, 'リンクの行のフォーマットが不正です'
    end
  end

  def test_link_labels
    versions = @changelog.enum_versions
    labels = @changelog.link_label_dict.keys

    assert_equal(versions, labels, 'ラベルとバージョンの並びが一致していません')
  end

  def test_link_label_repository
    labels = @changelog.link_label_dict.values
    format = %r{^https://github.com/(?<repos>[^/]+/[^/]+)/.*$}

    repos = labels.map { |label| format.match(label)[:repos] }.uniq
    assert(repos.length == 1, "異なるリポジトリが混在しています #{repos}")
  end

  def test_link_labels_link_unreleased
    url = @changelog.link_label_dict['Unreleased']
    prev_version = Regexp.escape(@changelog.enum_versions[1] || 'invalid')
    format = %r{^.+/compare/v#{prev_version}\.\.\.HEAD$}

    assert_match format, url, 'Unreleasedのリンクが不正です'
  end

  def test_link_labels_link
    targets = @changelog.enum_versions[1...-1]
    prev_targets = @changelog.enum_versions[Range.new(2, nil)] # 型エラー回避のためRange.new

    targets.zip(prev_targets).each do |version|
      url = @changelog.link_label_dict[version[0]]

      escaped = version.map { |v| Regexp.escape(v) }
      format = %r{^.+/compare/v#{escaped[1]}\.\.\.v#{escaped[0]}$}

      assert_match format, url, 'リンクが不正です'
    end
  end

  def test_link_labels_link_first
    first_version = @changelog.enum_versions[-1] || 'invalid'

    url = @changelog.link_label_dict[first_version]
    first_version_escaped = Regexp.escape(first_version)
    format = %r{^.+/releases/tag/v#{first_version_escaped}$}

    assert_match format, url, '最初のバージョンのリンクが不正です'
  end
end
