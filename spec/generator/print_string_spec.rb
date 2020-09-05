require 'generator'
require 'ast'
require_relative 'code_generation'

describe 'Generator' do
  describe 'print string' do
    let('ast') do
      ASTree.new(
        Program.new(
          Function.new(
            'main',
            Clause.new(
              nil,
              Return.new(
                Expression.new(
                  :print,
                  StringConstant.new('Hello, World!')))))))
    end

    subject { Generator.new(ast) }

    describe '#code' do
      it 'should return the expected code' do
        expected_asm = <<~ASM
          SECTION .text
          global _main

          _main:
              mov     rax, str0
              mov     rsi, rax
              mov     rdi, rax
              xor     rax, rax
              mov     rcx, -1
              cld
          repne scasb
              not     rcx
              dec     rcx
              mov     rdx, rcx
              mov     rdi, 1
              mov     rax, 1
              syscall
              xor     rax, rax
          #{CodeGen.exit 'rax'}

          SECTION .data
          str0    db 'Hello, World!'
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
