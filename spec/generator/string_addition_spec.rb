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
                  Expression.new(
                    :concat,
                    StringConstant.new('This plus'),
                    StringConstant.new(' that'))))))))
    end

    subject { Generator.new(ast) }

    describe '#code' do
      it 'should return the expected code' do
        expected_asm = <<~ASM
          #{CodeGen.externs}

          SECTION .text
          global _main

          _main:
              call    init
              mov     rax, str1
              push    rax
              mov     rax, str0
          #{CodeGen.concat}
          #{CodeGen.print 'rax'}
          #{CodeGen.exit 'rax'}

          SECTION .data
          str0l   dd 9
          str0    db 'This plus'
          str1l   dd 5
          str1    db ' that'
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
