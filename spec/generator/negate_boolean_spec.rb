require 'generator'
require 'ast'
require_relative 'code_generation'

describe 'Generator' do
  describe 'boolean negation' do
    let('ast') do
      ASTree.new(
        Program.new(
          Function.new(
            'main',
            Return.new(
              Expression.new(
                :!,
                Expression.new(
                  :"=",
                  IntegerConstant.new(3),
                  IntegerConstant.new(3)))))))
    end

    subject { Generator.new(ast) }

    describe '#code' do
      it 'should return the expected code' do
        expected_asm = <<~ASM
          SECTION .text
          global _main

          _main:
              mov     rax, 3
              push    rax
              mov     rax, 3
              mov     rbx, rax
              pop     rcx
              xor     rax, rax
              cmp     rbx, rcx
              sete    al
              mov     rbx, rax
              xor     rax, rax
              cmp     rbx, 0
              sete    al
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
