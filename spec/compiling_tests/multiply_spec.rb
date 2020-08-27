require_relative 'shared'

describe 'multiplication compiler tests' do
  include_context 'compiling test'

  include_examples 'exit code', 'multiplication1.sag', 18
end
