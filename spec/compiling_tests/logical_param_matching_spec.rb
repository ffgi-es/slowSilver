require_relative 'shared'

describe 'logial parameter conditions compiler tests' do
  include_context 'compiling test'

  [
    ['logical_param_matching1.sag', 20],
    ['logical_param_matching2.sag', 10],
    ['logical_param_matching3.sag', 3],
    ['logical_param_matching4.sag', 1]
  ]
    .each { |(file, exit_code)| include_examples 'exit code', file, exit_code }
end
