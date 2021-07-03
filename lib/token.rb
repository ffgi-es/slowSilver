# a representation a single unit of code syntax
class Token
  attr_reader :type, :value, :line

  def initialize(type, line, value = nil)
    @type = type
    @value = value
    @line = line
  end

  def ==(other)
    @type == other.type &&
      @value == other.value &&
      @line == other.line
  end

  @token_patterns = {
    type: /^[A-Z]{2,}(<[A-Z]{2,}>)?$/,
    boolean_constant: /(true|false)/,
    identifier: /^[a-z_]+:?$/,
    variable: /^[A-Z][a-z0-9]*$/,
    entry_function_line: /^={3,}$/,
    function_line: /^-{3,}$/,
    return: /^=>$/,
    assign: /^<=$/,
    separator: /^,$/,
    end: /^\.$/,
    integer_constant: /^-?[0-9]+$/,
    string_constant: /^'.*'$/,
    function_call: /^:([+-=!*%>]+|[a-z_]+)$/,
    open_expression: /^\($/,
    close_expression: /^\)$/,
    condition: /^\?$/,
    break: /^;$/,
    open_list: /^\[$/,
    close_list: /^\]$/,
    chain_line: /^\|$/
  }

  def to_s
    "#{type}: #{value} (line #{line})"
  end

  def self.create(string, line_number, lexers)
    @token_patterns.reduce(nil) do |_, (type, pattern)|
      break Token.new(type, line_number, lexers[type]&.call(string)) if string =~ pattern
    end
  end
end
