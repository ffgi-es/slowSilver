require_relative 'expression_parser'

# Create AST return from tokens
class ReturnParser
  def self.parse(tokens)
    raise ParseError, "Unexpected token: '6'" unless tokens.shift.type == :return
    unless tokens.last&.type == :end || tokens.last&.type == :break
      raise ParseError, "Expected token: '.'"
    end

    tokens.pop

    Return.new(ExpressionParser.parse(tokens))
  end
end
