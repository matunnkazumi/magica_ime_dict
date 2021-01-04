# frozen_string_literal: true

target :lib do
  signature 'sig'

  # Directory name
  check 'lib'

  # File name
  # check "Gemfile"
  # check "Rakefile"

  library 'pathname', 'csv', 'forwardable'
end

target :spec do
  signature 'sig', 'sig-private'

  check 'spec'

  library 'pathname'
  typing_options :lenient
end