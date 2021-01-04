# frozen_string_literal: true

require 'pathname'
require 'rake/testtask'
require 'rake/clean'
require_relative 'lib/dict/reader'
require_relative 'lib/ime/ms'
require_relative 'lib/ime/atok'

task default: %w[MSIME_dict ATOK_dict]

directory 'build'

desc 'MSIME用の辞書ファイルの生成'
task 'MSIME_dict' => 'build' do |_t|
  dest = Pathname('build/magica_ime_dict_MSIME.txt')

  entries = puella_all_name_list
  ime_entries = MSIME.convert(entries)

  MSIME.write_file(ime_entries, dest)
end

desc 'ATOK用の辞書ファイルの生成'
task 'ATOK_dict' => 'build' do |_t|
  dest = Pathname('build/magica_ime_dict_ATOK.txt')

  entries = puella_all_name_list
  ime_entries = ATOK.convert(entries)

  ATOK.write_file(ime_entries, dest)
end

def puella_all_name_list
  puella_name_files
    .map { |file| Pathname(file) }
    .map { |path| Reader.load(path) }
    .flatten
end

def puella_name_files
  json_path = Pathname('.vscode/settings.json')
  YAML.load_file(json_path.to_s).dig('yaml.schemas', './schema/namelist.json')
end

CLOBBER.include('build/*.txt')
CLOBBER.include('build')

Rake::TestTask.new do |t|
  t.test_files = Dir['spec/**/test_*.rb']
  t.verbose = true
end
