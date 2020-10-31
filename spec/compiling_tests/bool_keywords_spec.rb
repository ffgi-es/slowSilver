require_relative 'shared'

describe 'addition compiler tests' do
  include_context 'compiling test'

  [
    ['true_keyword.sag', 1],
    ['false_keyword.sag', 0]
  ]
    .each { |(file, exit_code)| include_examples 'exit code', file, exit_code }
end
