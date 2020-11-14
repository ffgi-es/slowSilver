require 'pprint'
require 'parser'

describe PPrinter do
  describe '.format' do
    it 'should format return AST to readable form' do
      ast = ASTree.new(
        Program.new(
          Function.new(
            'main',
            { [] => :INT },
            Clause.new(
              nil,
              Return.new(
                IntegerConstant.new(4))))))

      output = PPrinter.format(ast)

      expected_output = <<~OUTPUT
        program:
          - func:
            - name: 'main'
            - type:
              - return: INT
              - input:
            - clause:
              - params:
              - cond:
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
            { [] => :INT },
            Clause.new(
              nil,
              Return.new(
                Expression.new(
                  :+,
                  IntegerConstant.new(3),
                  IntegerConstant.new(4)))))))

      output = PPrinter.format(ast)

      expected_output = <<~OUTPUT
        program:
          - func:
            - name: 'main'
            - type:
              - return: INT
              - input:
            - clause:
              - params:
              - cond:
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
            { [] => :INT },
            Clause.new(
              nil,
              Return.new(
                Expression.new(
                  :-,
                  Expression.new(
                    :+,
                    IntegerConstant.new(13),
                    IntegerConstant.new(2)),
                  IntegerConstant.new(5)))))))

      output = PPrinter.format(ast)

      expected_output = <<~OUTPUT
        program:
          - func:
            - name: 'main'
            - type:
              - return: INT
              - input:
            - clause:
              - params:
              - cond:
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

    it 'should format boolean return AST to readable form' do
      ast = ASTree.new(
        Program.new(
          Function.new(
            'main',
            { [] => :BOOL },
            Clause.new(
              nil,
              Return.new(
                BooleanConstant.new(false))))))

      output = PPrinter.format(ast)

      expected_output = <<~OUTPUT
        program:
          - func:
            - name: 'main'
            - type:
              - return: BOOL
              - input:
            - clause:
              - params:
              - cond:
              - return:
                - bool: false
      OUTPUT

      expect(output).to eq expected_output
    end

    it 'should format variable assignment AST to readable form' do
      ast = ASTree.new(
        Program.new(
          Function.new(
            'main',
            { [] => :INT },
            Clause.new(
              nil,
              Return.new(
                Declaration.new(
                  'A',
                  IntegerConstant.new(3)),
                Expression.new(
                  :*,
                  Variable.new('A'),
                  IntegerConstant.new(5)))))))

      output = PPrinter.format(ast)

      expected_output = <<~OUTPUT
        program:
          - func:
            - name: 'main'
            - type:
              - return: INT
              - input:
            - clause:
              - params:
              - cond:
              - return:
                - declare:
                  - name: A
                  - value:
                    - int: 3
                - call:
                  - name: *
                  - params:
                    - var: A
                    - int: 5
      OUTPUT

      expect(output).to eq expected_output
    end

    it 'should format function definition AST to readable form' do
      ast = ASTree.new(
        Program.new(
          Function.new(
            'main',
            { [] => :INT },
            Clause.new(
              nil,
              Return.new(
                Expression.new(:add)))),
          Function.new(
            'add',
            { %i[INT INT] => :INT },
            Clause.new(
              nil,
              Return.new(
                Expression.new(
                  :+,
                  IntegerConstant.new(3),
                  IntegerConstant.new(4)))))))

      output = PPrinter.format(ast)

      expected_output = <<~OUTPUT
        program:
          - func:
            - name: 'main'
            - type:
              - return: INT
              - input:
            - clause:
              - params:
              - cond:
              - return:
                - call:
                  - name: add
                  - params:
          - func:
            - name: 'add'
            - type:
              - return: INT
              - input: INT, INT
            - clause:
              - params:
              - cond:
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
            { [] => :INT },
            Clause.new(
              nil,
              Return.new(
                Expression.new(
                  :double,
                  IntegerConstant.new(4))))),
          Function.new(
            'double',
            { [:INT] => :INT },
            Clause.new(
              Parameter.new(:X),
              nil,
              Return.new(
                Expression.new(
                  :+,
                  Variable.new(:X),
                  Variable.new(:X)))))))

      output = PPrinter.format(ast)

      expected_output = <<~OUTPUT
        program:
          - func:
            - name: 'main'
            - type:
              - return: INT
              - input:
            - clause:
              - params:
              - cond:
              - return:
                - call:
                  - name: double
                  - params:
                    - int: 4
          - func:
            - name: 'double'
            - type:
              - return: INT
              - input: INT
            - clause:
              - params:
                - name: X
              - cond:
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
            { [] => :INT },
            Clause.new(
              nil,
              Return.new(
                Expression.new(
                  :add,
                  IntegerConstant.new(4),
                  IntegerConstant.new(5))))),
          Function.new(
            'add',
            { %i[INT INT] => :INT },
            Clause.new(
              Parameter.new(:X),
              Parameter.new(:Y),
              nil,
              Return.new(
                Expression.new(
                  :+,
                  Variable.new(:X),
                  Variable.new(:Y)))))))

      output = PPrinter.format(ast)

      expected_output = <<~OUTPUT
        program:
          - func:
            - name: 'main'
            - type:
              - return: INT
              - input:
            - clause:
              - params:
              - cond:
              - return:
                - call:
                  - name: add
                  - params:
                    - int: 4
                    - int: 5
          - func:
            - name: 'add'
            - type:
              - return: INT
              - input: INT, INT
            - clause:
              - params:
                - name: X
                - name: Y
              - cond:
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
            { [] => :INT },
            Clause.new(
              nil,
              Return.new(
                Expression.new(
                  :proc,
                  IntegerConstant.new(4),
                  IntegerConstant.new(5),
                  IntegerConstant.new(6))))),
          Function.new(
            'proc',
            { %i[INT INT INT] => :INT },
            Clause.new(
              Parameter.new(:X),
              Parameter.new(:Y),
              Parameter.new(:Z),
              nil,
              Return.new(
                Expression.new(
                  :-,
                  Variable.new(:X),
                  Expression.new(
                    :add,
                    Variable.new(:Y),
                    Variable.new(:Z)))))),
                  Function.new(
                    'add',
                    { %i[INT INT] => :INT },
                    Clause.new(
                      Parameter.new(:A),
                      Parameter.new(:B),
                      nil,
                      Return.new(
                        Expression.new(
                          :+,
                          Variable.new(:A),
                          Variable.new(:B)))))))

      output = PPrinter.format(ast)

      expected_output = <<~OUTPUT
        program:
          - func:
            - name: 'main'
            - type:
              - return: INT
              - input:
            - clause:
              - params:
              - cond:
              - return:
                - call:
                  - name: proc
                  - params:
                    - int: 4
                    - int: 5
                    - int: 6
          - func:
            - name: 'proc'
            - type:
              - return: INT
              - input: INT, INT, INT
            - clause:
              - params:
                - name: X
                - name: Y
                - name: Z
              - cond:
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
            - type:
              - return: INT
              - input: INT, INT
            - clause:
              - params:
                - name: A
                - name: B
              - cond:
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
            { [] => :INT },
            Clause.new(
              nil,
              Return.new(
                Expression.new(
                  :fib,
                  IntegerConstant.new(7))))),
          Function.new(
            'fib',
            { [:INT] => :INT },
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

      output = PPrinter.format(ast)

      expected_output = <<~OUTPUT
        program:
          - func:
            - name: 'main'
            - type:
              - return: INT
              - input:
            - clause:
              - params:
              - cond:
              - return:
                - call:
                  - name: fib
                  - params:
                    - int: 7
          - func:
            - name: 'fib'
            - type:
              - return: INT
              - input: INT
            - clause:
              - params:
                - int: 0
              - cond:
              - return:
                - int: 0
            - clause:
              - params:
                - int: 1
              - cond:
              - return:
                - int: 1
            - clause:
              - params:
                - name: X
              - cond:
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

    it 'should format function which just returns variable AST to readable form' do
      ast = ASTree.new(
        Program.new(
          Function.new(
            'main',
            { [] => :INT },
            Clause.new(
              nil,
              Return.new(
                Expression.new(
                  :fib,
                  IntegerConstant.new(7))))),
          Function.new(
            'fib',
            { [:INT] => :INT },
            Clause.new(
              Parameter.new(:Var),
              nil,
              Return.new(
                Variable.new(:Var))))))

      output = PPrinter.format(ast)

      expected_output = <<~OUTPUT
        program:
          - func:
            - name: 'main'
            - type:
              - return: INT
              - input:
            - clause:
              - params:
              - cond:
              - return:
                - call:
                  - name: fib
                  - params:
                    - int: 7
          - func:
            - name: 'fib'
            - type:
              - return: INT
              - input: INT
            - clause:
              - params:
                - name: Var
              - cond:
              - return:
                - var: Var
      OUTPUT

      expect(output).to eq expected_output
    end

    it 'should format function with a condition AST to readable form' do
      ast = ASTree.new(
        Program.new(
          Function.new(
            'main',
            { [] => :INT },
            Clause.new(
              nil,
              Return.new(
                Expression.new(
                  :fib,
                  IntegerConstant.new(7))))),
          Function.new(
            'fib',
            { [:INT] => :INT },
            Clause.new(
              Parameter.new(:Var),
              Expression.new(
                :<,
                Variable.new(:Var),
                IntegerConstant.new(3)),
              Return.new(
                Variable.new(:Var))))))

      output = PPrinter.format(ast)

      expected_output = <<~OUTPUT
        program:
          - func:
            - name: 'main'
            - type:
              - return: INT
              - input:
            - clause:
              - params:
              - cond:
              - return:
                - call:
                  - name: fib
                  - params:
                    - int: 7
          - func:
            - name: 'fib'
            - type:
              - return: INT
              - input: INT
            - clause:
              - params:
                - name: Var
              - cond:
                - call:
                  - name: <
                  - params:
                    - var: Var
                    - int: 3
              - return:
                - var: Var
      OUTPUT

      expect(output).to eq expected_output
    end

    it 'should format string constant AST to readable form' do
      ast = ASTree.new(
        Program.new(
          Function.new(
            'main',
            { [] => :INT },
            Clause.new(
              nil,
              Return.new(
                Expression.new(
                  :print,
                  StringConstant.new('Hello, World')))))))

      output = PPrinter.format(ast)

      expected_output = <<~OUTPUT
        program:
          - func:
            - name: 'main'
            - type:
              - return: INT
              - input:
            - clause:
              - params:
              - cond:
              - return:
                - call:
                  - name: print
                  - params:
                    - str: 'Hello, World'
      OUTPUT

      expect(output).to eq expected_output
    end

    it 'should format string constant AST to readable form' do
      ast = ASTree.new(
        Program.new(
          Function.new(
            'main',
            { [] => :INT },
            Clause.new(
              nil,
              Return.new(
                Expression.new(
                  :test,
                  IntegerConstant.new(3),
                  StringConstant.new('hello'))))),
          Function.new(
            'test',
            { %i[INT INT] => :INT },
            Clause.new(
              Parameter.new(:X),
              Parameter.new(:Y),
              nil,
              Return.new(
                Expression.new(
                  :+,
                  Variable.new(:X),
                  Variable.new(:Y)))))))

      output = PPrinter.format(ast)

      expected_output = <<~OUTPUT
        program:
          - func:
            - name: 'main'
            - type:
              - return: INT
              - input:
            - clause:
              - params:
              - cond:
              - return:
                - call:
                  - name: test
                  - params:
                    - int: 3
                    - str: 'hello'
          - func:
            - name: 'test'
            - type:
              - return: INT
              - input: INT, INT
            - clause:
              - params:
                - name: X
                - name: Y
              - cond:
              - return:
                - call:
                  - name: +
                  - params:
                    - var: X
                    - var: Y
      OUTPUT

      expect(output).to eq expected_output
    end
  end
end
