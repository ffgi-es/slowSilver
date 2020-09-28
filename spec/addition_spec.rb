require 'lexer'
require 'token'
require 'parser'
require 'generator'
require 'pprint'
require_relative 'generator/code_generation'

describe 'addition1.sag' do
  let(:in_file){ File.expand_path 'fixtures/addition1.sag', File.dirname(__FILE__) }
  let(:tokens){ Lexer.new(in_file).lex }
  let(:ast){ Parser.parse(tokens) }
  let(:generated){ Generator.new(ast) }

  describe 'lexing' do
    it 'should return a list of tokens' do
      expected_tokens = [
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:type, :INT),
        Token.new(:entry_function_line),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:integer_constant, 2),
        Token.new(:function_call, '+'),
        Token.new(:integer_constant, 2),
        Token.new(:end)
      ]
      expect(tokens).to eq expected_tokens
    end
  end

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
                  :+,
                  IntegerConstant.new(2),
                  IntegerConstant.new(2)))))))

      expect(PPrinter.format(ast))
        .to eq PPrinter.format(expected_ast)
    end
  end

  describe 'validation' do
    it 'should not raise any errors' do
      expect { ast.validate }.not_to raise_error
    end
  end

  describe 'generation' do
    describe 'code' do
      it 'should return the expected code' do
        expected_asm = <<~ASM
          #{CodeGen.externs}

          SECTION .text
          global _main

          _main:
              call    init
              mov     rax, 2
              push    rax
              mov     rax, 2
              pop     rcx
              add     rax, rcx
          #{CodeGen.exit 'rax'}
        ASM

        expect(generated.code).to eq expected_asm
      end
    end

    describe 'entry point' do
      it 'should return the entry function' do
        expect(generated.entry_point).to eq '_main'
      end
    end
  end
end
