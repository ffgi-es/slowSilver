require_relative 'shared'

describe 'parameter matching compiler tests' do
  include_context 'compiling test'

  [
    ['params_matching1.sag', 13],
    ['params_matching2.sag', 21],
    ['params_matching3.sag', 28],
    ['params_matching4.sag', 24],
    ['params_matching5.sag', 1],
    ['mixed_param_matching.sag', 89]
  ]
    .each { |(file, exit_code)| include_examples 'exit code', file, exit_code }
end
