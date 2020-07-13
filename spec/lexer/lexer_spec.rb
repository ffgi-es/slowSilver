require "Lexer"

describe "Lexer" do
  describe "#lex" do
    it "should return a list of tokens for sample1.sag" do
      in_file = File.expand_path "sample1.sag", File.dirname(__FILE__)
      out_tokens = ['INT', 'main', 'RETURN', '4', 'END']
      expect(Lexer.lex in_file).to eq out_tokens
    end

    it "should return a list of tokens for sample2.sag" do
      in_file = File.expand_path "sample2.sag", File.dirname(__FILE__)
      out_tokens = ['INT', 'main', 'RETURN', '6', 'END']
      expect(Lexer.lex in_file).to eq out_tokens
    end
  end
end
