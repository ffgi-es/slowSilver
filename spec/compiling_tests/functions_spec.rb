require_relative 'shared'

describe 'function compiler tests' do
  include_context 'compiling test'

  [
    ['function1.sag', 7],
    ['function2.sag', 8],
    ['function3.sag', 11],
    ['function4.sag', 9],
    ['nested_functions1.sag', 11],
    ['nested_functions2.sag', 25]
  ]
    .each { |(file, exit_code)| include_examples 'exit code', file, exit_code }
end
