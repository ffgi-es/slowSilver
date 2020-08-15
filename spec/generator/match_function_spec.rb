require 'generator'
require 'ast'

describe 'Generator' do
  describe 'param matching functions' do
    let('ast') do
      ASTree.new(
        Program.new(
          Function.new(
            'main',
            Return.new(
              Expression.new(
                :fib,
                IntegerConstant.new(7)))),
          MatchFunction.new(
            'fib',
            Clause.new(
              IntegerConstant.new(0),
              Return.new(
                IntegerConstant.new(0))),
            Clause.new(
              IntegerConstant.new(1),
              Return.new(
                IntegerConstant.new(1))),
            Clause.new(
              Parameter.new(:X),
              Return.new(
                Expression.new(
                  :+,
                  Expression.new(
                    :fib,
                    Expression.new(
                      :-,
                      Variable.new(:X),
                      IntegerConstant.new(1))),
                  Expression.new(
                    :fib,
                    Expression.new(
                      :-,
                      Variable.new(:X),
                      IntegerConstant.new(2)))))))))
    end

    subject { Generator.new(ast) }

    describe '#code' do
      it 'should return the expected code' do
        expected_asm = <<~ASM
          SECTION .text
          global _main

          _main:
              mov     rax, 7
              push    rax
              call    _fib
              add     rsp, 8
              mov     rbx, rax
              mov     rax, 1
              int     80h

          _fib:
              push    rbp
              mov     rbp, rsp
              mov     rax, 0
              cmp     rax, [rbp+16]
              je      _fib0
              mov     rax, 1
              cmp     rax, [rbp+16]
              je      _fib1
              mov     rax, 2
              push    rax
              mov     rax, [rbp+16]
              pop     rcx
              sub     rax, rcx
              push    rax
              call    _fib
              add     rsp, 8
              push    rax
              mov     rax, 1
              push    rax
              mov     rax, [rbp+16]
              pop     rcx
              sub     rax, rcx
              push    rax
              call    _fib
              add     rsp, 8
              pop     rcx
              add     rax, rcx
          _fibdone:
              mov     rsp, rbp
              pop     rbp
              ret
          _fib0:
              mov     rax, 0
              jmp     _fibdone
          _fib1:
              mov     rax, 1
              jmp     _fibdone
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
