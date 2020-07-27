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

    it 'should format function definition AST to readable form' do
      ast = ASTree.new(
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

      output = PPrinter.format(ast)

      expected_output = <<~OUTPUT
        program:
          - func:
            - name: 'main'
            - return:
              - call:
                - name: add
                - params:
          - func:
            - name: 'add'
            - return:
              - call:
                - name: +
                - params:
                  - int: 3
                  - int: 4
      OUTPUT

      expect(output).to eq expected_output
    end

    it 'should format function definition with a parameter AST to readable form' do
      ast = ASTree.new(
        Program.new(
          Function.new(
            'main',
            Return.new(
              Expression.new(
                :double,
                IntegerConstant.new(4)))),
          Function.new(
            'add',
            Parameter.new(:X),
            Return.new(
              Expression.new(
                :+,
                Variable.new(:X),
                Variable.new(:X))))))

      output = PPrinter.format(ast)

      expected_output = <<~OUTPUT
        program:
          - func:
            - name: 'main'
            - return:
              - call:
                - name: double
                - params:
                  - int: 4
          - func:
            - name: 'add'
            - params:
              - name: X
            - return:
              - call:
                - name: +
                - params:
                  - var: X
                  - var: X
      OUTPUT

      expect(output).to eq expected_output
    end
  end
end
