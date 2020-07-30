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
              mov     rbx, 6
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
              mov     rdx, 4
              push    rdx
              mov     rdx, 8
              pop     rbx
              add     rbx, rdx
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
              mov     rdx, 8
              push    rdx
              mov     rdx, 5
              pop     rbx
              sub     rbx, rdx
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
              mov     rdx, 3
              push    rdx
              mov     rdx, 3
              pop     rcx
              cmp     rcx, rdx
              sete    bl
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
              mov     rcx, 3
              push    rcx
              mov     rcx, 3
              pop     rbx
              cmp     rbx, rcx
              sete    dl
              push    rdx
              mov     rcx, 4
              push    rcx
              mov     rcx, 4
              pop     rbx
              cmp     rbx, rcx
              sete    dl
              pop     rcx
              cmp     rcx, rdx
              sete    bl
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
              mov     rcx, 3
              push    rcx
              mov     rcx, 3
              pop     rbx
              cmp     rbx, rcx
              sete    dl
              cmp     rdx, 0
              sete    bl
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
              mov     rax, 1
              int     80h

          _add:
              mov     rdx, 3
              push    rdx
              mov     rdx, 4
              pop     rbx
              add     rbx, rdx
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
              mov     rdx, 4
              push    rdx
              call    _double
              mov     rax, 1
              int     80h

          _double:
              push    rbp
              mov     rbp, rsp
              mov     rdx, [rbp+16]
              push    rdx
              mov     rdx, [rbp+16]
              pop     rbx
              add     rbx, rdx
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
              mov     rdx, 3
              push    rdx
              mov     rdx, 8
              push    rdx
              call    _plus
              mov     rax, 1
              int     80h

          _plus:
              push    rbp
              mov     rbp, rsp
              mov     rdx, [rbp+24]
              push    rdx
              mov     rdx, [rbp+16]
              pop     rbx
              add     rbx, rdx
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
              mov     rdx, 3
              push    rdx
              mov     rdx, 8
              pop     rbx
              imul    rbx, rdx
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
end
