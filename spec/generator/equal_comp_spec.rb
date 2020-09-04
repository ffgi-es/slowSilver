require 'generator'
require 'ast'
require_relative 'code_generation'

describe 'Generator' do
  describe 'equal comparison' do
    let('ast') do
      ASTree.new(
        Program.new(
          Function.new(
            'main',
            Clause.new(
              Return.new(
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
              pop     rcx
          #{CodeGen.compare 'rcx'}
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

  describe 'nested equal comparison' do
    let('ast') do
      ASTree.new(
        Program.new(
          Function.new(
            'main',
            Clause.new(
              Return.new(
                Expression.new(
                  :"=",
                  Expression.new(
                    :"=",
                    IntegerConstant.new(3),
                    IntegerConstant.new(3)),
                  Expression.new(
                    :"=",
                    IntegerConstant.new(4),
                    IntegerConstant.new(4))))))))
    end

    subject { Generator.new(ast) }

    describe '#code' do
      it 'should return the expected code' do
        expected_asm = <<~ASM
          SECTION .text
          global _main

          _main:
              mov     rax, 4
              push    rax
              mov     rax, 4
              pop     rcx
          #{CodeGen.compare 'rcx'}
              push    rax
              mov     rax, 3
              push    rax
              mov     rax, 3
              pop     rcx
          #{CodeGen.compare 'rcx'}
              pop     rcx
          #{CodeGen.compare 'rcx'}
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
