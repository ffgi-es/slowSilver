require 'lexer'
require 'token'

describe 'Lexer' do
  describe '#lex' do
    it 'should contain a string constant token for strings1.sag' do
      in_file = File.expand_path '../fixtures/strings1.sag', File.dirname(__FILE__)

      lexer = Lexer.new(in_file)
      expect(lexer.lex).to include(Token.new(:string_constant, 'Hello, World!'))
    end
  end
end
