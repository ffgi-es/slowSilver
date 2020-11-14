require_relative 'constant_parser'

# Create AST Expression from tokens
class ExpressionParser
  def self.parse(tokens)
    raise ParseError, "Unexpected token: '.'" if tokens.nil?
    return parse_simple_exp(*tokens) if tokens.length == 1

    parse_function_call(tokens)
  end

  @detail_handler = {
    close_expression: proc { |_, _, _| nil },
    open_expression: proc { |details, _, tokens| details.push(parse(tokens)) },
    function_call: proc { |details, token, _| details.unshift(token.value) },
    integer_constant: proc { |details, token, _| details.push(ConstantParser.parse_int(token)) },
    string_constant: proc { |details, token, _| details.push(ConstantParser.parse_string(token)) },
    variable: proc { |details, token, _| details.push(ConstantParser.parse_var(token)) }
  }

  class << self
    private

    def parse_simple_exp(token)
      return ConstantParser.parse_int(token) if token.type == :integer_constant
      return ConstantParser.parse_bool(token) if token.type == :boolean_constant
      return ConstantParser.parse_string(token) if token.type == :string_constant
      return ConstantParser.parse_var(token) if token.type == :variable

      parse_function_call([token])
    end

    def parse_function_call(tokens)
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
  end
end
