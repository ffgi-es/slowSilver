require 'generator'
require 'ast'
require_relative 'code_generation'

describe 'Generator' do
  describe 'param condition functions' do
    let('ast') do
      ASTree.new(
        Program.new(
          Function.new(
            'main',
            Clause.new(
              nil,
              Return.new(
                Expression.new(
                  :limit,
                  IntegerConstant.new(17))))),
          Function.new(
            'limit',
            Clause.new(
              Parameter.new(:X),
              Expression.new(
                :>,
                Variable.new(:X),
                IntegerConstant.new(5)),
              Return.new(
                IntegerConstant.new(0))),
            Clause.new(
              Parameter.new(:X),
              nil,
              Return.new(
                Variable.new(:X))))))
    end

    subject { Generator.new(ast) }

    describe '#code' do
      it 'should return the expected code' do
        expected_asm = <<~ASM
          SECTION .text
          global _main

          _main:
              mov     rax, 17
              push    rax
              call    _limit
              add     rsp, 8
          #{CodeGen.exit 'rax'}

          _limit:
              push    rbp
              mov     rbp, rsp
          _limit0:
              mov     rax, 5
              push    rax
              mov     rax, [rbp+16]
              pop     rcx
          #{CodeGen.compare 'rcx', 'setg'}
              cmp     rax, 1
              jne     _limit1
              mov     rax, 0
              jmp     _limitdone
          _limit1:
              mov     rax, [rbp+16]
          _limitdone:
              mov     rsp, rbp
              pop     rbp
              ret
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
