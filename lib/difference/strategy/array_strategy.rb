module Difference
  module Strategy
    class ArrayStrategy

      def applies_to(a,b)
        Array === a and Array === b
      end

      def execute(a_arr,b_arr)
        left = a_arr.clone
        short = b_arr.length - left.length
        if short > 0
          left += [nil]*3
        end

        diffs = {}
        left.zip(b_arr).each.with_index do |(a,b),i|
          if d = Difference.diff(a,b)
            diffs[i] = d
          end
        end
        diffs
        if diffs.keys.empty?
          nil
        else
          ArrayDiff.new(a_arr, b_arr, diffs)
        end
      end
    end
  end
end
