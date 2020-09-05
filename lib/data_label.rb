# a helper class to enumerate data section labels
class DataLabel
  @indices = Hash.new(0)

  class << self
    def indexed(label)
      index = @indices[label]
      @indices[label] += 1
      "#{label}#{index}"
    end

    def reset
      @indices = Hash.new(0)
    end
  end
end
