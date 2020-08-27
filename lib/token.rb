# a representation a single unit of code syntax
class Token
  attr_reader :type, :value

  def initialize(type, value = nil)
    @type = type
    @value = value
  end

  def ==(other)
    @type == other.type &&
      @value == other.value
  end

  @token_patterns = {
    type: /^[A-Z]{2,}$/,
    identifier: /^[a-z_]+:?$/,
    variable: /^[A-Z][a-z0-9]*$/,
    return: /^=>$/,
    separator: /^,$/,
    end: /^\.$/,
    integer_constant: /^-?[0-9]+$/,
    function_call: /^:([+-=!*%>]+|[a-z_]+)$/,
    open_expression: /^\($/,
    close_expression: /^\)$/,
    break: /^;$/
  }

  def self.[](type)
    @token_patterns[type]
  end
end
