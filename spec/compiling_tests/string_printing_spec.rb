require_relative 'shared'

describe 'string printing compiler tests' do
  include_context 'compiling test'

  [
    ['strings1.sag', 0, 'Hello, World!'],
    ['strings2.sag', 0, 'too few'],
    ['strings3.sag', 0, 'enough'],
    ['strings4.sag', 0, 'too many']
  ]
    .each { |(file, exit_code, output)| include_examples 'output', file, exit_code, output }
end
