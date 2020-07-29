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
    identifier: /^[a-z]+:?$/,
    variable: /^[A-Z]$/,
    return: /^=>$/,
    separator: /^,$/,
    end: /^\.$/,
    integer_constant: /^-?[0-9]+$/,
    function_call: /^:([+-=!]|[a-z]+)$/,
    open_expression: /^\($/,
    close_expression: /^\)$/
  }

  def self.[](type)
    @token_patterns[type]
  end
end
