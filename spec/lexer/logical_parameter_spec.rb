require 'lexer'
require 'token'

describe 'Lexer' do
  describe '#lex' do
    it 'should contain a condition token for logical_param_matching1.sag' do
      in_file = File.expand_path '../fixtures/logical_param_matching1.sag', File.dirname(__FILE__)

      lexer = Lexer.new(in_file)
      expect(lexer.lex).to include(Token.new(:condition))
    end
  end
end
