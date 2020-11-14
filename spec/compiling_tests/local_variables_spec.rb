require_relative 'shared'

describe 'addition compiler tests' do
  include_context 'compiling test'

  [
    ['local_variables1.sag', 15]
  ]
    .each { |(file, exit_code)| include_examples 'exit code', file, exit_code }

  [
    ['local_variables2.sag', 0, 'Hello, Variable!']
  ]
    .each { |(file, exit_code, output)| include_examples 'output', file, exit_code, output }
end
