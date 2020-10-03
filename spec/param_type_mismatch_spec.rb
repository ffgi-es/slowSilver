require 'compile_error'
require 'parser'
require 'pprint'
require 'lexer'

describe 'parameter_type_mismatch1.sag' do
  let(:in_file) { File.expand_path 'fixtures/parameter_type_mismatch1.sag', File.dirname(__FILE__) }
  let(:tokens) { Lexer.new(in_file).lex }
  let(:ast) { Parser.parse(tokens) }

  describe 'parsing' do
    it 'should return an AST' do
      expected_ast = ASTree.new(
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

      expect(PPrinter.format(ast))
        .to eq PPrinter.format(expected_ast)
    end
  end

  describe 'AST validation' do
    it 'should return an error for mismatching param types' do
      expect { ast.validate }.to raise_error CompileError, <<~ERROR
        test expects 2 parameters: INT, INT
        received: INT, STRING
      ERROR
    end
  end
end
