require 'Parser'

describe 'Parser' do
  describe '#parse' do
    it 'should return AST for returning 4' do
      tokens_list = [
        Token.new(:type, :INT),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:integer_constant, 4),
        Token.new(:end)
      ]

      expected_ast = ASTree.new(
        Program.new(
          Function.new(
            'main',
            Return.new(
              IntegerConstant.new(4)))))

      actual_ast = Parser.parse(tokens_list)

      expect(actual_ast).to eq expected_ast
    end

    it 'should return AST for returning 3' do
      tokens_list = [
        Token.new(:type, :INT),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:integer_constant, 6),
        Token.new(:end)
      ]

      expected_ast = ASTree.new(
        Program.new(
          Function.new(
            'main',
            Return.new(
              IntegerConstant.new(6)))))

      actual_ast = Parser.parse(tokens_list)

      expect(actual_ast).to eq expected_ast
    end
  end
end
