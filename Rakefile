# frozen_string_literal: true

require 'pathname'
require 'rake/testtask'
require 'rake/clean'
require_relative 'lib/dict/reader'
require_relative 'lib/ime/ms'
require_relative 'lib/ime/atok'
require_relative 'lib/ime/mac'
require_relative 'lib/ime/google'

task default: %w[MSIME_data ATOK_data Mac_data Google_data]

directory 'build'

desc 'MSIME用の辞書ファイルの生成'
task 'MSIME_data' => 'build' do |_t|
  dest = Pathname('build/magica_ime_data_MSIME.txt')

  entries = puella_all_name_list
  ime_entries = IME::MSIME.convert(entries)

  IME::MSIME.write_file(ime_entries, dest)
end

desc 'ATOK用の辞書ファイルの生成'
task 'ATOK_data' => 'build' do |_t|
  dest = Pathname('build/magica_ime_data_ATOK.txt')

  entries = puella_all_name_list
  ime_entries = IME::ATOK.convert(entries)

  IME::ATOK.write_file(ime_entries, dest)
end

desc 'Mac用の辞書ファイルの生成'
task 'Mac_data' => 'build' do |_t|
  dest = Pathname('build/magica_ime_data_Mac.txt')

  entries = puella_all_name_list
  ime_entries = IME::MAC.convert(entries)

  IME::MAC.write_file(ime_entries, dest)
end

desc 'Google日本語入力用の辞書ファイルの生成'
task 'Google_data' => 'build' do |_t|
  dest = Pathname('build/magica_ime_data_GoogleIME.txt')

  entries = puella_all_name_list
  ime_entries = IME::GoogleIME.convert(entries)

  IME::GoogleIME.write_file(ime_entries, dest)
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
