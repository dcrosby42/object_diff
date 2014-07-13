module ObjectDiff
  class ScalarDiff < Base
    def ==(o)
      base_equal o
    end

    def inspect
      "#{a.inspect}->#{b.inspect}"
    end
  end
end
