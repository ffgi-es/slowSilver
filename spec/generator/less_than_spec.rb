require 'generator'
require 'ast'
require_relative 'code_generation'

describe 'Generator' do
  describe 'less_than' do
    let('ast') do
      ASTree.new(
        Program.new(
          Function.new(
            'blam',
            Clause.new(
              nil,
              Return.new(
                Expression.new(
                  :<,
                  IntegerConstant.new(1),
                  IntegerConstant.new(2)))))))
    end

    subject { Generator.new(ast) }

    describe '#code' do
      it 'should return the expected code' do
        expected_asm = <<~ASM
          SECTION .text
          global _blam

          _blam:
              mov     rax, 2
              push    rax
              mov     rax, 1
              pop     rcx
          #{CodeGen.compare 'rcx', 'setl'}
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

  describe 'less_than_equal' do
    let('ast') do
      ASTree.new(
        Program.new(
          Function.new(
            'blam',
            Clause.new(
              nil,
              Return.new(
                Expression.new(
                  :<=,
                  IntegerConstant.new(1),
                  IntegerConstant.new(2)))))))
    end

    subject { Generator.new(ast) }

    describe '#code' do
      it 'should return the expected code' do
        expected_asm = <<~ASM
          SECTION .text
          global _blam

          _blam:
              mov     rax, 2
              push    rax
              mov     rax, 1
              pop     rcx
          #{CodeGen.compare 'rcx', 'setle'}
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
