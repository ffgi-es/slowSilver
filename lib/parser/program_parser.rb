require_relative 'function_parser'

# Create program part of AST from tokens
class ProgramParser
  def self.parse(tokens)
    funcs = tokens.slice_after { |x| x.type == :end }
    Program.new(
      FunctionParser.parse(funcs.first),
      *funcs.drop(1).map { |func| FunctionParser.parse(func) })
  end
end
