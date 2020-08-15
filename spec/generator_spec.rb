require 'generator'
require 'parser'

describe 'Generator' do
  describe 'return integer' do
    let('ast') do
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
              mov     rax, 6
              mov     rbx, rax
              mov     rax, 1
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

  describe 'addition' do
    let('ast') do
      ASTree.new(
        Program.new(
          Function.new(
            'blam',
            Return.new(
              Expression.new(
                :+,
                IntegerConstant.new(4),
                IntegerConstant.new(8))))))
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
              mov     rbx, rax
              mov     rax, 1
              int     80h
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

  describe 'subtraction' do
    let('ast') do
      ASTree.new(
        Program.new(
          Function.new(
            'main',
            Return.new(
              Expression.new(
                :-,
                IntegerConstant.new(8),
                IntegerConstant.new(5))))))
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
              mov     rax, 8
              pop     rcx
              sub     rax, rcx
              mov     rbx, rax
              mov     rax, 1
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

  describe 'equal comparison' do
    let('ast') do
      ASTree.new(
        Program.new(
          Function.new(
            'main',
            Return.new(
              Expression.new(
                :"=",
                IntegerConstant.new(3),
                IntegerConstant.new(3))))))
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
              mov     rbx, rax
              pop     rcx
              xor     rax, rax
              cmp     rbx, rcx
              sete    al
              mov     rbx, rax
              mov     rax, 1
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

  describe 'nested equal comparison' do
    let('ast') do
      ASTree.new(
        Program.new(
          Function.new(
            'main',
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
                  IntegerConstant.new(4)))))))
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
              mov     rbx, rax
              pop     rcx
              xor     rax, rax
              cmp     rbx, rcx
              sete    al
              push    rax
              mov     rax, 3
              push    rax
              mov     rax, 3
              mov     rbx, rax
              pop     rcx
              xor     rax, rax
              cmp     rbx, rcx
              sete    al
              mov     rbx, rax
              pop     rcx
              xor     rax, rax
              cmp     rbx, rcx
              sete    al
              mov     rbx, rax
              mov     rax, 1
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

  describe 'boolean negation' do
    let('ast') do
      ASTree.new(
        Program.new(
          Function.new(
            'main',
            Return.new(
              Expression.new(
                :!,
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
              mov     rbx, rax
              pop     rcx
              xor     rax, rax
              cmp     rbx, rcx
              sete    al
              mov     rbx, rax
              xor     rax, rax
              cmp     rbx, 0
              sete    al
              mov     rbx, rax
              mov     rax, 1
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

  describe 'multiple functions' do
    let('ast') do
      ASTree.new(
        Program.new(
          Function.new(
            'main',
            Return.new(
              Expression.new(:add))),
          Function.new(
            'add',
            Return.new(
              Expression.new(
                :+,
                IntegerConstant.new(3),
                IntegerConstant.new(4))))))
    end

    subject { Generator.new(ast) }

    describe '#code' do
      it 'should return the expected code' do
        expected_asm = <<~ASM
          SECTION .text
          global _main

          _main:
              call    _add
              mov     rbx, rax
              mov     rax, 1
              int     80h

          _add:
              mov     rax, 4
              push    rax
              mov     rax, 3
              pop     rcx
              add     rax, rcx
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

  describe 'function with parameter' do
    let('ast') do
      ASTree.new(
        Program.new(
          Function.new(
            'main',
            Return.new(
              Expression.new(
                :double,
                IntegerConstant.new(4)))),
          Function.new(
            'double',
            Parameter.new(:X),
            Return.new(
              Expression.new(
                :+,
                Variable.new(:X),
                Variable.new(:X))))))
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
              call    _double
              add     rsp, 8
              mov     rbx, rax
              mov     rax, 1
              int     80h

          _double:
              push    rbp
              mov     rbp, rsp
              mov     rax, [rbp+16]
              push    rax
              mov     rax, [rbp+16]
              pop     rcx
              add     rax, rcx
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

  describe 'function with two parameters' do
    let('ast') do
      ASTree.new(
        Program.new(
          Function.new(
            'main',
            Return.new(
              Expression.new(
                :plus,
                IntegerConstant.new(3),
                IntegerConstant.new(8)))),
          Function.new(
            'plus',
            Parameter.new(:A),
            Parameter.new(:B),
            Return.new(
              Expression.new(
                :+,
                Variable.new(:A),
                Variable.new(:B))))))
    end

    subject { Generator.new(ast) }

    describe '#code' do
      it 'should return the expected code' do
        expected_asm = <<~ASM
          SECTION .text
          global _main

          _main:
              mov     rax, 8
              push    rax
              mov     rax, 3
              push    rax
              call    _plus
              add     rsp, 16
              mov     rbx, rax
              mov     rax, 1
              int     80h

          _plus:
              push    rbp
              mov     rbp, rsp
              mov     rax, [rbp+24]
              push    rax
              mov     rax, [rbp+16]
              pop     rcx
              add     rax, rcx
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

  describe 'multiplication' do
    let('ast') do
      ASTree.new(
        Program.new(
          Function.new(
            'main',
            Return.new(
              Expression.new(
                :*,
                IntegerConstant.new(3),
                IntegerConstant.new(8))))))
    end

    subject { Generator.new(ast) }

    describe '#code' do
      it 'should return the expected code' do
        expected_asm = <<~ASM
          SECTION .text
          global _main

          _main:
              mov     rax, 8
              push    rax
              mov     rax, 3
              pop     rcx
              imul    rax, rcx
              mov     rbx, rax
              mov     rax, 1
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

  describe 'division' do
    let('ast') do
      ASTree.new(
        Program.new(
          Function.new(
            'main',
            Return.new(
              Expression.new(
                :/,
                IntegerConstant.new(8),
                IntegerConstant.new(2))))))
    end

    subject { Generator.new(ast) }

    describe '#code' do
      it 'should return the expected code' do
        expected_asm = <<~ASM
          SECTION .text
          global _main

          _main:
              mov     rax, 2
              push    rax
              mov     rax, 8
              pop     rcx
              idiv    rcx
              mov     rbx, rax
              mov     rax, 1
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

  describe 'modulus' do
    let('ast') do
      ASTree.new(
        Program.new(
          Function.new(
            'main',
            Return.new(
              Expression.new(
                :%,
                IntegerConstant.new(9),
                IntegerConstant.new(2))))))
    end

    subject { Generator.new(ast) }

    describe '#code' do
      it 'should return the expected code' do
        expected_asm = <<~ASM
          SECTION .text
          global _main

          _main:
              mov     rax, 2
              push    rax
              mov     rax, 9
              pop     rcx
              idiv    rcx
              mov     rax, rdx
              mov     rbx, rax
              mov     rax, 1
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

  describe 'function with three parameters' do
    let('ast') do
      ASTree.new(
        Program.new(
          Function.new(
            'main',
            Return.new(
              Expression.new(
                :sum,
                IntegerConstant.new(3),
                IntegerConstant.new(8),
                IntegerConstant.new(4)))),
          Function.new(
            'sum',
            Parameter.new(:A),
            Parameter.new(:B),
            Parameter.new(:C),
            Return.new(
              Expression.new(
                :+,
                Expression.new(
                  :+,
                  Variable.new(:A),
                  Variable.new(:B)),
                Variable.new(:C))))))
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
              mov     rax, 8
              push    rax
              mov     rax, 3
              push    rax
              call    _sum
              add     rsp, 24
              mov     rbx, rax
              mov     rax, 1
              int     80h

          _sum:
              push    rbp
              mov     rbp, rsp
              mov     rax, [rbp+32]
              push    rax
              mov     rax, [rbp+24]
              push    rax
              mov     rax, [rbp+16]
              pop     rcx
              add     rax, rcx
              pop     rcx
              add     rax, rcx
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

  describe 'nested functions' do
    let('ast') do
      ASTree.new(
        Program.new(
          Function.new(
            'main',
            Return.new(
              Expression.new(
                :sum,
                IntegerConstant.new(3),
                IntegerConstant.new(8),
                IntegerConstant.new(4)))),
          Function.new(
            'sum',
            Parameter.new(:A),
            Parameter.new(:B),
            Parameter.new(:C),
            Return.new(
              Expression.new(
                :-,
                Variable.new(:A),
                Expression.new(
                  :add,
                  Variable.new(:B),
                  Variable.new(:C))))),
          Function.new(
            'add',
            Parameter.new(:X),
            Parameter.new(:Y),
            Return.new(
              Expression.new(
                :+,
                Variable.new(:X),
                Variable.new(:Y))))))
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
              mov     rax, 8
              push    rax
              mov     rax, 3
              push    rax
              call    _sum
              add     rsp, 24
              mov     rbx, rax
              mov     rax, 1
              int     80h

          _sum:
              push    rbp
              mov     rbp, rsp
              mov     rax, [rbp+32]
              push    rax
              mov     rax, [rbp+24]
              push    rax
              call    _add
              add     rsp, 16
              push    rax
              mov     rax, [rbp+16]
              pop     rcx
              sub     rax, rcx
              mov     rsp, rbp
              pop     rbp
              ret

          _add:
              push    rbp
              mov     rbp, rsp
              mov     rax, [rbp+24]
              push    rax
              mov     rax, [rbp+16]
              pop     rcx
              add     rax, rcx
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
