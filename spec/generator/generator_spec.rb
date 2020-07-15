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
end
