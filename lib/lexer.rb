require_relative 'token'

# opens a file and returns tokenised contents
class Lexer
  def self.lex(filename)
    File.open filename, 'r' do |file|
      file.gets
        .split(/(\s|\.)/)
        .reject { |s| s =~ /^\s*$/ }
        .map { |part| lex_part(part, @@lexings) }
    end
  end

  def self.lex_part(string, lexings)
    lexings.each do |lexing|
      result = lexing.call(string)
      return result unless result.nil?
    end
  end

  def self.lex_type(string)
    Token.new(:type, string.to_sym) if string =~ /^[A-Z]+$/
  end

  def self.lex_id(string)
    Token.new(:identifier, string) if string =~ /^[a-z]+$/
  end

  def self.lex_return(string)
    Token.new(:return) if string =~ /^=>$/
  end

  def self.lex_int(string)
    Token.new(:integer_constant, string.to_i) if string =~ /^[0-9]+$/
  end

  def self.lex_end(string)
    Token.new(:end) if string =~ /^\.$/
  end

  @@lexings = [
    method(:lex_type),
    method(:lex_id),
    method(:lex_return),
    method(:lex_int),
    method(:lex_end)
  ]
end
