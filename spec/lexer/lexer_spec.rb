require "Lexer"

describe "Lexer" do
  describe "#lex" do
    it "should return a list of tokens for sample1.sag" do
      in_file = "sample1.sag"
      out_tokens = ['INT', 'main', 'RETURN', '4']
      expect(Lexer.lex in_file).to eq out_tokens
    end
  end
end
