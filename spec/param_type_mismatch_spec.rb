require_relative 'shared'

describe 'parameter_type_mismatch1.sag' do
  include_context 'component test', 'fixtures/parameter_type_mismatch1.sag'

  include_examples 'parsing', ASTree.new(
    Program.new(
      Function.new(
        'main',
        { [] => :INT },
        Clause.new(
          nil,
          Return.new(
            Expression.new(
              :test,
              IntegerConstant.new(3),
              StringConstant.new('hello'))))),
      Function.new(
        'test',
        { %i[INT INT] => :INT },
        Clause.new(
          Parameter.new(:X),
          Parameter.new(:Y),
          nil,
          Return.new(
            Expression.new(
              :+,
              Variable.new(:X),
              Variable.new(:Y)))))))

  include_examples 'validation error', <<~ERROR
    test expects 2 parameters: INT, INT
    received: INT, STRING
  ERROR
end

describe 'parameter_type_mismatch2.sag' do
  include_context 'component test', 'fixtures/parameter_type_mismatch2.sag'

  include_examples 'validation error', <<~ERROR
    - expects 2 parameters: INT, INT
    received: INT, STRING
  ERROR
end
