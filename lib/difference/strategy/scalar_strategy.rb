module Difference
  module Strategy
    class ScalarStrategy
      def applies_to(a,b)
        # Can apply to any object, so use this one last
        true
      end

      def execute(a,b)
        if a != b
          ScalarDiff.new(a,b)
        else
          nil
        end
      end
    end
  end
end
