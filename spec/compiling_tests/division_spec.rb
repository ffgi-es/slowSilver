require_relative 'shared'

describe 'division compiler tests' do
  include_context 'compiling test'

  include_examples 'exit code', 'division1.sag', 4
end
