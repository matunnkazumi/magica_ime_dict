# frozen_string_literal: true

#
# These codes are licensed under CC0.
# http://creativecommons.org/publicdomain/zero/1.0/deed.ja
#

D = Steep::Diagnostic

target :lib do
  signature 'sig'

  check 'lib'

  library 'pathname'
end

target :settings do
  signature 'sig'

  check 'Gemfile'
  check 'Rakefile'

  library 'pathname'

  configure_code_diagnostics(D::Ruby.lenient)
end

target :spec do
  signature 'sig', 'sig-private'

  check 'spec'

  library 'pathname'

  configure_code_diagnostics(D::Ruby.lenient)
end
