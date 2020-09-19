require_relative 'shared'

describe 'string addition compiler tests' do
  include_context 'compiling test'

  [
    ['string_addition1.sag', 0, 'This plus that'],
  ]
    .each { |(file, exit_code, output)| include_examples 'output', file, exit_code, output }
end
