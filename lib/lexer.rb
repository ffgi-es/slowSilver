require_relative 'token'

# opens a file and returns tokenised contents
class Lexer
  def initialize(filename)
    @filename = filename
  end

  def lex
    File.foreach(@filename).with_index.reduce([]) do |tokens, (line, line_num)|
      tokens + line
        .split(/(\s|\.|\(|\)|\[|\]|,|;|'|\|)/)
        .reduce(parts: [], quote: false) { |result, part| combine_quotes(result, part) }[:parts]
        .reject { |s| s =~ /^\s*$/ }
        .map { |part| self.class.lex_part(part, line_num + 1) }
    end
  end

  def combine_quotes(result, part)
    if result[:quote]
      result[:parts].last << part
    else
      result[:parts].push part
    end
    result[:quote] = !result[:quote] if part == "'"
    result
  end

  def self.lex_part(string, line_num)
    Token.create(string, line_num, @lexers) ||
      (raise LexError, "Unknown token '#{string}' on line #{line_num}")
  end

  @lexers = {
    type: proc { |str| str.to_sym },
    identifier: proc { |str| str.gsub(':', '') },
    variable: proc { |str| str },
    integer_constant: proc { |str| str.to_i },
    function_call: proc { |str| str[1..-1] },
    string_constant: proc { |str| str.gsub(/(^'|'$)/, '') },
    boolean_constant: proc { |str| str == 'true' }
  }
end

class LexError < StandardError
end
