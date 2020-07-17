require_relative 'ast'

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
        when :integer_constant then arguments.push(parse_int(tokens))
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
