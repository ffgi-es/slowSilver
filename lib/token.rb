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
    entry_function_line: /^={3,}$/,
    function_line: /^-{3,}$/,
    return: /^=>$/,
    separator: /^,$/,
    end: /^\.$/,
    integer_constant: /^-?[0-9]+$/,
    function_call: /^:([+-=!*%>]+|[a-z_]+)$/,
    open_expression: /^\($/,
    close_expression: /^\)$/,
    condition: /^\?$/,
    break: /^;$/
  }

  def to_s
    "#{type}: #{@value}"
  end

  def self.create(string, lexers)
    @token_patterns.reduce(nil) do |res, (type, pattern)|
      break Token.new(type, lexers[type]&.call(string)) if string =~ pattern
    end
  end
end
