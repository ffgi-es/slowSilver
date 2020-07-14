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
    return "type_#{string}".to_sym if string =~ /^[A-Z]+$/
    lex_id(string)
  end

  def self.lex_id(string)
    return "id_#{string}".to_sym if string =~ /^[a-z]+$/
    lex_return(string)
  end

  def self.lex_return(string)
    return :return if string =~ /^=>$/
    lex_int(string)
  end

  def self.lex_int(string)
    return "cons_int_#{string}".to_sym if string =~ /^[0-9]+$/
    lex_end(string)
  end
  
  def self.lex_end(string)
    return :end if string =~ /^\.$/
  end
end
