require_relative 'ast'
require_relative 'parser/program_parser'

# Creates an AST from a list of tokens
class Parser
  def self.parse(tokens)
    ASTree.new(ProgramParser.parse(tokens))
  end
end

class ParseError < StandardError
end
