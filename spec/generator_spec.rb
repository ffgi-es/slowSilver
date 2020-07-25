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
end
