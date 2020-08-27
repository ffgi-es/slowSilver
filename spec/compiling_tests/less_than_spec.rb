require_relative 'shared'

describe 'less than compiler tests' do
  include_context 'compiling test'

  [
    ['less_than1.sag', 1],
    ['less_than2.sag', 0],
    ['less_than3.sag', 0],
    ['less_than_equal1.sag', 1],
    ['less_than_equal2.sag', 1],
    ['less_than_equal3.sag', 0]
  ]
    .each { |(file, exit_code)| include_examples 'exit code', file, exit_code }
end
