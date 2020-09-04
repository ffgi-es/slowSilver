require 'generator'
require 'ast'
require_relative 'code_generation'

describe 'Generator' do
  describe 'addition' do
    let('ast') do
      ASTree.new(
        Program.new(
          Function.new(
            'blam',
            Clause.new(
              Return.new(
                Expression.new(
                  :+,
                  IntegerConstant.new(4),
                  IntegerConstant.new(8)))))))
    end

    subject { Generator.new(ast) }

    describe '#code' do
      it 'should return the expected code' do
        expected_asm = <<~ASM
          SECTION .text
          global _blam

          _blam:
              mov     rax, 8
              push    rax
              mov     rax, 4
              pop     rcx
              add     rax, rcx
          #{CodeGen.exit 'rax'}
        ASM

        expect(subject.code).to eq expected_asm
      end
    end

    describe '#entry_point' do
      it 'should return the entry function' do
        expected_entry = '_blam'
        expect(subject.entry_point).to eq expected_entry
      end
    end
  end
end
