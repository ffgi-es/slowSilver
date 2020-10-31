require_relative 'shared'

describe 'equals compiler tests' do
  include_context 'compiling test'

  [
    ['simple_comparison1.sag', 1],
    ['simple_comparison2.sag', 0]
  ]
    .each { |(file, exit_code)| include_examples 'exit code', file, exit_code }
end
