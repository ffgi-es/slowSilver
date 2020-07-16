# Creates an AST from a list of tokens
class Parser
  def self.parse(tokens)
    ASTree.new(parse_program(tokens))
  end

  class << self
    private

    def parse_program(tokens)
      Program.new(parse_function(tokens))
    end

    def parse_function(tokens)
      raise ParseError, "Unexpected token: 'main'" unless tokens.shift.type == :type

      Function.new(tokens.shift.value, parse_ret(tokens))
    end

    def parse_ret(tokens)
      raise ParseError, "Unexpected token: '6'" unless tokens.shift.type == :return
      raise ParseError, "Expected token: '.'" unless tokens.pop&.type == :end

      Return.new(parse_exp(tokens))
    end

    def parse_exp(tokens)
      raise ParseError, "Unexpected token: '.'" if tokens.first.nil?
      return parse_int(tokens) if tokens.length == 1

      function_call = nil
      arguments = []

      until tokens.first.nil?
        case tokens.first.type
        when :function_call then function_call = tokens.shift.value
        when :integer_constant then arguments.push(tokens.shift.value)
        end
      end

      Expression.new(function_call.to_sym, *arguments)
    end

    def parse_int(tokens)
      IntegerConstant.new(tokens.shift.value)
    end
  end
end

class ParseError < StandardError
end

# root of the AST
class ASTree
  attr_reader :program

  def initialize(program)
    @program = program
  end
end

# The program of the AST
class Program
  attr_reader :function

  def initialize(function)
    @function = function
  end
end

# A function in the program
class Function
  attr_reader :name, :return

  def initialize(name, return_exp)
    @name = name
    @return = return_exp
  end
end

# what a function returns
class Return
  attr_reader :expression

  def initialize(expression)
    @expression = expression
  end
end

class Expression
  attr_reader :function, :parameters

  def initialize(function, param1, param2)
    @function = function
    @parameters = [param1, param2]
  end
end

# a constant integer value
class IntegerConstant
  attr_reader :value

  def initialize(value)
    @value = value
  end
end
