# frozen_string_literal: true

require 'pathname'
require 'rake/testtask'
require 'rake/clean'
require_relative 'lib/dict/reader'
require_relative 'lib/ime/ms'

task default: ['MSIME_dict']

directory 'build'

task 'MSIME_dict' => 'build' do |_t|
  dest = Pathname('build/magica_ime_dict_MSIME.txt')

  entries = Reader.load(Pathname('data/kazumi/puella.yaml'))
  ime_entries = MSIME.convert(entries)

  MSIME.write_file(ime_entries, dest)
end

CLOBBER.include('build/*.txt')
CLOBBER.include('build')

Rake::TestTask.new do |t|
  t.test_files = Dir['spec/**/test_*.rb']
  t.verbose = true
end
