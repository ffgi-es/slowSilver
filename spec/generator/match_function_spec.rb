require 'generator'
require 'ast'
require_relative 'code_generation'

describe 'Generator' do
  describe 'param matching functions' do
    let('ast') do
      ASTree.new(
        Program.new(
          Function.new(
            'main',
            Clause.new(
              nil,
              Return.new(
                Expression.new(
                  :fib,
                  IntegerConstant.new(7))))),
          Function.new(
            'fib',
            Clause.new(
              IntegerConstant.new(0),
              nil,
              Return.new(
                IntegerConstant.new(0))),
            Clause.new(
              IntegerConstant.new(1),
              nil,
              Return.new(
                IntegerConstant.new(1))),
            Clause.new(
              Parameter.new(:X),
              nil,
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
          #{CodeGen.exit 'rax'}

          _fib:
              push    rbp
              mov     rbp, rsp
          _fib0:
              mov     rax, 0
              cmp     rax, [rbp+16]
              jne     _fib1
              mov     rax, 0
              jmp     _fibdone
          _fib1:
              mov     rax, 1
              cmp     rax, [rbp+16]
              jne     _fib2
              mov     rax, 1
              jmp     _fibdone
          _fib2:
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

  describe 'param matching functions with 2 parameters' do
    let('ast') do
      ASTree.new(
        Program.new(
          Function.new(
            'main',
            Clause.new(
              nil,
              Return.new(
                Expression.new(
                  :+,
                  Expression.new(
                    :test,
                    IntegerConstant.new(2),
                    IntegerConstant.new(3)),
                  Expression.new(
                    :test,
                    IntegerConstant.new(4),
                    IntegerConstant.new(5)))))),
          Function.new(
            'test',
            Clause.new(
              IntegerConstant.new(2),
              IntegerConstant.new(3),
              nil,
              Return.new(
                IntegerConstant.new(1))),
            Clause.new(
              Parameter.new(:X),
              Parameter.new(:Y),
              nil,
              Return.new(
                Expression.new(
                  :*,
                  Variable.new(:X),
                  Variable.new(:Y)))))))
    end

    subject { Generator.new(ast) }

    describe '#code' do
      it 'should return the expected code' do
        expected_asm = <<~ASM
          SECTION .text
          global _main

          _main:
              mov     rax, 5
              push    rax
              mov     rax, 4
              push    rax
              call    _test
              add     rsp, 16
              push    rax
              mov     rax, 3
              push    rax
              mov     rax, 2
              push    rax
              call    _test
              add     rsp, 16
              pop     rcx
              add     rax, rcx
          #{CodeGen.exit 'rax'}

          _test:
              push    rbp
              mov     rbp, rsp
          _test0:
              mov     rax, 2
              cmp     rax, [rbp+16]
              jne     _test1
              mov     rax, 3
              cmp     rax, [rbp+24]
              jne     _test1
              mov     rax, 1
              jmp     _testdone
          _test1:
              mov     rax, [rbp+24]
              push    rax
              mov     rax, [rbp+16]
              pop     rcx
              imul    rax, rcx
          _testdone:
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
