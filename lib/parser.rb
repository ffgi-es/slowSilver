require_relative 'ast'

# Creates an AST from a list of tokens
class Parser
  def self.parse(tokens)
    ASTree.new(parse_program(tokens))
  end

  @detail_handler = {
    close_expression: proc { |_, _, _| nil },
    open_expression: proc { |details, _, tokens| details.push(parse_exp(tokens)) },
    function_call: proc { |details, token, _| details.unshift(token.value) },
    integer_constant: proc { |details, token, _| details.push(parse_int([token])) },
    variable: proc { |details, token, _| details.push(parse_var(token)) }
  }

  class << self
    private

    def parse_program(tokens)
      funcs = tokens.slice_after(Token.new(:end))
      Program.new(
        parse_function(funcs.first),
        *funcs.drop(1).map { |func| parse_function(func) })
    end

    def parse_function(tokens)
      raise ParseError, "Unexpected token: 'main'" unless tokens.shift.type == :type

      name = tokens.shift.value

      params = []
      while tokens.first.type == :type
        tokens.shift
        params.push Parameter.new(tokens.shift.value)
        tokens.shift if tokens.first.type == :separator
      end

      Function.new(name, *params, parse_ret(tokens))
    end

    def parse_ret(tokens)
      raise ParseError, "Unexpected token: '6'" unless tokens.shift.type == :return
      raise ParseError, "Expected token: '.'" unless tokens.pop&.type == :end

      Return.new(parse_exp(tokens))
    end

    def parse_exp(tokens)
      raise ParseError, "Unexpected token: '.'" if tokens.first.nil?
      return parse_int(tokens) if tokens.length == 1 && tokens.first.type == :integer_constant

      function_call, *arguments = parse_details([], tokens)

      Expression.new(function_call.to_sym, *arguments)
    end

    def parse_details(details, tokens)
      return details if tokens.empty?

      parse_details(details, tokens) if detail_handler(details, tokens.shift, tokens)

      details
    end

    def detail_handler(details, token, tokens)
      @detail_handler[token.type].call(details, token, tokens)
    end

    def parse_int(tokens)
      IntegerConstant.new(tokens.shift.value)
    end

    def parse_var(token)
      Variable.new(token.value)
    end
  end
end

class ParseError < StandardError
end
