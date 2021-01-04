# frozen_string_literal: true

#
# These codes are licensed under CC0.
# http://creativecommons.org/publicdomain/zero/1.0/deed.ja
#

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
