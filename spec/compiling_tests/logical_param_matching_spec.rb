require_relative 'shared'

describe 'logial parameter conditions compiler tests' do
  include_context 'compiling test'

  [
    ['logical_param_matching1.sag', 20],
    ['logical_param_matching2.sag', 10],
    ['logical_param_matching3.sag', 3],
    ['logical_param_matching4.sag', 1],
    ['logical_param_matching5.sag', 8],
    ['logical_param_matching6.sag', 2],
    ['logical_param_matching7.sag', 5],
    ['logical_param_matching8.sag', 14]
  ]
    .each { |(file, exit_code)| include_examples 'exit code', file, exit_code }
end
