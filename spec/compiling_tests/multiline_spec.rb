require_relative 'shared'

describe 'multiline compiler tests' do
  include_context 'compiling test'

  include_examples 'exit code', 'multiline1.sag', 27
end
