require_relative 'return_parser'
require_relative 'expression_parser'

# Create AST clause for a function from tokens
class ClauseParser
  def self.parse(tokens)
    tokens.shift

    params = []

    add_clause_parameter(params, tokens) until end_of_parameters? tokens.first.type

    (return_tokens, condition_tokens) = tokens.slice_before { |x| x.type == :return }.to_a.reverse

    condition = ExpressionParser.parse(condition_tokens[1..-1]) if condition_tokens

    Clause.new(*params, condition, ReturnParser.parse(return_tokens, params))
  end

  class << self
    private

    def end_of_parameters?(type)
      %i[return condition].include? type
    end

    def add_clause_parameter(parameters, tokens)
      case tokens.first.type
      when :integer_constant
        parameters.push IntegerConstant.new(tokens.shift.value)
      when :variable
        parameters.push Parameter.new(tokens.shift.value)
      when :open_list
        tokens.shift
        parameters.push ListParser.parse_parameter(tokens)
      when :separator
        tokens.shift
      else
        raise ParseError, "Unexpected token: '#{tokens.first.type}' on line #{tokens.first.line}"
      end
    end
  end
end
