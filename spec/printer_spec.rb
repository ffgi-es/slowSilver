require 'pprint'
require 'parser'

describe PPrinter do
  describe '.format' do
    it 'should format an AST to a readable form' do
      ast = ASTree.new(
        Program.new(
          Function.new(
            'main',
            Return.new(
              IntegerConstant.new(4)))))

      output = PPrinter.format(ast)

      expected_output = <<~OUTPUT
        program:
          - func:
            - name: 'main'
            - return:
              - int: 4
      OUTPUT

      expect(output).to eq expected_output
    end
  end
end
