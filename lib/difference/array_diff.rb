module Difference
  class ArrayDiff < Diff
    attr_reader :diffs
    def initialize(a,b,diffs)
      super a,b
      @diffs = diffs
    end
    def inspect
      s = @diffs.map do |i,d|
        "#{i}: #{d}"
      end.join(", ")
      "[#{s}]"
    end
    def ==(o)
      super(o) and diffs == o.diffs
    end
  end
end
