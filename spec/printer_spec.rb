require 'pprint'
require 'parser'

describe PPrinter do
  describe '.format' do
    it 'should format return AST to readable form' do
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

    it 'should format expression AST to readable form' do
      ast = ASTree.new(
        Program.new(
          Function.new(
            'main',
            Return.new(
              Expression.new(
                :+,
                IntegerConstant.new(3),
                IntegerConstant.new(4))))))

      output = PPrinter.format(ast)

      expected_output = <<~OUTPUT
        program:
          - func:
            - name: 'main'
            - return:
              - call:
                - name: +
                - params:
                  - int: 3
                  - int: 4
      OUTPUT

      expect(output).to eq expected_output
    end

    it 'should format nested expression AST to readable form' do
      ast = ASTree.new(
        Program.new(
          Function.new(
            'main',
            Return.new(
              Expression.new(
                :-,
                Expression.new(
                  :+,
                  IntegerConstant.new(13),
                  IntegerConstant.new(2)),
                IntegerConstant.new(5))))))

      output = PPrinter.format(ast)

      expected_output = <<~OUTPUT
        program:
          - func:
            - name: 'main'
            - return:
              - call:
                - name: -
                - params:
                  - call:
                    - name: +
                    - params:
                      - int: 13
                      - int: 2
                  - int: 5
      OUTPUT

      expect(output).to eq expected_output
    end
  end
end
