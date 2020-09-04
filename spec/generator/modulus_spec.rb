require 'generator'
require 'ast'
require_relative 'code_generation'

describe 'Generator' do
  describe 'modulus' do
    let('ast') do
      ASTree.new(
        Program.new(
          Function.new(
            'main',
            Clause.new(
              Return.new(
                Expression.new(
                  :%,
                  IntegerConstant.new(9),
                  IntegerConstant.new(2)))))))
    end

    subject { Generator.new(ast) }

    describe '#code' do
      it 'should return the expected code' do
        expected_asm = <<~ASM
          SECTION .text
          global _main

          _main:
              mov     rax, 2
              push    rax
              mov     rax, 9
              pop     rcx
              idiv    rcx
              mov     rax, rdx
          #{CodeGen.exit 'rax'}
        ASM

        expect(subject.code).to eq expected_asm
      end
    end

    describe '#entry_point' do
      it 'should return the entry function' do
        expected_entry = '_main'
        expect(subject.entry_point).to eq expected_entry
      end
    end
  end
end
