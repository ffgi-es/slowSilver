# a dictionary to hold function type definitions
class FunctionDictionary
  @dictionary = Hash.new { Hash.new }

  def self.[](function_name)
    @dictionary[function_name]
  end

  def self.add(name, type_signature)
    @dictionary[name] = type_signature
  end

  @dictionary[:+] = { %i[INT INT] => :INT }
  @dictionary[:%] = { %i[INT INT] => :INT }
end
