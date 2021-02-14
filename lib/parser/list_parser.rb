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
end
