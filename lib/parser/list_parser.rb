# parser for lists
class ListParser
  def self.parse(tokens)
    token = tokens.shift
    return List.empty if token.type == :close_list

    tokens.shift

    value = ConstantParser.parse_int(token) if token.type == :integer_constant
    value = Parameter.new(token.value) if token.type == :variable

    List.new(value)
  end

  def self.parse_parameter(tokens)
    token = tokens.shift
    return List.empty if token.type == :close_list

    tokens.shift

    case token.type
    when :integer_constant
      List.new(ConstantParser.parse_int(token))
    when :variable
      ListParameter.new(token.value)
    else
      raise ParseError, "Unexpected token: 'blsf'"
    end
  end
end
