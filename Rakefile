# frozen_string_literal: true

require 'pathname'
require_relative 'lib/dict/reader'

task default: :build

task :build do
  pp Reader.load(Pathname('data/kazumi/puella.yaml'))
end
