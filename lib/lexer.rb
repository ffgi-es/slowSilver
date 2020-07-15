require_relative 'token'

# opens a file and returns tokenised contents
class Lexer
  def initialize(filename)
    @filename = filename
    @lexings = [
      method(:lex_type),
      method(:lex_id),
      method(:lex_return),
      method(:lex_int),
      method(:lex_end)
    ]
  end

  def lex
    File.open @filename, 'r' do |file|
      file.gets
        .split(/(\s|\.)/)
        .reject { |s| s =~ /^\s*$/ }
        .map { |part| lex_part(part) }
    end
  end

  def lex_part(string)
    @lexings.each do |lexing|
      result = lexing.call(string)
      return result unless result.nil?
    end
  end

  def lex_type(string)
    Token.new(:type, string.to_sym) if string =~ /^[A-Z]+$/
  end

  def lex_id(string)
    Token.new(:identifier, string) if string =~ /^[a-z]+$/
  end

  def lex_return(string)
    Token.new(:return) if string =~ /^=>$/
  end

  def lex_int(string)
    Token.new(:integer_constant, string.to_i) if string =~ /^[0-9]+$/
  end

  def lex_end(string)
    Token.new(:end) if string =~ /^\.$/
  end
end