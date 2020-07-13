class Lexer
  def self.lex(filename)
    File.open filename, "r" do |file|
      line = file.gets
      line.split
        .map { |part| part.gsub(/=>/, 'RETURN') }
        .map { |part| part.split /(\.)/ }
        .flatten
        .map { |part| part.gsub('.', 'END') }
    end
  end
end
