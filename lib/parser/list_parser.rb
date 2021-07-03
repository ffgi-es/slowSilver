# parser for lists
class ListParser
  def self.parse(tokens)
    token = tokens.shift
    return List.empty if token.type == :close_list

    value = ConstantParser.parse_int(token) if token.type == :integer_constant
    # value = Parameter.new(token.value) if token.type == :variable

    token = tokens.shift

    return List.new(value) if token.type == :close_list

    tokens.shift

    list = List.new(value, parse(tokens))

    tokens.shift
    list
  end

  def self.parse_parameter(tokens)
    token = tokens.shift
    return List.empty if token.type == :close_list

    case token.type
    when :integer_constant
      List.new(ConstantParser.parse_int(token))
    when :variable
      head_value = token.value

      token = tokens.shift

      return ListParameter.new(head_value) if token.type == :close_list

      parse_tail(head_value, tokens)
    else
      raise ParseError, "Unexpected token: 'blsf'"
    end
  end

  class << self
    private

    def parse_tail(head, tokens)
      token = tokens.shift
      tokens.shift

      case token.type
      when :variable
        ListParameter.new(head, token.value)
      when :open_list
        ListParameter.new(head, parse(tokens))
      end
    end
  end
end
