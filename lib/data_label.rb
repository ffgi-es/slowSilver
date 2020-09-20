# a helper class to enumerate data section labels
class DataLabel
  @indices = Hash.new(-1)

  class << self
    def indexed(label)
      "#{label}#{@indices[label] += 1}"
    end

    def reset
      @indices = Hash.new(-1)
    end
  end
end
