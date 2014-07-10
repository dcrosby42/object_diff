require 'set'
module Rdiff
  class Diff
    attr_reader :a, :b
    def initialize(a,b)
      @a = a
      @b = b
    end
    def changes
      []
    end

    def ==(o)
      o and o.class == self.class and a == o.a and b == o.b
    end
    alias_method :eq, :==

    def to_s
      inspect
    end
    def inspect
      "<#{a.inspect}->#{b.inspect}>"
    end
  end

  class HashDiff < Diff
    def initialize(a,b,diffs,added,lost)
      super a,b
      @diffs = diffs
      @added = added
      @lost = lost
      @changes = []
    end
    def changes
      @changes
    end

    def inspect
      @diffs.inspect
    end
  end

  class ArrayDiff < Diff
    def initialize(a,b,adds,drops)
      super a,b
      @adds = adds
      @drops = drops
      @changes = []
    end
    def changes
      @changes
    end
  end

  class << self

    def diff(a,b)
      if Hash === a and Hash === b
        diff_hash(a, b)
      elsif Array === a and Array === b
        diff_array(a,b)
      else
        diff_scalar_value(a,b)
      end
    end

    private

    def make_diff(a,b)
      Diff.new(a,b)
    end

    def make_hash_diff(a,b,diffs,adds,drops)
      HashDiff.new(a,b,diffs,adds,drops)
    end

    def make_array_diff(a,b,adds,drops)
      ArrayDiff.new(a,b,adds,drops)
    end

    def diff_scalar_value(a,b)
      if a != b
        make_diff a, b
      else
        nil
      end
    end

    def diff_hash(a,b)
      a_keys = a.keys
      b_keys = b.keys
      new_keys = b_keys - a_keys
      missing_keys = a_keys - b_keys
      shared_keys = (Set.new(a_keys) & Set.new(b_keys)).to_a.sort
      # all_keys = Set.new(a_keys + b_keys).to_a.sort

      adds = new_keys.map do |key| b[key] end
      drops = missing_keys.map do |key| a[key] end
      diffs = {}
      shared_keys.each do |key| 
        d = diff(a[key], b[key]) 
        if d
          diffs[key] = d
        end
      end

      if adds.empty? and drops.empty? and diffs.keys.empty?
        nil
      else
        make_hash_diff a,b, diffs, adds, drops
      end
    end

    def diff_array(a,b)
      new_items = b - a
      missing_items = a - b
      if new_items.empty? and missing_items.empty?  
        nil
      else
        make_array_diff a,b, new_items, missing_items
      end
    end
  end
end
