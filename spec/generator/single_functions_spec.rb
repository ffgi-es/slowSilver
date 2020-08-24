require 'generator'
require 'ast'
require_relative 'code_generation'

describe 'Generator' do
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
          #{CodeGen.exit "rax"}

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
          #{CodeGen.exit "rax"}

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
          #{CodeGen.exit "rax"}

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
          #{CodeGen.exit "rax"}

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
          #{CodeGen.exit "rax"}

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
end
