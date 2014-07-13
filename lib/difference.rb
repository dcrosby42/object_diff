module Difference
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

    def make_array_diff(a,b,diffs)
      ArrayDiff.new(a,b,diffs)
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

      added = {}
      new_keys.each do |k|
        added[k] = b[k]
      end

      removed = {}
      missing_keys.each do |k|
        removed[k] = a[k]
      end

      diffs = {}
      shared_keys.each do |key| 
        d = diff(a[key], b[key]) 
        if d
          diffs[key] = d
        end
      end

      if added.keys.empty? and removed.keys.empty? and diffs.keys.empty?
        nil
      else
        make_hash_diff a,b, diffs, added, removed
      end
    end

    def diff_array(a_arr,b_arr)
      left = a_arr.clone
      short = b_arr.length - left.length
      if short > 0
        left += [nil]*3
      end

      diffs = {}
      left.zip(b_arr).each.with_index do |(a,b),i|
        if d = diff(a,b)
          diffs[i] = d
        end
      end
      diffs
      if diffs.keys.empty?
        nil
      else
        make_array_diff(a_arr, b_arr, diffs)
      end
    end
  end
end

require_relative 'difference/base'
require_relative 'difference/diff'
require_relative 'difference/hash_diff'
require_relative 'difference/array_diff'
