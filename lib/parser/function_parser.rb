require_relative 'clause_parser'

# Create AST function from tokens
class FunctionParser
  def self.parse(tokens)
    parts = tokens
      .slice_after { |t| t.type == :function_line || t.type == :entry_function_line }.to_a

    Function.new(
      *function_details(parts[0]),
      *function_clauses(parts[1]))
  end

  class << self
    private

    def function_details(tokens)
      name = tokens.shift.value

      parts = tokens.slice_after { |t| t.type == :return }.to_a

      [name, { input_types(parts[0]) => parts[1].first.value }]
    end

    def input_types(tokens)
      tokens.each_with_object([]) { |t, arr| arr << t.value if t.type == :type }
    end

    def function_clauses(tokens)
      tokens
        .slice_after { |x| x.type == :break }
        .reduce([]) { |res, clause_tokens| res.push ClauseParser.parse(clause_tokens) }
    end
  end
end
