require_relative 'shared'

describe 'subtraction compiler tests' do
  include_context 'compiling test'

  include_examples 'exit code', 'subtraction1.sag', 3
end
