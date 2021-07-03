require_relative 'constant_parser'
require_relative 'list_parser'

# Create AST Expression from tokens
class ExpressionParser
  def self.parse(tokens, params = [])
    raise ParseError, "Unexpected token: '.'" if tokens.nil?
    return parse_simple_exp(*tokens, params) if tokens.length == 1

    parse_function_call(tokens, params)
  end

  @detail_handler = {
    open_expression: proc { |details, _, tokens, params| details.push(parse(tokens, params)) },
    close_expression: proc { |_, _, _, _| nil },
    open_list: proc { |details, _, tokens, _| details.push(ListParser.parse(tokens)) },
    function_call: proc { |details, token, _, _| details.unshift(token.value) },
    integer_constant: proc { |details, token, _, _|
      details.push(ConstantParser.parse_int(token))
    },
    string_constant: proc { |details, token, _, _|
      details.push(ConstantParser.parse_string(token))
    },
    boolean_constant: proc { |details, token, _, _|
      details.push(ConstantParser.parse_bool(token))
    },
    variable: proc { |details, token, _, params|
      details.push(ConstantParser.parse_var(token, params))
    }
  }

  class << self
    private

    def parse_simple_exp(token, params)
      return ConstantParser.parse_int(token) if token.type == :integer_constant
      return ConstantParser.parse_bool(token) if token.type == :boolean_constant
      return ConstantParser.parse_string(token) if token.type == :string_constant
      return ConstantParser.parse_var(token, params) if token.type == :variable

      parse_function_call([token], params)
    end

    def parse_function_call(tokens, params)
      function_call, *arguments = parse_details([], tokens, params)

      Expression.new(function_call.to_sym, *arguments)
    end

    def parse_details(details, tokens, params)
      return details if tokens.empty?

      if detail_handler(details, tokens.shift, tokens, params)
        parse_details(details, tokens, params)
      end

      details
    end

    def detail_handler(details, token, tokens, params)
      @detail_handler[token.type].call(details, token, tokens, params)
    end
  end
end
