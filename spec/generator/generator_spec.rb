require "Generator"

describe "Generator" do
  describe "#generate_asm" do
    it "should generate simple ASM from an AST" do
      ast = ASTree.new(
        Program.new(
          Function.new(
            'main',
            Return.new(
              IntegerConstant.new(6)))))

      expected_asm = <<~END
        SECTION .text
        global _main

        _main:
            mov     ebx, 6
            mov     eax, 1
            int     80h
      END

      expect(Generator.generate_asm ast).to eq expected_asm
    end
  end
end
