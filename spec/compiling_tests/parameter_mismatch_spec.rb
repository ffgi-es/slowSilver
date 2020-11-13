require_relative 'shared'

describe 'parameter type mismatch compiler tests' do
  include_context 'compiling test'

  [
    [
      'parameter_type_mismatch1.sag',
      <<~ERROR
        function ':test' expects 2 parameters: INT, INT
        received: INT, STRING
      ERROR
    ],
    [
      'parameter_count_mismatch1.sag',
      <<~ERROR
        function ':two' expects 2 parameters, received 1
      ERROR
    ]
  ]
    .each { |(file, error_msg)| include_examples 'error', file, error_msg }
end
