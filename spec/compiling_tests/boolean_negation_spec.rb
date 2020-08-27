require_relative 'shared'

describe 'boolean not compiler tests' do
  include_context 'compiling test'

  [
    [ 'not1.sag', 1],
    [ 'not2.sag', 0]
  ]
    .each { |(file, exit_code)| include_examples 'exit code', file, exit_code }
end
