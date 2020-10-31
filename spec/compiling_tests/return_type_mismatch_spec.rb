require_relative 'shared'

describe 'parameter type mismatch compiler tests' do
  include_context 'compiling test'

  [
    [
      'return_type_mismatch1.sag',
      <<~ERROR
        function ':=' returns BOOL, not INT
      ERROR
    ]
  ]
    .each { |(file, error_msg)| include_examples 'error', file, error_msg }
end
