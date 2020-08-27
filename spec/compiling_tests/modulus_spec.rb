require_relative 'shared'

describe 'modulus comiler tests' do
  include_context 'compiling test'

  include_examples 'exit code', 'modulus1.sag', 1
end
