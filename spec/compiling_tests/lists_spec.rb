require_relative 'shared'

describe 'list compiler tests' do
  include_context 'compiling test'

  [
    ['lists1.sag', 0]
  ]
    .each { |(file, exit_code)| include_examples 'exit code', file, exit_code }
end
