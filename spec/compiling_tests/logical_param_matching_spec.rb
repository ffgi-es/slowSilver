require_relative 'shared'

describe 'logial parameter conditions compiler tests' do
  include_context 'compiling test'

  [
    ['logical_param_matching1.sag', 20]
  ]
    .each { |(file, exit_code)| include_examples 'exit code', file, exit_code }
end
