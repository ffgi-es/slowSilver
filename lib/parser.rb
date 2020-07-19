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

      function_call, *arguments = parse_details([], tokens)

      Expression.new(function_call.to_sym, *arguments)
    end

    def parse_details(details, tokens)
      return details if tokens.empty?

      token = tokens.shift
      case token.type
      when :close_expression then return details
      when :open_expression then details.push(parse_exp(tokens))
      when :function_call then details.unshift(token.value)
      when :integer_constant then details.push(parse_int([token]))
      end
      parse_details(details, tokens)
    end

    def parse_int(tokens)
      IntegerConstant.new(tokens.shift.value)
    end
  end
end

class ParseError < StandardError
end
