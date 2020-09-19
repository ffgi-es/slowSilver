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
              movsx   rdx, DWORD [rax-4]
              mov     rdi, 1
              mov     rax, 1
              syscall
              xor     rax, rax
          #{CodeGen.exit 'rax'}

          SECTION .data
          str0l   dd 13
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

  describe 'print multiple strings' do
    let('ast') do
      ASTree.new(
        Program.new(
          Function.new(
            'main',
            Clause.new(
              nil,
              Return.new(
                Expression.new(
                  :enough,
                  IntegerConstant.new(15))))),
          Function.new(
            'enough',
            Clause.new(
              Parameter.new(:X),
              Expression.new(
                :<,
                Variable.new(:X),
                IntegerConstant.new(20)),
              Return.new(
                Expression.new(
                  :print,
                  StringConstant.new('too few')))),
            Clause.new(
              Parameter.new(:X),
              Expression.new(
                :<,
                Variable.new(:X),
                IntegerConstant.new(30)),
              Return.new(
                Expression.new(
                  :print,
                  StringConstant.new('enough')))),
            Clause.new(
              Parameter.new(:X),
              nil,
              Return.new(
                Expression.new(
                  :print,
                  StringConstant.new('too many')))))))
    end

    subject { Generator.new(ast) }

    describe '#code' do
      it 'should return the expected code' do
        expected_asm = <<~ASM
          SECTION .data
          str0l   dd 7
          str0    db 'too few'
          str1l   dd 6
          str1    db 'enough'
          str2l   dd 8
          str2    db 'too many'
        ASM

        expect(subject.code).to include expected_asm
      end
    end
  end
end
