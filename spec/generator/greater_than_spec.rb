require 'generator'
require 'ast'
require_relative 'code_generation'

describe 'Generator' do
  describe 'greater than' do
    let('ast') do
      ASTree.new(
        Program.new(
          MatchFunction.new(
            'blam',
            Clause.new(
              Return.new(
                Expression.new(
                  :>,
                  IntegerConstant.new(4),
                  IntegerConstant.new(3)))))))
    end

    subject { Generator.new(ast) }

    describe '#code' do
      it 'should return the expected code' do
        expected_asm = <<~ASM
          SECTION .text
          global _blam

          _blam:
              mov     rax, 3
              push    rax
              mov     rax, 4
              pop     rcx
          #{CodeGen.compare 'rcx', 'setg'}
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

  describe 'greater than equal' do
    let('ast') do
      ASTree.new(
        Program.new(
          MatchFunction.new(
            'blam',
            Clause.new(
              Return.new(
                Expression.new(
                  :>=,
                  IntegerConstant.new(4),
                  IntegerConstant.new(3)))))))
    end

    subject { Generator.new(ast) }

    describe '#code' do
      it 'should return the expected code' do
        expected_asm = <<~ASM
          SECTION .text
          global _blam

          _blam:
              mov     rax, 3
              push    rax
              mov     rax, 4
              pop     rcx
          #{CodeGen.compare 'rcx', 'setge'}
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
