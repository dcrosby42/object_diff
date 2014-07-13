module ObjectDiff
  module Strategy
    class HashStrategy 

      def applies_to(a,b)
        Hash === a and Hash === b
      end

      def execute(a,b)
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
          d = ObjectDiff.diff(a[key], b[key]) 
          if d
            diffs[key] = d
          end
        end

        if added.keys.empty? and removed.keys.empty? and diffs.keys.empty?
          nil
        else
          HashDiff.new(a,b, diffs, added, removed)
        end
      end
    end
  end
end
