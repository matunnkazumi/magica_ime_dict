# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'
require 'tempfile'
require_relative '../lib/changelog/changelog'

class TestChangeLog < Minitest::Test
  TEST_DATA = <<~CHANGELOG
    # Changelog
    All notable changes to this project will be documented in this file.

    The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
    and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

    ## [Unreleased]

    ## [1.0.0] - 2017-06-21
    ### Added
    - test

    ## [0.2.0] - 2017-06-20
    ### Changed
    - test

    ## [0.0.1] - 2017-06-19
    ### Added
    - test
    - test2

    ##  - invalid
    ### Deprecated
    - testA
    - testB

    [Unreleased]: https://github.com/matunnkazumi/test/compare/v1.0.0...HEAD
    [1.0.0]: https://github.com/matunnkazumi/test/compare/v0.3.0...v1.0.0
    [0.3.0]: https://github.com/matunnkazumi/test/compare/v0.0.1...v0.3.0
    [0.0.1]: https://github.com/matunnkazumi/test/releases/tag/v0.0.1
  CHANGELOG

  def setup
    @tempfile = Tempfile.open('temp') do |fp|
      fp.puts TEST_DATA
      fp
    end
  end

  def teardown
    @tempfile.close
  end

  def test_enum_version_lines
    log = Changelog.new(Pathname.new(@tempfile.path))

    expected = [
      "## [Unreleased]\n",
      "## [1.0.0] - 2017-06-21\n",
      "## [0.2.0] - 2017-06-20\n",
      "## [0.0.1] - 2017-06-19\n",
      "##  - invalid\n"
    ]

    assert_equal expected, log.enum_version_lines.to_a
  end

  def test_enum_versions
    log = Changelog.new(Pathname.new(@tempfile.path))

    expected = [
      'Unreleased',
      '1.0.0',
      '0.2.0',
      '0.0.1'
    ]

    assert_equal expected, log.enum_versions.to_a
  end

  def test_enum_type_lines
    log = Changelog.new(Pathname.new(@tempfile.path))

    expected = [
      "### Added\n",
      "### Changed\n",
      "### Added\n",
      "### Deprecated\n"
    ]

    assert_equal expected, log.enum_type_lines.to_a
  end

  def test_enum_link_label_definitions
    log = Changelog.new(Pathname.new(@tempfile.path))

    expected = [
      "[Unreleased]: https://github.com/matunnkazumi/test/compare/v1.0.0...HEAD\n",
      "[1.0.0]: https://github.com/matunnkazumi/test/compare/v0.3.0...v1.0.0\n",
      "[0.3.0]: https://github.com/matunnkazumi/test/compare/v0.0.1...v0.3.0\n",
      "[0.0.1]: https://github.com/matunnkazumi/test/releases/tag/v0.0.1\n"
    ]

    assert_equal expected, log.enum_link_label_definitions.to_a
  end
end
