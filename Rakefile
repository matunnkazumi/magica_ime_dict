# frozen_string_literal: true

require 'pathname'
require 'rake/testtask'
require_relative 'lib/dict/reader'

task default: :build

task :build do
  pp Reader.load(Pathname('data/kazumi/puella.yaml'))
end

Rake::TestTask.new do |t|
  t.test_files = Dir['spec/**/test_*.rb']
  t.verbose = true
end
