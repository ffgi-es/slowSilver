require_relative 'shared'

describe 'return_type_mismatch1.sag' do
  include_context 'component test', 'fixtures/return_type_mismatch1.sag'

  include_examples 'validation error', <<~ERROR
    function ':=' returns BOOL, not INT
  ERROR
end

describe 'return_type_mismatch2.sag' do
  include_context 'component test', 'fixtures/return_type_mismatch2.sag'

  include_examples 'validation error', <<~ERROR
    function ':-' returns INT, not BOOL
  ERROR
end

describe 'return_type_mismatch3.sag' do
  include_context 'component test', 'fixtures/return_type_mismatch3.sag'

  include_examples 'validation error', <<~ERROR
    'true' is a BOOL, not INT
  ERROR
end
