require_relative 'shared'

describe 'nested expression comìler tests' do
  include_context 'compiling test'

  include_examples 'exit code', 'nested_expression1.sag', 10
end
