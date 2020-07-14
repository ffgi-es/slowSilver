require 'Token'

class Lexer
  def self.lex(filename)
    File.open filename, "r" do |file|
      file.gets
        .split(/(\s|\.|=>)/)
        .reject { |s| s =~ /^\s*$/ }
        .map { |part| lex_type part }
    end
  end

  def self.lex_type(string)
    return Token.new(:type, string.to_sym) if string =~ /^[A-Z]+$/
    lex_id(string)
  end

  def self.lex_id(string)
    return Token.new(:identifier, string) if string =~ /^[a-z]+$/
    lex_return(string)
  end

  def self.lex_return(string)
    return Token.new(:return) if string =~ /^=>$/
    lex_int(string)
  end

  def self.lex_int(string)
    return Token.new(:integer_constant, string.to_i) if string =~ /^[0-9]+$/
    lex_end(string)
  end
  
  def self.lex_end(string)
    return Token.new(:end) if string =~ /^\.$/
  end
end
