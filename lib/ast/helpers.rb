# add helper formatting function to String class
class String
  def asm
    gsub(/^(\w+) ?/) { |cmd| "    #{cmd.ljust 8}" }.rstrip << "\n"
  end
end
