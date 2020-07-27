require_relative 'token'

# opens a file and returns tokenised contents
class Lexer
  def initialize(filename)
    @filename = filename
  end

  def lex
    File.foreach(@filename).reduce([]) do |tokens, line|
      tokens + line
        .split(/(\s|\.|\(|\))/)
        .reject { |s| s =~ /^\s*$/ }
        .map { |part| self.class.lex_part(part) }
    end
  end

  def self.lex_part(string)
    @lexers.each do |key, value|
      result = lex(string, key, value)
      return result unless result.nil?
    end
    raise LexError, "Unknown token '#{string}'"
  end

  def self.lex(string, identifier, value)
    Token.new(identifier, value&.call(string)) if string =~ Token[identifier]
  end

  @lexers = {
    type: proc { |str| str.to_sym },
    identifier: proc { |str| str.gsub(':', '') },
    variable: proc { |str| str },
    return: nil,
    integer_constant: proc { |str| str.to_i },
    end: nil,
    function_call: proc { |str| str[1..-1] },
    open_expression: nil,
    close_expression: nil
  }
end

class LexError < StandardError
end
