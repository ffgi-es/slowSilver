require_relative 'shared'

describe 'addition compiler tests' do
  include_context 'compiling test'

  [
    [ 'addition1.sag', 4],
    [ 'addition2.sag', 5],
    [ 'addition3.sag', 1],
  ]
    .each { |(file, exit_code)| include_examples 'exit code', file, exit_code }
end
