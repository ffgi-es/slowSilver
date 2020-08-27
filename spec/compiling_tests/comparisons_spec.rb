require_relative 'shared'

describe 'equals compiler tests' do
  include_context 'compiling test'

  [
    [ 'simple_comparison1.sag', 1],
    [ 'simple_comparison2.sag', 0],
    [ 'simple_nested_comparison1.sag', 1],
    [ 'simple_nested_comparison2.sag', 0],
    [ 'simple_nested_comparison3.sag', 1],
  ]
    .each { |(file, exit_code)| include_examples 'exit code', file, exit_code }
end
