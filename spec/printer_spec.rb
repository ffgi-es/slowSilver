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
            'double',
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
            - name: 'double'
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

    it 'should format function definition with two parameters AST to readable form' do
      ast = ASTree.new(
        Program.new(
          Function.new(
            'main',
            Return.new(
              Expression.new(
                :add,
                IntegerConstant.new(4),
                IntegerConstant.new(5)))),
          Function.new(
            'add',
            Parameter.new(:X),
            Parameter.new(:Y),
            Return.new(
              Expression.new(
                :+,
                Variable.new(:X),
                Variable.new(:Y))))))

      output = PPrinter.format(ast)

      expected_output = <<~OUTPUT
        program:
          - func:
            - name: 'main'
            - return:
              - call:
                - name: add
                - params:
                  - int: 4
                  - int: 5
          - func:
            - name: 'add'
            - params:
              - name: X
              - name: Y
            - return:
              - call:
                - name: +
                - params:
                  - var: X
                  - var: Y
      OUTPUT

      expect(output).to eq expected_output
    end

    it 'should format multiple function definitions AST to readable form' do
      ast = ASTree.new(
        Program.new(
          Function.new(
            'main',
            Return.new(
              Expression.new(
                :proc,
                IntegerConstant.new(4),
                IntegerConstant.new(5),
                IntegerConstant.new(6)))),
          Function.new(
            'proc',
            Parameter.new(:X),
            Parameter.new(:Y),
            Parameter.new(:Z),
            Return.new(
              Expression.new(
                :-,
                Variable.new(:X),
                Expression.new(
                  :add,
                  Variable.new(:Y),
                  Variable.new(:Z))))),
          Function.new(
            'add',
            Parameter.new(:A),
            Parameter.new(:B),
            Return.new(
              Expression.new(
                :+,
                Variable.new(:A),
                Variable.new(:B))))))

      output = PPrinter.format(ast)

      expected_output = <<~OUTPUT
        program:
          - func:
            - name: 'main'
            - return:
              - call:
                - name: proc
                - params:
                  - int: 4
                  - int: 5
                  - int: 6
          - func:
            - name: 'proc'
            - params:
              - name: X
              - name: Y
              - name: Z
            - return:
              - call:
                - name: -
                - params:
                  - var: X
                  - call:
                    - name: add
                    - params:
                      - var: Y
                      - var: Z
          - func:
            - name: 'add'
            - params:
              - name: A
              - name: B
            - return:
              - call:
                - name: +
                - params:
                  - var: A
                  - var: B
      OUTPUT

      expect(output).to eq expected_output
    end
    
    it 'should format param matching function definition AST to readable form' do
      ast = ASTree.new(
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

      output = PPrinter.format(ast)

      expected_output = <<~OUTPUT
        program:
          - func:
            - name: 'main'
            - return:
              - call:
                - name: fib
                - params:
                  - int: 7
          - match-func:
            - name: 'fib'
            - clause:
              - params:
                - int: 0
              - return:
                - int: 0
            - clause:
              - params:
                - int: 1
              - return:
                - int: 1
            - clause:
              - params:
                - name: X
              - return:
                - call:
                  - name: +
                  - params:
                    - call:
                      - name: fib
                      - params:
                        - call:
                          - name: -
                          - params:
                            - var: X
                            - int: 1
                    - call:
                      - name: fib
                      - params:
                        - call:
                          - name: -
                          - params:
                            - var: X
                            - int: 2
      OUTPUT

      expect(output).to eq expected_output
    end
  end
end
