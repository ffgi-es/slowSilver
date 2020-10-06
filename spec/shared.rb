require 'lexer'
require 'token'
require 'parser'
require 'generator'
require 'pprint'
require_relative 'generator/code_generation'

shared_context 'component test' do |file_name|
  let(:in_file) { File.expand_path file_name, File.dirname(__FILE__) }
  let(:tokens) { Lexer.new(in_file).lex }
  let(:ast) { Parser.parse(tokens) }
  let(:generated) { Generator.new(ast) }
end

shared_examples 'lexing' do |expected_tokens|
  describe 'lexing' do
    it 'should return a list of tokens' do
      expect(tokens).to eq expected_tokens
    end
  end
end

shared_examples 'parsing' do |expected_ast|
  describe 'parsing' do
    it 'should return an AST' do
      expect(PPrinter.format(ast))
        .to eq PPrinter.format(expected_ast)
    end
  end
end

shared_examples 'no validation error' do
  describe 'validation' do
    it 'should not raise any errors' do
      expect { ast.validate }.not_to raise_error
    end
  end
end

shared_examples 'validation error' do |error|
  describe 'validation' do
    it 'should return an error for mismatching param types' do
      expect { ast.validate }.to raise_error CompileError, error
    end
  end
end

shared_examples 'generation' do |expected_entry, expected_asm|
  describe 'generation' do
    describe 'code' do
      it 'should return the expected code' do
        expect(generated.code).to eq expected_asm
      end
    end

    describe 'entry point' do
      it 'should return the enry function' do
        expect(generated.entry_point).to eq expected_entry
      end
    end
  end
end
