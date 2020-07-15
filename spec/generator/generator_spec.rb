require 'generator'
require 'parser'

describe 'Generator' do
  let("ast") do
    ASTree.new(
      Program.new(
        Function.new(
          'main',
          Return.new(
            IntegerConstant.new(6)))))
  end

  subject { Generator.new(ast) }

  describe '#code' do
    it 'should return the expected code' do
      expected_asm = <<~ASM
        SECTION .text
        global _main

        _main:
            mov     ebx, 6
            mov     eax, 1
            int     80h
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
