require_relative 'declaration_parser'
require_relative 'expression_parser'

# Create AST return from tokens
class ReturnParser
  def self.parse(tokens, params)
    raise ParseError, "Unexpected token: '6'" unless tokens.shift.type == :return
    unless tokens.last&.type == :end || tokens.last&.type == :break
      raise ParseError, "Expected token: '.'"
    end

    tokens.pop

    *declarations, expression = tokens.slice_after { |token| token.type == :separator }.to_a

    Return.new(
      *declarations.map { |dec| DeclarationParser.parse(dec) },
      ExpressionParser.parse(expression, params))
  end
end
