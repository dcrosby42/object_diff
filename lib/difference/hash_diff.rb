require 'set'
module Difference

  class HashDiff < Base
    attr_reader :diffs, :added, :removed

    def initialize(a,b,diffs,added,removed)
      super a,b
      @diffs = diffs
      @added = added
      @removed = removed
    end

    def inspect
      kvs = ->((k,v)) { 
        ks = if Symbol === k
               k
             else
               k.inspect
             end
        "#{ks}: #{v.inspect}" 
      }
      hins = ->(h) { h.map(&kvs).join(", ") }
      parts = []
      if @diffs.keys.length > 0
        parts << hins.call(@diffs)
      end
      if @added.keys.length > 0
        parts << "(added #{hins.call(@added)})"
      end
      if @removed.keys.length > 0
        parts << "(removed #{hins.call(@removed)})"
      end
      "{#{parts.join(' ')}}"
    end

    def ==(o)
      base_equal(o) and diffs == o.diffs and added == o.added and removed == o.removed
    end
  end
end
