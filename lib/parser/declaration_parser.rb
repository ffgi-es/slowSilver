class DeclarationParser
  def self.parse(tokens)
    tokens.pop

    Declaration.new(
      tokens.shift.value,
      ExpressionParser.parse(tokens[1..-1]))
  end
end
