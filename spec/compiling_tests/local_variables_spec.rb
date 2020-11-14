require_relative 'shared'

describe 'addition compiler tests' do
  include_context 'compiling test'

  [
    ['local_variables1.sag', 15]
  ]
    .each { |(file, exit_code)| include_examples 'exit code', file, exit_code }
end
