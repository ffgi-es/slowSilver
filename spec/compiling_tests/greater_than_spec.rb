require_relative 'shared'

describe 'greater than compiler tests' do
  include_context 'compiling test'

  [
    ['greater_than1.sag', 1],
    ['greater_than2.sag', 0],
    ['greater_than3.sag', 0],
    ['greater_than_equal1.sag', 1],
    ['greater_than_equal2.sag', 1],
    ['greater_than_equal3.sag', 0]
  ]
    .each { |(file, exit_code)| include_examples 'exit code', file, exit_code }
end
