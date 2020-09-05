require_relative 'shared'

describe 'addition compiler tests' do
  include_context 'compiling test'

  [
    ['strings1.sag', 0, 'Hello, World!']
  ]
    .each { |(file, exit_code, output)| include_examples 'output', file, exit_code, output }
end
